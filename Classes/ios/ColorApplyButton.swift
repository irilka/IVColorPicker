//
//  ColorApplyButton.swift
//  Counter
//
//  Created by Irina Vaara on 27.07.17.
//  Copyright © 2017 Irina Vaara. All rights reserved.
//

import UIKit

public class ColorApplyButton: UIButton
{
    public var borderWidth: CGFloat = 0
    
    public var color: UIColor? = nil {
     
        didSet {
            setNeedsDisplay()
        }
    }

    public override func draw(_ rect: CGRect)
    {
        super.draw(rect)
        
        if let color = color
        {
            var pathRect = rect
            let withBorder = borderWidth > 0
            
            if withBorder {
                pathRect = pathRect.insetBy(dx: borderWidth, dy: borderWidth)
            }

            let path = UIBezierPath(ovalIn: pathRect)
            
            color.setFill()
            path.fill()

            if withBorder
            {
                path.lineWidth = borderWidth * 2
                let borderColor = color.withAlphaComponent(0.1)
                borderColor.setStroke()
                path.stroke()
            }
            
            path.close()
        }
    }
}
