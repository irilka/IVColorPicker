//
//  ColorLightingPicker.swift
//  Counter
//
//  Created by Irina Vaara on 24.07.17.
//  Copyright © 2017 Irina Vaara. All rights reserved.
//

import UIKit

public class ColorLightingPicker: UIControl
{
    //MARK: - Private constants
    
    fileprivate struct Constants
    {
        static let BorderColor = UIColor(white: 0, alpha: 0.2)
        static let Pixel: CGFloat = 1.0 / UIScreen.main.scale
    }

    //MARK: - Public variables

    public var selectedColor: UIColor
    {
        get {
            return _color
        }
        set
        {
            _color = newValue
            updateColors()
        }
    }
    
    public var sliderWidth: CGFloat = 16
    public var thumbWidth: CGFloat = 22

    //MARK: - Private variables
    
    fileprivate lazy var contentView: UIView =
    {
        let contentView = UIView()
        contentView.backgroundColor = .clear
        self.addSubview(contentView)
        
        return contentView
    }()

    fileprivate lazy var gradientLayer: CAGradientLayer =
    {
        let layer = CAGradientLayer()
        layer.locations = [0, 0.5, 1]
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.masksToBounds = true
        layer.borderColor = Constants.BorderColor.cgColor
        layer.borderWidth = Constants.Pixel

        self.contentView.layer.addSublayer(layer)
        
        return layer
    }()
    
    fileprivate lazy var thumbView: ThumbView = {
        
        let thumbView = ThumbView()
        thumbView.addGestureRecognizer(self.pan)
        self.contentView.addSubview(thumbView)
        
        return thumbView
    }()
    
    fileprivate lazy var pan: UIPanGestureRecognizer =
    {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(moveThumb(_ :)))
        return pan
    }()
    
    fileprivate lazy var tap: UITapGestureRecognizer =
    {
        let tap = UITapGestureRecognizer(target: self, action: #selector(moveThumbByTap(_ :)))
        return tap
    }()

    fileprivate var thumbCenterY: CGFloat = 0
    fileprivate var contentHalfWidth: CGFloat = 0
    fileprivate var _color: UIColor = .gray
    fileprivate var colorHue: CGFloat = 0

    //MARK: - Lifecycle

    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        addGestureRecognizer(tap)
    }
    
    public required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        addGestureRecognizer(tap)
    }

    public override func draw(_ rect: CGRect)
    {
        super.draw(rect)
                
        updateFrames(rect: rect)
        
        contentHalfWidth = contentView.frame.width / 2
        thumbCenterY = contentView.frame.height / 2
        
        updateColors()
    }

    //MARK: - Notifications handling methods
    
    @objc func moveThumb(_ gesture: UIGestureRecognizer)
    {
        let point = gesture.location(in: contentView)
        moveColor(point: point)
    }

    @objc func moveThumbByTap(_ gesture: UIGestureRecognizer)
    {
        let point = gesture.location(in: self)
        let x = point.x
        let thirdWidth = contentView.frame.width / 3
        
        var newX: CGFloat = 0
        
        if x >= thirdWidth * 2 {
            newX = contentHalfWidth * 2
        }
        else if x > thirdWidth {
            newX = contentHalfWidth
        }
        
        let newPoint = CGPoint(x: newX, y: point.y)
        moveColor(point: newPoint)
    }

    //MARK: - Private methods
    
    fileprivate func updateFrames(rect: CGRect)
    {
        // content
        let contentHeight = max(thumbWidth, sliderWidth)
        let contentY = (rect.height - contentHeight) / 2
        var contentFrame = CGRect(x: 0, y: contentY, width: rect.width, height: contentHeight)
        
        if thumbWidth > sliderWidth
        {
            let offset = (thumbWidth - sliderWidth) / 2
            contentFrame = contentFrame.insetBy(dx: offset, dy: 0)
        }
        
        contentView.frame = contentFrame
        
        // gradient
        let gradientY = (contentHeight - sliderWidth) / 2
        let gradientFrame = CGRect(x: 0, y: gradientY, width: contentFrame.width, height: sliderWidth)
        gradientLayer.frame = gradientFrame
        gradientLayer.cornerRadius = sliderWidth / 2
        
        // thumb
        let thumbRect = CGRect(x: 0, y: 0, width: thumbWidth, height: thumbWidth)
        thumbView.frame = thumbRect
    }
    
    fileprivate func updateColors()
    {
        _color.getHue(&colorHue, saturation: nil, brightness: nil, alpha: nil)

        let centerColor = UIColor(hue: colorHue, saturation: 1, brightness: 1, alpha: 1)
        let colors = [
            UIColor.white.cgColor,
            centerColor.cgColor,
            UIColor.black.cgColor
        ]
        
        gradientLayer.colors = colors
        
        thumbView.backgroundColor = _color
        moveThumb(color: _color)
    }
        
    fileprivate func moveColor(point: CGPoint)
    {
        moveThumb(point: point)

        _color = color(point: point)
        thumbView.backgroundColor = _color
        
        sendActions(for: .valueChanged)
    }
    
    fileprivate func moveThumb(point: CGPoint)
    {
        var newX = max(point.x, 0)
        newX = min(newX, contentView.frame.width)
        
        let newCenter = CGPoint(x: newX, y: thumbCenterY)
        thumbView.center = newCenter
    }
    
    fileprivate func moveThumb(color: UIColor)
    {
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0

        color.getHue(nil, saturation: &saturation, brightness: &brightness, alpha: nil)
        
        var percent: CGFloat = 0
        
        if brightness < 1 {
            percent = 2 - brightness
        }
        else {
            percent = saturation
        }
        
        let x = contentHalfWidth * percent
        let point = CGPoint(x: x, y: 0)
        moveThumb(point: point)
    }
    
    fileprivate func color(point: CGPoint) -> UIColor
    {
        var saturation: CGFloat = 1
        var brightness: CGFloat = 1

        if point.x < contentHalfWidth
        {
            let percent = point.x * 100 / contentHalfWidth
            saturation = percent / 100
        }
        else if point.x > contentHalfWidth
        {
            let percent = (point.x - contentHalfWidth) * 100 / contentHalfWidth
            brightness = 1 - percent / 100
        }

        let color = UIColor(hue: colorHue, saturation: saturation, brightness: brightness, alpha: 1.0)
        return color
    }
}
