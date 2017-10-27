//
//  AngleGradientLayer.swift
//  Counter
//
//  Created by Irina Vaara on 21.07.17.
//  Copyright © 2017 Irina Vaara. All rights reserved.
//

import UIKit

public class ConicalGradientLayer: CALayer
{
    // MARK: - Types
    
    private struct Constants
    {
        static let MaxAngle: CGFloat = 2 * .pi
        static let MaxHue: CGFloat = 255.0
    }
    
    // MARK: - Public variables

    public var hsb = HSB() {
        
        didSet {
            setNeedsDisplay()
        }
    }

    // MARK: - Lifecycle
    
    public override func draw(in ctx: CGContext)
    {
        UIGraphicsPushContext(ctx)
        draw(in: ctx.boundingBoxOfClipPath)
        UIGraphicsPopContext()
    }
    
    // MARK: - Public methods

    func color(forAngle angle: CGFloat) -> UIColor
    {
        let hue = angle * Constants.MaxHue / Constants.MaxAngle
        return UIColor(hue: hue / Constants.MaxHue, saturation: hsb.saturation, brightness: hsb.brightness, alpha: 1.0)
    }
    
    func angle(forColor color: UIColor) -> CGFloat
    {
        var hue: CGFloat = 0.0
        color.getHue(&hue, saturation: nil, brightness: nil, alpha: nil)
        hue = hue * Constants.MaxHue
        
        let angle = (hue * Constants.MaxAngle) / Constants.MaxHue
        return angle
    }

    // MARK: - Helpers
    
    private func draw(in rect: CGRect)
    {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let longerSide = max(rect.width, rect.height)
        let radius = longerSide * CGFloat(2.squareRoot())
        let step = (.pi / 2) / radius
        var angle: CGFloat = 0
        
        while angle <= Constants.MaxAngle
        {
            let pointX = radius * cos(angle) + center.x
            let pointY = radius * sin(angle) + center.y
            let startPoint = CGPoint(x: pointX, y: pointY)
            
            let line = UIBezierPath()
            line.move(to: startPoint)
            line.addLine(to: center)
            
            let color = self.color(forAngle: angle)
            color.setStroke()
            line.stroke()
            
            angle += step
        }
    }
}
