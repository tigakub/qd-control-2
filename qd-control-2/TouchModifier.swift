//
//  TouchModifier.swift
//  qd-control-2
//
//  Created by Edward Janne on 1/3/24.
//

import SwiftUI

struct TouchModifier: ViewModifier {
    // UIViewRepresentable implementation to embed a UIGestureRecognizer in a SwiftUI View
    struct ViewRep: UIViewRepresentable {
        
		class MultitouchRecognizer: UIGestureRecognizer {
				
			// The target Touchable
			var touchable: Touchable
			
			init(target: Any?, touchable: Touchable) {
				self.touchable = touchable
				super.init(target: target, action: nil)
			}
			
			override func touchesBegan(_ touches: Set<UITouch>, with event:UIEvent) {
				touchable.touchesBegan(touches, event)
			}
			override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
				touchable.touchesMoved(touches, event)
			}
			override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
				touchable.touchesEnded(touches, event)
			}
			override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
				touchable.touchesCancelled(touches, event)
			}
		}
		
		// A reference to the event handling Touchable
		var touchable: Touchable
		
		var onGenerateBaseView: ()->UIView
		var onUpdateViews: (UIView)->()
		
		func makeUIView(context: Context)->some UIView {
			let baseView = onGenerateBaseView()
			let recognizer = MultitouchRecognizer(target: context.coordinator, touchable: touchable)
			baseView.addGestureRecognizer(recognizer)
			return baseView
		}
		
		func updateUIView(_ uiView: UIViewType, context: Context) {
			onUpdateViews(uiView)
		}
    }
    
    // A reference to the event handling Touchable
    var touchable: Touchable
    var onGenerateBaseView: ()->UIView
    var onUpdateViews: (UIView)->()
    
    func body(content: Content)->some View {
        ZStack {
            // Display provided content
            content
            // Overlay multitouch view, passing in the UIView and Touchable
            // ViewRep(baseView: baseView, touchable: touchable)
            ViewRep(touchable: touchable, onGenerateBaseView: onGenerateBaseView, onUpdateViews: onUpdateViews)
        }
    }
}
