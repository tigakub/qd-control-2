//
//  qd_control_2App.swift
//  qd-control-2
//
//  Created by Edward Janne on 1/3/24.
//

import SwiftUI
import simd
import Network

// Circuit Launch
let remoteHost = "192.168.4.1"
// Home
// let remoteHost = "192.168.7.220"

let remoteIP = IPv4Address(remoteHost)!
let remotePort = UInt16(3567)

let bodyHeight: Float = 80.0

let qdRobot = QDRobot(
	bodyHeight: bodyHeight,
    hipToShoulder: 42.0,
    shoulderToElbow: 42.0,
    elbowToToe: 73.0,
    frontRightRoot  : simd_float4( 29.0, 0.0,  75.0, 0.0),
    frontLeftRoot   : simd_float4(-29.0, 0.0,  75.0, 0.0),
    backRightRoot   : simd_float4( 29.0, 0.0, -75.0, 0.0),
    backLeftRoot    : simd_float4(-29.0, 0.0, -75.0, 0.0),
	frontRight  : simd_float4(x:  71.0, y: -bodyHeight, z:  75.0, w: 0.0),
	frontLeft   : simd_float4(x: -71.0, y: -bodyHeight, z:  75.0, w: 0.0),
	backRight   : simd_float4(x:  71.0, y: -bodyHeight, z: -75.0, w: 0.0),
	backLeft    : simd_float4(x: -71.0, y: -bodyHeight, z: -75.0, w: 0.0))

let qdControl = QDControl2(robot: qdRobot, client: qdClient)

let qdClient = QDClient(localPort: 3567, remoteEndpoint: NWEndpoint.hostPort(host: .ipv4(remoteIP), port: NWEndpoint.Port(integerLiteral: remotePort)))

@main
struct qd_control_2App: App {
    var body: some Scene {
        WindowGroup {
            ContentView(qdControl: qdControl, qdRobot: qdRobot, qdClient: qdClient)
        }
    }
}
