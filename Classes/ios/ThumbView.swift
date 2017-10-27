//
//  ThumbView.swift
//  Counter
//
//  Created by Irina Vaara on 21.07.17.
//  Copyright © 2017 Irina Vaara. All rights reserved.
//

import UIKit

public class ThumbView: UIView
{
    //MARK: - Private constants
    
    fileprivate let borderWidth: CGFloat = 2.0
    
    //MARK: - Public variables
    
    public override var frame: CGRect
    {
        didSet {
            setup()
        }
    }
    
    public override var backgroundColor: UIColor?
    {
        didSet {
            updateColor()
        }
    }
    
    fileprivate lazy var visualEffectView: UIVisualEffectView =
    {
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        self.addSubview(visualEffectView)
        
        return visualEffectView
    }()
    
    fileprivate lazy var centerView: UIView =
    {
        let centerView = UIView()
        centerView.layer.masksToBounds = true
        
        self.addSubview(centerView)
        
        return centerView
    }()
    
    fileprivate func setup()
    {
        let radius = min(frame.width, frame.height) / 2
        layer.cornerRadius = radius
        layer.masksToBounds = true
                
        visualEffectView.frame = self.bounds
        
        let centerRect = bounds.insetBy(dx: borderWidth, dy: borderWidth)
        centerView.frame = centerRect
        centerView.layer.cornerRadius = centerRect.height / 2
        
        updateColor()
    }
    
    fileprivate func updateColor()
    {
        centerView.backgroundColor = backgroundColor
    }
}
