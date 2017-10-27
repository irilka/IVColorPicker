//
//  UIView+Snapshot.swift
//  Counter
//
//  Created by Irina Zavilkina on 03.03.17.
//  Copyright © 2017 Irina Vaara. All rights reserved.
//

import UIKit

extension UIView
{
    func snapshot(customRect rect: CGRect? = nil) -> UIImage
    {
        var customRect = bounds
        
        if let rect = rect {
            customRect = rect
        }
        
        UIGraphicsBeginImageContextWithOptions(customRect.size, false, 0.0)
        
        let context = UIGraphicsGetCurrentContext()!

        context.translateBy(x: -customRect.origin.x, y: -customRect.origin.y)

        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        
        return image
    }
}
