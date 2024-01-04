//
//  ContentView.swift
//  qd-control-2
//
//  Created by Edward Janne on 1/3/24.
//

import SwiftUI

struct ContentView: View {
    @State var feedback = QDFeedback()
    
    @Bindable var qdControl: QDControl2
    @Bindable var qdRobot: QDRobot
    @Bindable var qdClient: QDClient
    
    @State var controlRadius: CGFloat = 150.0
    @State var maxRadius: CGFloat = 200.0
    @State var leftTouch: UITouch? = nil
    @State var leftTouchPoint: CGPoint = .zero
    @State var rightTouch: UITouch? = nil
    @State var rightTouchPoint: CGPoint = .zero
    @State var pressed: Bool = false
    @State var centroidLocation: CGPoint = .zero
    @State var rotation: CGFloat = .zero
    @State var centroidOffset: CGPoint = .zero
    @State var origin: CGPoint = .zero
    
    var uiView = UIView(frame: .zero)
    
    var body: some View {
		VStack {
			GeometryReader {
				g in
				ZStack {
					FingerControl(controlRadius: $controlRadius, pressed: $pressed, centroidLocation: $centroidLocation, rotation: $rotation)
						.position(centroidLocation)
					Circle()
						.stroke(lineWidth: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
						.frame(width: maxRadius * 4.0, height: maxRadius * 4.0)
				}
					.onAppear {
						if g.size.width < g.size.height {
							controlRadius = g.size.width * 0.25
							maxRadius = controlRadius
						} else {
							controlRadius = g.size.height * 0.25
							maxRadius = controlRadius
						}
						centroidLocation = CGPoint(x: g.size.width * 0.5, y: g.size.height * 0.5)
						origin = centroidLocation
					}
					.modifier(
						TouchModifier(touchable: self) {
							return uiView
						}
						onUpdateViews: {
							view in
						}
					)
			}
		}
			.padding()
    }
}

extension ContentView : Touchable {
	func touchesBegan(_ touches: Set<UITouch>, _ event: UIEvent) {
		var point: CGPoint = .zero
		for touch in touches {
			let touchPoint = touch.location(in: uiView)
			if (touchPoint - centroidLocation).magnitude <= controlRadius {
				if let leftTouch = leftTouch {
					if leftTouch.location(in: uiView).x > touchPoint.x {
						rightTouch = leftTouch
						self.leftTouch = touch
						rightTouchPoint = leftTouchPoint
						leftTouchPoint = touchPoint
					} else {
						rightTouch = touch
						rightTouchPoint = touchPoint
					}
				} else {
					leftTouch = touch
					leftTouchPoint = touchPoint
				}
				
				point += touchPoint
			}
		}
		if leftTouch != nil && rightTouch != nil {
			point *= 0.5
			centroidOffset = point - centroidLocation
			pressed = true
		}
	}
	
	func touchesMoved(_ touches: Set<UITouch>, _ event: UIEvent) {
		if pressed, let leftTouch = leftTouch, let rightTouch = rightTouch {
			let newLeftTouchPoint = leftTouch.location(in: uiView)
			let newRightTouchPoint = rightTouch.location(in: uiView)
			let oldVec = rightTouchPoint - leftTouchPoint
			let newVec = newRightTouchPoint - newLeftTouchPoint
			
			let angleDelta = newVec.angle(to: oldVec)
			
			leftTouchPoint = newLeftTouchPoint
			rightTouchPoint = newRightTouchPoint
			
			rotation += angleDelta.radians
			/*
			if rotation.radians > 0 {
				direction = .counterClockwise
			} else {
				direction = .clockwise
			}
			*/
			var point: CGPoint = .zero
			point = (newLeftTouchPoint + newRightTouchPoint) * 0.5
			centroidLocation = point - centroidOffset
			if (centroidLocation - origin).magnitude > maxRadius {
				centroidLocation = origin + (centroidLocation - origin).normalized * maxRadius
			}
		}
	}
	
	func touchesEnded(_ touches: Set<UITouch>, _ event: UIEvent) {
		for touch in touches {
			if touch == leftTouch {
				leftTouch = nil
			}
			if touch == rightTouch {
				rightTouch = nil
			}
		}
		if leftTouch == nil || rightTouch == nil {
			pressed = false
		}
		withAnimation {
			rotation = .zero
		}
		withAnimation {
			centroidLocation = origin
		}
	}
	
	func touchesCancelled(_ touches: Set<UITouch>, _ event: UIEvent) {
		for touch in touches {
			if touch == leftTouch {
				leftTouch = nil
			}
			if touch == rightTouch {
				rightTouch = nil
			}
		}
		if leftTouch == nil || rightTouch == nil {
			pressed = false
		}
	}
}
