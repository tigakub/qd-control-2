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
	case control = 4
	case feedback = 5
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
    var id: UInt32
    var effFront: simd_float4
    var effBack: simd_float4
    var stepHeight: Float32
    var bodySway: Float32
    var duration: UInt32
    
    init(side: UInt32, id: UInt32, front: simd_float4, back: simd_float4, stepHeight: Float32, bodySway: Float32, duration: UInt32) {
        type            = (side == 0) ? QDMsgType.pose2RL.rawValue: QDMsgType.pose2LR.rawValue
        self.id			= id
        self.effFront   = front
        self.effBack    = back
        self.stepHeight = stepHeight
        self.bodySway	= bodySway
        self.duration   = duration
    }
    
    mutating func pack(side: UInt32, id: UInt32, front: simd_float4, back: simd_float4, stepHeight: Float32, bodySway: Float32, duration: UInt32) {
        type            = (side == 0) ? QDMsgType.pose2RL.rawValue: QDMsgType.pose2LR.rawValue
        self.id			= id
        self.effFront   = front
        self.effBack    = back
		self.stepHeight = stepHeight
		self.bodySway   = bodySway
        self.duration   = duration
    }
    
    init(from decoder: BinaryDecoder) {
        let nType = decoder.decode(UInt32.self)
        type = nType.littleEndian
        
        let nId = decoder.decode(UInt32.self)
        id = nId.littleEndian
        
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
        
        let nId = id.bigEndian
        encoder.encode(nId)
        
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

struct QDCtrlMsg: BinaryCodable {
    var type: UInt32
    var translation: (Float32, Float32) = (0.0, 0.0)
    var rotation: Float32
    var stepScale: Float32
    var stepHeight: Float32
    var bodySway: Float32
    var bodyHeight: Float32
    var duration: Float32
    
    init(translation: simd_float4, rotation: Float32, stepScale: Float32, stepHeight: Float32, bodySway: Float32, bodyHeight: Float32, duration: Float32) {
        type            	= QDMsgType.control.rawValue
        self.translation	= (translation.x, translation.z)
        self.rotation   	= rotation
        self.stepScale   	= stepScale
        self.stepHeight 	= stepHeight
        self.bodySway		= bodySway
        self.bodyHeight 	= bodyHeight
        self.duration   	= duration
    }
    
    mutating func pack(translation: simd_float4, rotation: Float32, stepScale: Float32, stepHeight: Float32, bodySway: Float32, bodyHeight: Float32, duration: Float32) {
        type            	= QDMsgType.control.rawValue
        self.translation 	= (translation.x, translation.z)
        self.rotation    	= rotation
        self.stepScale	= stepScale
		self.stepHeight 	= stepHeight
		self.bodySway   	= bodySway
        self.bodyHeight 	= bodyHeight
        self.duration   	= duration
    }
    
    init(from decoder: BinaryDecoder) {
        let nType = decoder.decode(UInt32.self)
        type = nType.littleEndian
        
        let nTranslationX = decoder.decode(NSSwappedFloat.self)
        let nTranslationY = decoder.decode(NSSwappedFloat.self)
        self.translation = (NSConvertSwappedFloatToHost(nTranslationX), NSConvertSwappedFloatToHost(nTranslationY))
        
        let nRotation = decoder.decode(NSSwappedFloat.self)
        self.rotation = NSConvertSwappedFloatToHost(nRotation)
        
        let nStepScale = decoder.decode(NSSwappedFloat.self)
        self.stepScale = NSConvertSwappedFloatToHost(nStepScale)
        
        let nStepHeight = decoder.decode(NSSwappedFloat.self)
        self.stepHeight = NSConvertSwappedFloatToHost(nStepHeight)
        
        let nBodySway = decoder.decode(NSSwappedFloat.self)
        self.bodySway = NSConvertSwappedFloatToHost(nBodySway)
        
        let nBodyHeight = decoder.decode(NSSwappedFloat.self)
        self.bodyHeight = NSConvertSwappedFloatToHost(nBodyHeight)
        
        let nDuration = decoder.decode(NSSwappedFloat.self)
        self.duration = NSConvertSwappedFloatToHost(nDuration)
    }
    
    func encode(to encoder: BinaryEncoder) {
        let nType = type.bigEndian
        encoder.encode(nType)
        
        let translationX = NSConvertHostFloatToSwapped(translation.0)
        encoder.encode(translationX)
        
        let translationY = NSConvertHostFloatToSwapped(translation.1)
        encoder.encode(translationY)
        
        let nRotation = NSConvertHostFloatToSwapped(rotation)
        encoder.encode(nRotation)
        
        let nStepScale = NSConvertHostFloatToSwapped(stepScale)
        encoder.encode(nStepScale)
        
        let nStepHeight = NSConvertHostFloatToSwapped(stepHeight)
        encoder.encode(nStepHeight)
        
        let nBodySway = NSConvertHostFloatToSwapped(bodySway)
        encoder.encode(nBodySway)
        
        let nBodyHeight = NSConvertHostFloatToSwapped(bodyHeight)
        encoder.encode(nBodyHeight)
        
        let nDuration = NSConvertHostFloatToSwapped(duration)
        encoder.encode(nDuration)
    }
}

struct QDFeedback: BinaryCodable {
    var type: UInt32
    var id: UInt32
    var hips: simd_float4
    var shoulders: simd_float4
    var elbows: simd_float4
    var orientation: simd_float4
    
    init() {
        type = QDMsgType.feedback.rawValue
        id = 0
        hips = .zero
        shoulders = .zero
        elbows = .zero
        orientation = .zero
    }
    
    init(from decoder: BinaryDecoder) {
        let nType = decoder.decode(UInt32.self)
        type = nType.littleEndian
        
        let nId = decoder.decode(UInt32.self)
        id = nId.littleEndian
        
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
        
        let nId = id.bigEndian
        encoder.encode(nId)
        
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
