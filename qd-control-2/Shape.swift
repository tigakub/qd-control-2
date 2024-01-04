//
//  Shape.swift
//  qd-control-2
//
//  Created by Edward Janne on 1/3/24.
//

import Foundation
import SwiftUI

struct Line : Shape {
    let startPoint: CGPoint
    let endPoint: CGPoint
    
    func path(in _: CGRect)->Path {
        var path = Path()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        return path
    }
}

struct Arc : Shape {
    enum Direction {
        case clockwise
        case counterClockwise
        case adaptive
    }
    
    let startAngle: Angle
    let endAngle: Angle
    let direction: Direction
    
    func path(in rect: CGRect)->Path {
        var path = Path()
        let radius = max(rect.size.width, rect.size.height) / 2
        let center = CGPoint(x: rect.midX, y: rect.midY)
        path.move(to: center)
        let rotation = CGAffineTransform(rotationAngle: startAngle.radians)
        path.addLine(to: center + CGPoint(x: rect.midX, y: 0.0).applying(rotation))
        
        path.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: (direction == .adaptive) ? ((endAngle.radians - startAngle.radians) < 0.0) : (direction == .counterClockwise))
        path.addLine(to: center)
        return path
    }
}

