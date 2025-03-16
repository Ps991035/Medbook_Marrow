//
//  MBUtility.swift
//  MedBook
//
//  Created by PRITESH SINGH on 14/03/25.
//

import Foundation
import UIKit

class MBUtility {
    
    static func hexStringToUIColor(hex: String) -> UIColor {
        
        var colorString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (colorString.hasPrefix("#")) {
            colorString.remove(at: colorString.startIndex)
        }
        
        if (colorString.count != 6) {
            return UIColor.gray
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: colorString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16)/255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8)/255.0,
            blue: CGFloat(rgbValue & 0x0000FF)/255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
}
