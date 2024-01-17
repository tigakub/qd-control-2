//
//  QDControl2.swift
//  qd-control-2
//
//  Created by Edward Janne on 1/3/24.
//

import Foundation
import simd

@Observable class QDControl2 {
	
	enum Mode {
		case idle
		case starting
		case walking
		case stopping1
		case stopping2
	}
	
	var qdRobot: QDRobot
	var qdClient: QDClient
	
	var mode: Mode = .idle
	let idleStance: Stance
	var currentStance: Stance
	var currentSide: Stance.Side
	var lastTime: DispatchTime
	var translation: simd_float4 = .zero
	var rotation: Float = 0.0
	var stepDuration: Float = 2.0
	var stepCount: UInt32 = 0

	init(robot: QDRobot, client: QDClient) {
		qdRobot = robot
		qdClient = client
		
		idleStance = Stance([], centroid: simd_float4(x: 0.0, y: 0.0, z: 0.0, w: 1.0), tangent: .k, orthogonal: .i, progress: 0.0, stepSize: 0.0)
		currentStance = Stance(idleStance)
		currentSide = .frbl
		
		lastTime = .now()
	}
	
	func start() {
		switch mode {
			case .idle:
				stepCount = 0
				mode = .starting
				lastTime = .now()
				tick()
			default:
				break
		}
	}
	
	func tick() {
		switch mode {
			case .starting:
				currentSide = .frbl
				if translation.x < 0.0 {
					currentSide = .flbr
				}
				mode = .walking
			case .walking:
				if currentSide == .frbl {
					currentSide = .flbr
				} else {
					currentSide = .frbl
				}
				let currentTime: DispatchTime = .now()
				DispatchQueue.main.asyncAfter(deadline: currentTime.advanced(by: .milliseconds(Int(stepDuration * 1000.0)))) {
					[unowned self] in
					tick()
				}
			default:
				return
		}
		
		var nextStance = currentStance.newStance(side: currentSide, translation: translation, rotation: rotation)
		let encoder = QDEncoder(capacity: 36)
		switch currentSide {
			case .frbl:
				let newPose = QDPose2(side: QDMsgType.pose2RL.rawValue, id: stepCount, front: nextStance.targets[0], back: nextStance.targets[3], stepHeight: 50.0, bodySway: 0.0, duration: 2000)
				encoder.encode(newPose)
			case .flbr:
				let newPose = QDPose2(side: QDMsgType.pose2LR.rawValue, id: stepCount, front: nextStance.targets[1], back: nextStance.targets[2], stepHeight: 50.0, bodySway: 0.0, duration: 2000)
				encoder.encode(newPose)
		}
		qdClient.send(message: encoder.data)
		stepCount += 1
		currentStance = nextStance
	}
	
	func stop() {
		mode = .stopping1
		stop1()
	}
	
	func stop1() {
		if currentSide == .frbl {
			currentSide = .flbr
		} else {
			currentSide = .frbl
		}
		let encoder = QDEncoder()
		switch currentSide {
			case .frbl:
				currentStance.targets[0] = idleStance.targets[0]
				currentStance.targets[3] = idleStance.targets[3]
				let newPose = QDPose2(side: QDMsgType.pose2RL.rawValue, id: stepCount, front: currentStance.targets[0], back: currentStance.targets[3], stepHeight: 50.0, bodySway: 0.0, duration: 2000)
				encoder.encode(newPose)
			case .flbr:
				currentStance.targets[1] = idleStance.targets[1]
				currentStance.targets[2] = idleStance.targets[2]
				let newPose = QDPose2(side: QDMsgType.pose2LR.rawValue, id: stepCount, front: currentStance.targets[1], back: currentStance.targets[2], stepHeight: 50.0, bodySway: 0.0, duration: 2000)
				encoder.encode(newPose)
		}
		qdClient.send(message: encoder.data)
		stepCount += 1
		if mode == .stopping1 {
			mode = .stopping2
			let currentTime: DispatchTime = .now()
			DispatchQueue.main.asyncAfter(deadline: currentTime.advanced(by: .milliseconds(Int(stepDuration * 1000.0)))) {
				[unowned self] in
				stop2()
			}
		}
	}
	
	func stop2() {
		if currentSide == .frbl {
			currentSide = .flbr
		} else {
			currentSide = .frbl
		}
		let encoder = QDEncoder()
		switch currentSide {
			case .frbl:
				currentStance.targets[0] = idleStance.targets[0]
				currentStance.targets[3] = idleStance.targets[3]
				let newPose = QDPose2(side: QDMsgType.pose2RL.rawValue, id: stepCount, front: currentStance.targets[0], back: currentStance.targets[3], stepHeight: 50.0, bodySway: 0.0, duration: 2000)
				encoder.encode(newPose)
			case .flbr:
				currentStance.targets[1] = idleStance.targets[1]
				currentStance.targets[2] = idleStance.targets[2]
				let newPose = QDPose2(side: QDMsgType.pose2LR.rawValue, id: stepCount, front: currentStance.targets[1], back: currentStance.targets[2], stepHeight: 50.0, bodySway: 0.0, duration: 2000)
				encoder.encode(newPose)
		}
		qdClient.send(message: encoder.data)
		stepCount += 1
		if mode == .stopping2 {
			mode = .idle
		}
	}
}
