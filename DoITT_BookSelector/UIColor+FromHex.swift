//
//  UIColor+FromHex.swift
//  DoITT_BookSelector
//
//  Created by Amitai Blickstein on 4/28/16.
//  Copyright © 2016 Amitai Blickstein, LLC. All rights reserved.
//

import UIKit

/**
 Generates a UIColor from a hex color string.
 
 :param: hex The hex color string from which to create the color object.  '#' sign is optional.
 */
extension UIColor {
    
    public static func colorFromHexCode(hex: String) -> UIColor!
    {
        var colorString: String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if colorString.hasPrefix("#") {
            colorString = colorString.substringFromIndex(1)
        }
        
        let stringLength = colorString.characters.count
        if stringLength != 6 && stringLength != 8 {
            return nil
        }
        
        let rString = colorString.substringToIndex(2)
        let gString = colorString.substringFromIndex(2).substringToIndex(2)
        let bString = colorString.substringFromIndex(4).substringToIndex(2)
        var aString : String?
        if stringLength == 8 { aString = colorString.substringFromIndex(6).substringToIndex(2) }
        
        var r: CUnsignedInt = 0
        var g: CUnsignedInt = 0
        var b: CUnsignedInt = 0
        var a: CUnsignedInt = 1
        
        NSScanner(string:rString).scanHexInt(&r)
        NSScanner(string:gString).scanHexInt(&g)
        NSScanner(string:bString).scanHexInt(&b)
        if let aString = aString {
            NSScanner(string:aString).scanHexInt(&a)
        }
        
        let red     = CGFloat(r) / 255.0
        let green   = CGFloat(g) / 255.0
        let blue    = CGFloat(b) / 255.0
        let alpha   = CGFloat(a) / 255.0
        return UIColor(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    private static func alphaHEX(alpha: CGFloat) -> String {
        
        if alpha <= 1 {
            return String(Int(alpha * 255), radix: 16, uppercase: true)
        } else { return "FF" }
    }
}

private extension String
{
    func substringFromIndex(index: Int) -> String
    {
        let newStart = startIndex.advancedBy(index)
        return self[newStart ..< endIndex]
    }
    
    func substringToIndex(index: Int) -> String
    {
        let newEnd = startIndex.advancedBy(index)
        return self[startIndex ..< newEnd]
    }
}
