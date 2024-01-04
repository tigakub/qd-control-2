//
//  CGPoint.swift
//  qd-control-2
//
//  Created by Edward Janne on 1/3/24.
//

import Foundation
import SwiftUI

extension CGPoint {
    static let i = CGPoint(x: 1.0, y: 0.0)
    static let j = CGPoint(x: 0.0, y: 1.0)
    
    init(_ from: CGSize) {
        self.init(x: from.width, y: from.height)
    }
    
    var magnitude: CGFloat {
        get {
            return sqrt(x * x + y * y)
        }
    }
    
    var normalized: CGPoint {
        let mag = self.magnitude
        if mag == 0.0 {
            return .zero
        }
        return self / mag
    }
    
    var flippedX: CGPoint {
        get {
            return CGPoint(x: -x, y: y)
        }
    }
    
    var flippedY: CGPoint {
        get {
            return CGPoint(x: x, y: -y)
        }
    }
    
    static func +=(lhs: inout CGPoint, rhs: CGPoint) {
        lhs.x += rhs.x
        lhs.y += rhs.y
    }
    
    static func +(lhs: CGPoint, rhs: CGPoint)->CGPoint {
        var new = lhs
        new += rhs
        return new
    }
    
    static func -=(lhs: inout CGPoint, rhs: CGPoint) {
        lhs.x -= rhs.x
        lhs.y -= rhs.y
    }
    
    static func -(lhs: CGPoint, rhs: CGPoint)->CGPoint {
        var new = lhs
        new -= rhs
        return new
    }
    
    static prefix func -(unary: CGPoint)->CGPoint {
        var new = unary
        new *= -1.0
        return new
    }
    
    static func *=(lhs: inout CGPoint, rhs: CGFloat) {
        lhs.x *= rhs
        lhs.y *= rhs
    }
    
    static func *(lhs: CGPoint, rhs: CGFloat)->CGPoint {
        var new = lhs
        new *= rhs
        return new
    }
    
    static func /=(lhs: inout CGPoint, rhs: CGFloat) {
        lhs.x /= rhs
        lhs.y /= rhs
    }
    
    static func /(lhs: CGPoint, rhs: CGFloat)->CGPoint {
        var new = lhs
        new /= rhs
        return new
    }
    
    static func •(lhs: CGPoint, rhs: CGPoint)->CGFloat {
        return lhs.x * rhs.x + lhs.y * rhs.y
    }
    
    static func *(lhs: CGPoint, rhs: CGPoint)->CGFloat {
        return lhs.x * rhs.y - lhs.y * rhs.x
    }
    
    func angle(to: CGPoint)->Angle {
        var angle: Angle = .zero
        let denom = (magnitude * to.magnitude)
        if(denom == 0.0) {
            return angle
        }
        let cosAngle = (self • to) / denom
        if abs(cosAngle) <= 1.0 {
            var sign = 1.0
            if self * to < 0.0 {
                sign = -1.0
            }
            angle = Angle(radians: Double(acos(cosAngle)) * sign)
        }
        return angle
    }
    
    func rotate(by angle: Angle)->CGPoint {
        let rotation = CGAffineTransform(rotationAngle: angle.radians)
        return self.applying(rotation)
    }
}

