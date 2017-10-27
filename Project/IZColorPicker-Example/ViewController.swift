//
//  ViewController.swift
//  IZColorPicker-Example
//
//  Created by Irina Vaara on 27.10.17.
//  Copyright © 2017 Irina Vaara. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var firstColoredView: UIView!
    @IBOutlet weak var secondColoredView: UIView!
    @IBOutlet weak var thirdColoredView: UIView!

    fileprivate weak var selectedColoredView: UIView?
    
    fileprivate struct Segue
    {
        static let ChangeFirstColor = "ChangeFirstColor"
        static let ChangeSecondColor = "ChangeSecondColor"
        static let ChangeThirdColor = "ChangeThirdColor"
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        firstColoredView.backgroundColor = .red
        secondColoredView.backgroundColor = .orange
        thirdColoredView.backgroundColor = .yellow
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let colorPicker = (segue.destination as? UINavigationController)?.viewControllers.first as? ColorPickerController
        {
            switch segue.identifier!
            {
            case Segue.ChangeFirstColor:
                selectedColoredView = firstColoredView
                
            case Segue.ChangeSecondColor:
                selectedColoredView = secondColoredView
                
            default:
                selectedColoredView = thirdColoredView
            }
            
            colorPicker.selectedColor = selectedColoredView!.backgroundColor!
            colorPicker.delegate = self
            
            let colorPalette = [
                firstColoredView.backgroundColor!,
                secondColoredView.backgroundColor!,
                thirdColoredView.backgroundColor!
            ]
            
            colorPicker.colorsPalette = colorPalette
        }
    }
}

extension ViewController: ColorPickerControllerDelegate
{
    func colorPickerController(_ controller: ColorPickerController, didSelectColor color: UIColor)
    {
        selectedColoredView?.backgroundColor = color
        selectedColoredView = nil
        
        dismiss(animated: true, completion: nil)
    }
}


