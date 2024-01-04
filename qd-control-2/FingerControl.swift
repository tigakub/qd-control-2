//
//  FingerControl.swift
//  qd-control-2
//
//  Created by Edward Janne on 1/3/24.
//

import Foundation
import SwiftUI

struct FingerControl: View {
    @Binding var controlRadius: CGFloat
    @Binding var pressed: Bool
	@Binding var centroidLocation: CGPoint
	@Binding var rotation: CGFloat
	@State var touchCount: Int = 0
	@State var centroidOffset: CGPoint = .zero
    var contentView = UIView(frame: .zero)
    
    var body: some View {
		ZStack {
			GeometryReader {
				g in
					
				Circle()
					.fill(Color.blue)
				Line(startPoint: CGPoint(x: g.size.width * 0.5, y: g.size.height * 0.5), endPoint: CGPoint(x: g.size.width * 0.5, y: 0.0))
					.stroke(Color.red, style: StrokeStyle(lineWidth: 5.0, lineCap: .round))
					.rotationEffect(Angle(radians: -rotation))
			}
		}
			.frame(width: controlRadius * 2.0, height: controlRadius * 2.0)
    }
}
