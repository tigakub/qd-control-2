//
//  UIColors.swift
//  qd-control-2
//
//  Created by Edward Janne on 1/3/24.
//

import Foundation
import SwiftUI

extension Color {
    static var defaultButtonIdle  = lightDeepOrange
    static var defaultButtonHover = lightVividOrange
    static var defaultButtonPress = lightPaleOrange
    
    static var brightGray        = Color(.sRGB, red: 0.8, green: 0.8, blue: 0.8, opacity: 1.0)
    static var brightAltGray     = Color(.sRGB, red: 0.9, green: 0.9, blue: 0.9, opacity: 1.0)
    static var lightGray         = Color(.sRGB, red: 0.6, green: 0.6, blue: 0.6, opacity: 1.0)
    static var darkGray          = Color(.sRGB, red: 0.4, green: 0.4, blue: 0.4, opacity: 1.0)
    static var deepGray          = Color(.sRGB, red: 0.1, green: 0.1, blue: 0.1, opacity: 1.0)
    static var deepAltGray       = Color(.sRGB, red: 0.2, green: 0.2, blue: 0.2, opacity: 1.0)
    
    static var lightDeepRed      = Color(.sRGB, red: 0.85, green: 0.0 , blue: 0.0 )
    static var lightVividRed     = Color(.sRGB, red: 1.0 , green: 0.0 , blue: 0.0 )
    static var lightPaleRed      = Color(.sRGB, red: 1.0 , green: 0.66, blue: 0.66)
    
    static var darkDeepRed       = Color(.sRGB, red: 0.6 , green: 0.0 , blue: 0.0 )
    static var darkVividRed      = Color(.sRGB, red: 0.75, green: 0.0 , blue: 0.0 )
    static var darkPaleRed       = Color(.sRGB, red: 0.75, green: 0.5 , blue: 0.5 )
    
    static var lightDeepOrange   = Color(.sRGB, red: 1.0 , green: 0.4 , blue: 0.0 )
    static var lightVividOrange  = Color(.sRGB, red: 1.0 , green: 0.6 , blue: 0.0 )
    static var lightBrightOrange = Color(.sRGB, red: 1.0 , green: 0.8 , blue: 0.0 )
    static var lightPaleOrange   = Color(.sRGB, red: 1.0 , green: 0.9 , blue: 0.5 )
     
    static var darkDeepOrange    = Color(.sRGB, red: 0.75, green: 0.3 , blue: 0.0 )
    static var darkVividOrange   = Color(.sRGB, red: 0.75, green: 0.5 , blue: 0.0 )
    static var darkBrightOrange  = Color(.sRGB, red: 0.75, green: 0.6 , blue: 0.0 )
    static var darkPaleOrange    = Color(.sRGB, red: 0.75, green: 0.65, blue: 0.25)
    
    static var lightDeepYellow   = Color(.sRGB, red: 0.6 , green: 0.6 , blue: 0.0 )
    static var lightVividYellow  = Color(.sRGB, red: 0.8 , green: 0.8 , blue: 0.0 )
    static var lightBrightYellow = Color(.sRGB, red: 1.0 , green: 1.0 , blue: 0.0 )
    static var lightPaleYellow   = Color(.sRGB, red: 1.0 , green: 1.0 , blue: 0.5 )
     
    static var darkDeepYellow    = Color(.sRGB, red: 0.4 , green: 0.4 , blue: 0.0 )
    static var darkVividYellow   = Color(.sRGB, red: 0.6 , green: 0.6 , blue: 0.0 )
    static var darkBrightYellow  = Color(.sRGB, red: 0.75, green: 0.75, blue: 0.0 )
    static var darkPaleYellow    = Color(.sRGB, red: 0.75, green: 0.75, blue: 0.25)
    
    static var lightDeepGreen    = Color(.sRGB, red: 0.0 , green: 0.85, blue: 0.0 )
    static var lightVividGreen   = Color(.sRGB, red: 0.0 , green: 1.0 , blue: 0.0 )
    static var lightBrightGreen   = Color(.sRGB, red: 0.33 , green: 1.0 , blue: 0.0 )
    static var lightPaleGreen    = Color(.sRGB, red: 0.66, green: 1.0 , blue: 0.66)
    
    static var darkDeepGreen     = Color(.sRGB, red: 0.0 , green: 0.6 , blue: 0.0 )
    static var darkVividGreen    = Color(.sRGB, red: 0.0 , green: 0.75, blue: 0.0 )
    static var darkBrightGreen    = Color(.sRGB, red: 0.25 , green: 0.75, blue: 0.0 )
    static var darkPaleGreen     = Color(.sRGB, red: 0.5 , green: 0.75, blue: 0.5 )
    
    static var lightDeepCyan     = Color(.sRGB, red: 0.0 , green: 0.6 , blue: 0.6 )
    static var lightVividCyan    = Color(.sRGB, red: 0.0 , green: 0.8 , blue: 0.8 )
    static var lightBrightCyan   = Color(.sRGB, red: 0.25 , green: 1.0 , blue: 1.0 )
    static var lightPaleCyan     = Color(.sRGB, red: 0.5 , green: 1.0 , blue: 1.0 )
     
    static var darkDeepCyan      = Color(.sRGB, red: 0.0 , green: 0.4 , blue: 0.4 )
    static var darkVividCyan     = Color(.sRGB, red: 0.0 , green: 0.6 , blue: 0.6 )
    static var darkBrightCyan    = Color(.sRGB, red: 0.0 , green: 0.75, blue: 0.75)
    static var darkPaleCyan      = Color(.sRGB, red: 0.25, green: 0.75, blue: 0.75)
    
    static var lightDeepBlue     = Color(.sRGB, red: 0.0 , green: 0.0 , blue: 0.85)
    static var lightVividBlue    = Color(.sRGB, red: 0.0 , green: 0.0 , blue: 1.0 )
    static var lightPaleBlue     = Color(.sRGB, red: 0.66, green: 0.66, blue: 1.0 )
    
    static var darkDeepBlue      = Color(.sRGB, red: 0.0 , green: 0.0 , blue: 0.6 )
    static var darkVividBlue     = Color(.sRGB, red: 0.0 , green: 0.0 , blue: 0.75)
    static var darkPaleBlue      = Color(.sRGB, red: 0.5 , green: 0.5 , blue: 0.75)
     
    static var lightDeepPurple   = Color(.sRGB, red: 0.6 , green: 0.4 , blue: 1.0 )
    static var lightVividPurple  = Color(.sRGB, red: 0.8 , green: 0.5 , blue: 1.0 )
    static var lightBrightPurple = Color(.sRGB, red: 1.0 , green: 0.6 , blue: 1.0 )
    static var lightPalePurple   = Color(.sRGB, red: 0.9 , green: 0.8 , blue: 1.0 )
    
    static var darkDeepPurple    = Color(.sRGB, red: 0.3 , green: 0.2 , blue: 0.75)
    static var darkVividPurple   = Color(.sRGB, red: 0.5 , green: 0.4 , blue: 0.75)
    static var darkBrightPurple  = Color(.sRGB, red: 0.6 , green: 0.5 , blue: 0.75)
    static var darkPalePurple    = Color(.sRGB, red: 0.65, green: 0.6 , blue: 0.75)
}

extension Color {
    func adapted(_ colorScheme: ColorScheme)->Self {
        if let cgColor = self.cgColor, let comp = cgColor.components {
            var factor = 1.0
            if colorScheme == .dark {
                factor = 0.75
            }
            return Color(
                .sRGB,
                red: comp[0] * factor,
                green: comp[1] * factor,
                blue: comp[2] * factor,
                opacity: comp[3])
        }
        return self
    }
    
    static func adaptedForeground(_ colorScheme: ColorScheme)->Self {
        if colorScheme == .dark {
            return white
        }
        return black
    }
    static func adaptedBackground(_ colorScheme: ColorScheme)->Self {
        if colorScheme == .dark {
            return deepGray
        }
        return white
    }
    static func adaptedAltBackground(_ colorScheme: ColorScheme)->Self {
        if colorScheme == .dark {
            return deepAltGray
        }
        return brightAltGray
    }
}
