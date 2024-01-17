//
//  QDControl3.swift
//  qd-control-2
//
//  Created by Edward Janne on 1/5/24.
//

import Foundation
import simd

@Observable class QDControl3 {
	
	var qdRobot: QDRobot
	var qdClient: QDClient
	
	var alive: Bool = false
	var translation: simd_float4 = .zero
	var rotation: Float32 = 0.0
	var stepScale: Float32 = 100.0
	var stepHeight: Float32 = 50.0
	var bodySway: Float32 = 0.0
	var bodyHeight: Float32 = 80.0
	var duration: Float32 = 2.0
	
	var lastTime: DispatchTime
	
	init(robot: QDRobot, client: QDClient) {
		qdRobot = robot
		qdClient = client
		lastTime = .distantFuture
	}
	
	func start() {
		alive = true
		tick()
	}
	
	func tick() {
		if alive {
			let msg = QDCtrlMsg(translation: translation, rotation: rotation, stepScale: stepScale, stepHeight: stepHeight, bodySway: bodySway, bodyHeight: bodyHeight, duration: duration)
			let encoder = QDEncoder(capacity: 32)
			encoder.encode(msg)
			print("Sending \(msg)")
			qdClient.send(message: encoder.data)
			DispatchQueue.main.asyncAfter(deadline: .now().advanced(by: .milliseconds(250))) {
				[unowned self] in
				tick()
			}
		}
	}
	
	func stop() {
		alive = false
	}
}
