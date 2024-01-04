//
//  Touchable.swift
//  qd-control-2
//
//  Created by Edward Janne on 1/3/24.
//

import Foundation
import SwiftUI

protocol Touchable {
    func touchesBegan     (_ touches: Set<UITouch>, _ event: UIEvent)
    func touchesMoved     (_ touches: Set<UITouch>, _ event: UIEvent)
    func touchesEnded     (_ touches: Set<UITouch>, _ event: UIEvent)
    func touchesCancelled (_ touches: Set<UITouch>, _ event: UIEvent)
}
