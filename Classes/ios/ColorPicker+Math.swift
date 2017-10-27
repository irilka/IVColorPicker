//
//  Int+ColorPicker.swift
//  Counter
//
//  Created by Irina Vaara on 21.07.17.
//  Copyright © 2017 Irina Vaara. All rights reserved.
//

import UIKit

extension Int
{
    var radian: CGFloat
    {
        return (CGFloat.pi * CGFloat(self)) / 180.0
    }
}

extension CGFloat
{
    var degree: Int
    {
        return Int(self * 180.0 / CGFloat.pi)
    }
}
