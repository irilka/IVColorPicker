//
//  UIView+CSS.swift
//  Counter
//
//  Created by Irina Zavilkina on 27.07.17.
//  Copyright © 2017 Irina Vaara. All rights reserved.
//

import UIKit

extension UIView
{
    @discardableResult
    func circle() -> UIView
    {
        layer.cornerRadius = min(frame.width, frame.height) / 2
        return self
    }
}
