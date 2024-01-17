//
//  WifiInfo.swift
//  qd-control-2
//
//  Created by Edward Janne on 1/5/24.
//

import Foundation
import Network
import NetworkExtension
import SystemConfiguration.CaptiveNetwork
import CoreLocation

class WifiInfo: NSObject & CLLocationManagerDelegate {
	var locationManager = CLLocationManager()
	var status: CLAuthorizationStatus {
		get {
			return locationManager.authorizationStatus
		}
	}
	
	var success: Bool = false
	var ssid: String?
	var completion: ((WifiInfo)->())? = nil
	
	override init() {
		super.init()
	}
	
	func authorizeWifiInfo(_ completion: @escaping (WifiInfo)->()) {
		self.completion = completion
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
	
	func updateWifi() {
		success = false
		NEHotspotNetwork.fetchCurrent {
			hotspot in
			if let ssid = hotspot?.ssid {
				self.ssid = ssid
				if let completion = self.completion {
					completion(self)
				}
			}
		}
	}
}

