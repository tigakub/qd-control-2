//
//  QDMessage.swift
//  qd-control
//
//  Created by Edward Janne on 10/25/23.
//

import Foundation
import simd

struct SwappedSIMDFloat4 {
    var x: CFSwappedFloat32
    var y: CFSwappedFloat32
    var z: CFSwappedFloat32
    var w: CFSwappedFloat32
    
    init(_ v: simd_float4) {
        x = CFConvertFloat32HostToSwapped(v.x)
        y = CFConvertFloat32HostToSwapped(v.y)
        z = CFConvertFloat32HostToSwapped(v.z)
        w = CFConvertFloat32HostToSwapped(v.w)
    }
    
    var hostOrder: simd_float4 {
        return simd_float4(
            x: CFConvertFloat32SwappedToHost(x),
            y: CFConvertFloat32SwappedToHost(y),
            z: CFConvertFloat32SwappedToHost(z),
            w: CFConvertFloat32SwappedToHost(w)
        )
    }
}

enum QDMsgType : UInt32 {
	case pose = 1
	case pose2RL = 2
	case pose2LR = 3
	case feedback = 4
}

struct QDPose: BinaryCodable, Observable {
    var type: UInt32
    var hips: simd_float4
    var shoulders: simd_float4
    var elbows: simd_float4
    var timestamp: UInt32
    
    init(with robot: QDRobot, timestamp: UInt32) {
        type            = QDMsgType.pose.rawValue
        hips            = .zero
        shoulders       = .zero
        elbows          = .zero
        self.timestamp  = timestamp
        
        for i in 0 ..< 4 {
            hips[i]         = robot.limbs[i][0]
            shoulders[i]    = robot.limbs[i][1]
            elbows[i]       = robot.limbs[i][2]
        }
    }
    
    mutating func pack(with robot: QDRobot, timestamp: UInt32) {
        self.timestamp = timestamp
        
        for i in 0 ..< 4 {
            hips[i]         = robot.limbs[i][0]
            shoulders[i]    = robot.limbs[i][1]
            elbows[i]       = robot.limbs[i][2]
        }
    }
    
    init(from decoder: BinaryDecoder) {
        let nType = decoder.decode(UInt32.self)
        type = nType.littleEndian
        
        let nHips = decoder.decode(SwappedSIMDFloat4.self)
        hips = nHips.hostOrder
        
        let nShoulders = decoder.decode(SwappedSIMDFloat4.self)
        shoulders = nShoulders.hostOrder
        
        let nElbows = decoder.decode(SwappedSIMDFloat4.self)
        elbows = nElbows.hostOrder
        
        let nTimestamp = decoder.decode(UInt32.self)
        timestamp = nTimestamp.littleEndian
    }
    
    func encode(to encoder: BinaryEncoder) {
        let nType = type.bigEndian
        encoder.encode(nType)
        
        let nHips = SwappedSIMDFloat4(hips)
        encoder.encode(nHips)
        
        let nShoulders = SwappedSIMDFloat4(shoulders)
        encoder.encode(nShoulders)
        
        let nElbows = SwappedSIMDFloat4(elbows)
        encoder.encode(nElbows)
        
        let nTimestamp = timestamp.bigEndian
        encoder.encode(nTimestamp)
    }
}

struct QDPose2: BinaryCodable, Observable {
    var type: UInt32
    var effFront: simd_float4
    var effBack: simd_float4
    var stepHeight: Float32
    var bodySway: Float32
    var duration: UInt32
    
    init(side: UInt32, front: simd_float4, back: simd_float4, stepHeight: Float32, bodySway: Float32, duration: UInt32) {
        type            = (side == 0) ? QDMsgType.pose2RL.rawValue: QDMsgType.pose2LR.rawValue
        self.effFront   = front
        self.effBack    = back
        self.stepHeight = stepHeight
        self.bodySway	= bodySway
        self.duration   = duration
    }
    
    mutating func pack(side: UInt32, front: simd_float4, back: simd_float4, stepHeight: Float32, bodySway: Float32, duration: UInt32) {
        type            = (side == 0) ? QDMsgType.pose2RL.rawValue: QDMsgType.pose2LR.rawValue
        self.effFront   = front
        self.effBack    = back
		self.stepHeight = stepHeight
		self.bodySway   = bodySway
        self.duration   = duration
    }
    
    init(from decoder: BinaryDecoder) {
        let nType = decoder.decode(UInt32.self)
        type = nType.littleEndian
        
        let effFront = decoder.decode(SwappedSIMDFloat4.self)
        self.effFront = effFront.hostOrder
        
        let effBack = decoder.decode(SwappedSIMDFloat4.self)
        self.effBack = effBack.hostOrder
        
        let stepHeight = decoder.decode(NSSwappedFloat.self)
        self.stepHeight = NSConvertSwappedFloatToHost(stepHeight)
        
        let bodySway = decoder.decode(NSSwappedFloat.self)
        self.bodySway = NSConvertSwappedFloatToHost(bodySway)
        
        let duration = decoder.decode(UInt32.self)
        self.duration = duration.littleEndian
    }
    
    func encode(to encoder: BinaryEncoder) {
        let nType = type.bigEndian
        encoder.encode(nType)
        
        let effFront = SwappedSIMDFloat4(effFront)
        encoder.encode(effFront)
        
        let effBack = SwappedSIMDFloat4(effBack)
        encoder.encode(effBack)
        
        let stepHeight = NSConvertHostFloatToSwapped(stepHeight)
        encoder.encode(stepHeight)
        
        let bodySway = NSConvertHostFloatToSwapped(bodySway)
        encoder.encode(bodySway)
        
        let duration = duration.bigEndian
        encoder.encode(duration)
    }
}

struct QDFeedback: BinaryCodable {
    var type: UInt32
    var hips: simd_float4
    var shoulders: simd_float4
    var elbows: simd_float4
    var orientation: simd_float4
    
    init() {
        type = QDMsgType.feedback.rawValue
        hips = .zero
        shoulders = .zero
        elbows = .zero
        orientation = .zero
    }
    
    init(from decoder: BinaryDecoder) {
        let nType = decoder.decode(UInt32.self)
        type = nType.littleEndian
        
        let nHips = decoder.decode(SwappedSIMDFloat4.self)
        hips = nHips.hostOrder
        
        let nShoulders = decoder.decode(SwappedSIMDFloat4.self)
        shoulders = nShoulders.hostOrder
        
        let nElbows = decoder.decode(SwappedSIMDFloat4.self)
        elbows = nElbows.hostOrder
        
        let nOrientation = decoder.decode(SwappedSIMDFloat4.self)
        orientation = nOrientation.hostOrder
    }
    
    func encode(to encoder: BinaryEncoder) {
        let nType = type.bigEndian
        encoder.encode(nType)
        
        let nHips = SwappedSIMDFloat4(hips)
        encoder.encode(nHips)
        
        let nShoulders = SwappedSIMDFloat4(shoulders)
        encoder.encode(nShoulders)
        
        let nElbows = SwappedSIMDFloat4(elbows)
        encoder.encode(nElbows)
        
        let nOrientation = SwappedSIMDFloat4(orientation)
        encoder.encode(nOrientation)
    }
}
