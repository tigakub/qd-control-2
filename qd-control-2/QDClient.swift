//
//  QDClient.swift
//  qd-control
//
//  Created by Edward Janne on 10/25/23.
//

import Foundation
import Network
import SystemConfiguration.CaptiveNetwork
import CoreLocation
import SwiftUI

struct NetworkInfo {
	var interface: String
	var success: Bool = false
	var ssid: String?
	var bssid: String?
}

@Observable
class QDClient: NSObject {
	var locationManager = CLLocationManager()
	var currentNetworkInfos: Array<NetworkInfo>? {
		get {
			return fetchNetworkInfo()
		}
	}
	var status: CLAuthorizationStatus {
		get {
			return locationManager.authorizationStatus
		}
	}
	var ssid: String = ""
	var bssid: String = ""
    
    var cnx: NWConnection? = nil
    var listener: NWListener? = nil
    
    init(localPort: UInt16) {
        do {
            listener = try NWListener(using: .udp, on: NWEndpoint.Port(integerLiteral: localPort))
        } catch(let e) {
			print("Unable to start UDP listener: \(e.localizedDescription)")
            // throw Exception(file: #file, function: #function, line: #line, message: e.localizedDescription)
        }
        
		super.init()
    }
    
    func connect(remoteEndpoint: NWEndpoint, completion: @escaping (NWConnection.State)->()) {
		if cnx == nil {
			let cnx = NWConnection(to: remoteEndpoint, using: .udp)
			cnx.stateUpdateHandler = completion
			self.cnx = cnx
		}
    }
    
    func start(recvHandler: @escaping (NWConnection)->()) {
        if let listener = listener {
			listener.newConnectionHandler = recvHandler
		}
        if let cnx = cnx {
			cnx.start(queue: .global())
		}
    }
    
    func stop() {
		if let cnx = cnx {
			cnx.cancel()
			self.cnx = nil
		}
    }
    
    func send(message: Data) {
		if let cnx = cnx {
			cnx.send(
				content: message,
				completion: .contentProcessed {
					error in
					if let error = error {
						print(error.localizedDescription)
					} else {
						print("Sent")
					}
				}
			)
		}
    }
}

extension QDClient: CLLocationManagerDelegate {
	func authorizeWifiInfo() {
		switch status {
			case .authorizedAlways: fallthrough
			case .authorizedWhenInUse:
				updateWifi()
			default:
				locationManager.delegate = self
				locationManager.requestWhenInUseAuthorization()
		}
    }
	
	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		switch status {
			case .authorizedAlways: fallthrough
			case .authorizedWhenInUse:
				updateWifi()
			default:
				break
		}
	}
	
	func fetchNetworkInfo()->[NetworkInfo]? {
		if let interfaces = CNCopySupportedInterfaces() {
			var networkInfos = [NetworkInfo]()
			for interface in interfaces as! [CFString] {
				let interfaceName = interface as String
				var networkInfo = NetworkInfo(
										interface: interfaceName,
										success: false,
										ssid: nil,
										bssid: nil)
				if let dict: NSDictionary = CNCopyCurrentNetworkInfo(interfaceName as CFString) {
					networkInfo.success = true
					networkInfo.ssid = dict[kCNNetworkInfoKeySSID as NSString] as? String
					networkInfo.bssid = dict[kCNNetworkInfoKeyBSSID as NSString] as? String
				}
				networkInfos.append(networkInfo)
			}
			return networkInfos
		}
		return nil
	}
	
	func updateWifi() {
		print("SSID: \(currentNetworkInfos?.first?.ssid ?? "")")
		if let ssid = currentNetworkInfos?.first?.ssid {
			self.ssid = ssid
		}
		if let bssid = currentNetworkInfos?.first?.bssid {
			self.bssid = bssid
		}
	}
}
