//
//  HSB.swift
//  Counter
//
//  Created by Irina Vaara on 26.07.17.
//  Copyright © 2017 Irina Vaara. All rights reserved.
//

import UIKit

public struct HSB
{
    var hue: CGFloat = 1
    var saturation: CGFloat = 1
    var brightness: CGFloat = 1
    
    var color: UIColor {
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
    
    init() {}
    
    init(hue: CGFloat, saturation: CGFloat, brightness: CGFloat)
    {
        self.hue = hue
        self.saturation = saturation
        self.brightness = brightness
    }

    init(color: UIColor)
    {
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil)
    }
}
