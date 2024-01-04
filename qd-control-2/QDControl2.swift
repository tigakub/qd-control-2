//
//  QDControl2.swift
//  qd-control-2
//
//  Created by Edward Janne on 1/3/24.
//

import Foundation
import simd

@Observable class QDControl2 {
	struct Stance: CustomStringConvertible {
		var targets: [simd_float4]
		var centroid: simd_float4
		var tangent: simd_float4
		var orthogonal: simd_float4
		var progress: Float
		var stepSize: Float
		
		init(_ targets: [simd_float4] = [.zero, .zero, .zero, .zero], centroid: simd_float4 = .zero, tangent: simd_float4 = .zero, orthogonal: simd_float4 = .zero, progress: Float = 0.0, stepSize: Float = 0.0) {
			self.targets = targets
			self.centroid = centroid
			self.tangent = tangent
			self.orthogonal = orthogonal
			self.progress = progress
			self.stepSize = stepSize
		}
		
		init(_ other: Stance) {
			self.targets = other.targets
			self.centroid = other.centroid
			self.tangent = other.tangent
			self.orthogonal = other.orthogonal
			self.progress = other.progress
			self.stepSize = other.stepSize
		}
		
		var description: String {
			get {
				return "{ \(targets[0]), \(targets[1]), \(targets[2]), \(targets[3]), centroid: \(centroid), tangent: \(tangent), progress: \(progress), step size: \(stepSize) }"
			}
		}

		func tricentroid(_ limb: QDRobot.Limb.Configuration)->simd_float4 {
			var p0: simd_float4 = .zero
			var p1: simd_float4 = .zero
			var p2: simd_float4 = .zero
			
			switch limb {
				case .frontRight:
					p0 = targets[1]
					p1 = targets[2]
					p2 = targets[3]
				case .frontLeft:
					p0 = targets[0]
					p1 = targets[2]
					p2 = targets[3]
				case .backRight:
					p0 = targets[0]
					p1 = targets[1]
					p2 = targets[3]
				case .backLeft:
					p0 = targets[0]
					p1 = targets[1]
					p2 = targets[2]
			}
			
			let m0 = (p0 + p1) * 0.5
			let m1 = (p1 + p2) * 0.5
			
			let x1 = m0.x
			let z1 = m0.z
			let x2 = p2.x
			let z2 = p2.z
			
			let x3 = m1.x
			let z3 = m1.z
			let x4 = p0.x
			let z4 = p0.z
			
			let d = (x1 - x2) * (z3 - z4) - (z1 - z2) * (x3 - x4)
			
			let x = ((x1 * z2 - z1 * x2) * (x3 - x4) - (x1 - x2) * (x3 * z4 - z3 * x4)) / d
			let z = ((x1 * z2 - z1 * x2) * (z3 - z4) - (z1 - z2) * (x3 * z4 - z3 * x4)) / d
			
			return simd_float4(x, 0.0, z, 0.0)
		}
		
		func localizedTargets(position: simd_float4, rotation: Float)->[simd_float4] {
			let matrix = simd_float4x4(rotationAxis: .j, angle: rotation)
			let p0 = matrix * (targets[0] - position)
			let p1 = matrix * (targets[1] - position)
			let p2 = matrix * (targets[2] - position)
			let p3 = matrix * (targets[3] - position)
			// print("r(\(-rotation)) p0(\(p0.x), \(p0.y)) p1(\(p1.x), \(p1.y)) p2(\(p2.x), \(p2.y)) p3(\(p3.x), \(p3.y))")
			return [p0, p1, p2, p3]
		}
	}
	
	var qdRobot: QDRobot
	var qdClient: QDClient

	init(robot: QDRobot, client: QDClient) {
		qdRobot = robot
		qdClient = client
	}
}
