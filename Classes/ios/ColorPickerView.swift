//
//  ColorPickerView.swift
//  Counter
//
//  Created by Irina Vaara on 21.07.17.
//  Copyright © 2017 Irina Vaara. All rights reserved.
//

import UIKit
//import AEConicalGradient

@IBDesignable
public class ColorPickerView: UIControl
{
    //MARK: - Private constants

    fileprivate struct Constants
    {
        static let Pixel: CGFloat = 1.0 / UIScreen.main.scale
        static let BorderWidth: CGFloat = 5
    }

    //MARK: - Public variables

    @IBInspectable public var sliderWidth: CGFloat = 16 {
        
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var thumbWidth: CGFloat = 22 {
        
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable public var applyButtonWidth: CGFloat = 60 {
        
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable public var selectedColor: UIColor = .green

    @IBInspectable public var applyImage: UIImage? = nil {
        
        didSet {
            self.applyImageView.image = applyImage
        }
    }
    
    //MARK: - Private variables
    
    fileprivate lazy var gradientLayer: ConicalGradientLayer = {
        
        let gradientLayer = ConicalGradientLayer()
        gradientLayer.contentsScale = UIScreen.main.scale
        gradientLayer.drawsAsynchronously = true
        gradientLayer.masksToBounds = true

        self.layer.addSublayer(gradientLayer)
        
        return gradientLayer
    }()

    fileprivate lazy var thumbView: ThumbView = {
        
        let thumbView = ThumbView()
        thumbView.addGestureRecognizer(self.pan)
        self.addSubview(thumbView)

        return thumbView
    }()

    fileprivate lazy var centerView: UIView = {
        
        let centerView = UIView()
        centerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        self.addSubview(centerView)
        
        return centerView
    }()

    fileprivate lazy var whiteCenterView: UIView = {
        
        let whiteCenterView = UIView()
        whiteCenterView.backgroundColor = UIColor.white
        self.addSubview(whiteCenterView)
        
        return whiteCenterView
    }()

    fileprivate lazy var applyButton: ColorApplyButton = {
        
        let applyButton = ColorApplyButton(type: .custom)
        applyButton.addTarget(self, action: #selector(apply(_ :)), for: .touchUpInside)
        applyButton.borderWidth = Constants.BorderWidth
        self.addSubview(applyButton)
        
        return applyButton
    }()
    
    fileprivate lazy var applyImageView: UIImageView = {
        
        let applyImageView = UIImageView()
        applyImageView.contentMode = .center
        applyImageView.alpha = 0.75
        self.addSubview(applyImageView)

        return applyImageView
    }()
    
    fileprivate lazy var lightingPicker: ColorLightingPicker = {
       
        let picker = ColorLightingPicker()
        picker.addTarget(self, action: #selector(changeLighting(_ :)), for: .valueChanged)
        picker.backgroundColor = UIColor.white

        self.addSubview(picker)
        
        return picker
    }()
    
    fileprivate lazy var pan: UIPanGestureRecognizer =
    {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(moveThumb(_ :)))
        return pan
    }()
    
    fileprivate lazy var tap: UITapGestureRecognizer =
    {
        let tap = UITapGestureRecognizer(target: self, action: #selector(moveThumb(_ :)))
        return tap
    }()

    fileprivate var gradientRadius: CGFloat = 0
    fileprivate var gradientCenter: CGPoint = .zero
    
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
        
        gradientCenter = bounds.center
        gradientRadius = (bounds.height - thumbWidth) / 2

        let angle = CGFloat(gradientLayer.angle(forColor: selectedColor)).degree
        moveThumb(angle: angle)

        lightingPicker.sliderWidth = sliderWidth
        lightingPicker.thumbWidth = thumbWidth
        
        updateColorForViews()
        updateLighting()
    }
    
    //MARK: - Notifications handling methods

    @objc func moveThumb(_ gesture: UIGestureRecognizer)
    {
        let point = gesture.location(in: self)
        let angle = self.angle(from: gradientCenter, to: point)
        moveThumb(angle: angle)
        
        selectedColor = gradientLayer.color(forAngle: angle.radian)
        updateColorForViews()
        updateLighting()
    }
    
    @objc func apply(_ sender: Any)
    {
        sendActions(for: .valueChanged)
    }
    
    @objc func changeLighting(_ sender: ColorLightingPicker)
    {
        let color = sender.selectedColor
        selectedColor = color
        
        updateColorForViews()
    }
    
    //MARK: - Private methods
    
    fileprivate func updateFrames(rect: CGRect)
    {
        // gradient
        var gradientFrame = bounds
        
        if thumbWidth > sliderWidth
        {
            let offset = (thumbWidth - sliderWidth) / 2
            gradientFrame = gradientFrame.insetBy(dx: offset, dy: offset)
        }
        
        gradientLayer.frame = gradientFrame
        gradientLayer.cornerRadius = gradientFrame.width / 2
        
        // center
        let centerFrame = gradientFrame.insetBy(dx: sliderWidth, dy: sliderWidth)
        centerView.frame = centerFrame
        centerView.layer.cornerRadius = centerFrame.height / 2
        
        let whiteCenterFrame = centerFrame.insetBy(dx: Constants.BorderWidth, dy: Constants.BorderWidth)
        whiteCenterView.frame = whiteCenterFrame
        whiteCenterView.layer.cornerRadius = whiteCenterFrame.height / 2
        
        // apply button
        let newApplyButtonWidth = min(whiteCenterFrame.width, applyButtonWidth)
        let applyButtonFrame = CGRect(x: 0, y: 0, width: newApplyButtonWidth, height: newApplyButtonWidth)
        applyButton.frame = applyButtonFrame
        applyButton.center = whiteCenterView.center
        
        // apply image view
        insertSubview(applyImageView, aboveSubview: applyButton)
        applyImageView.frame = applyButton.frame

        // thumb
        let thumbRect = CGRect(x: 0, y: 0, width: thumbWidth, height: thumbWidth)
        thumbView.frame = thumbRect
        
        // lighting picker
        let lightingPickerHeight = max(thumbWidth, sliderWidth) * 2 // for good pick
        let pickerSize = CGSize(width: rect.width / 2, height: lightingPickerHeight)
        let pickerCenter = CGPoint(x: rect.width / 2, y: rect.height * 0.75)
        lightingPicker.frame = CGRect(x: 0, y: 0, width: pickerSize.width, height: pickerSize.height)
        lightingPicker.center = pickerCenter
    }

    fileprivate func moveThumb(angle: Int)
    {
        let newCenter = circlePoint(angle: angle)
        thumbView.center = newCenter
    }
    
    fileprivate func updateColorForViews()
    {
        gradientLayer.hsb = HSB(color: selectedColor)
        applyButton.color = selectedColor
        thumbView.backgroundColor = selectedColor
    }
    
    fileprivate func updateLighting()
    {
        lightingPicker.selectedColor = selectedColor
    }
    
    fileprivate func angle(from center: CGPoint, to point: CGPoint) -> Int
    {
        let x = point.x - center.x
        let y = point.y - center.y
        let radians = atan2(y, x)
        var result = radians.degree
        
        if result < 0 {
            result = result + 360
        }
        
        return result
    }
    
    fileprivate func circlePoint(angle: Int) -> CGPoint
    {
        let x = gradientCenter.x + gradientRadius * cos(-angle.radian)
        let y = gradientCenter.y + gradientRadius * sin(angle.radian)
        let point = CGPoint(x: x, y: y)
        
        return point
    }
}
