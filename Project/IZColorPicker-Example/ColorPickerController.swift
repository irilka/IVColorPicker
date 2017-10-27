//
//  ColorPickerController.swift
//  Counter
//
//  Created by Irina Zavilkina on 21.07.17.
//  Copyright © 2017 Irina Vaara. All rights reserved.
//

import UIKit
import IZColorPicker

protocol ColorPickerControllerDelegate
{
    func colorPickerController(_ controller: ColorPickerController, didSelectColor color: UIColor)
}

class ColorPickerController: UIViewController
{
    // MARK: - Outlets

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var colorPickerContainerView: UIView!
    @IBOutlet weak var colorPickerView: ColorPickerView!
    @IBOutlet weak var colorsPaletteCollectionView: UICollectionView!

    // MARK: - Public variables

    var selectedColor: UIColor = .green
    var colorsPalette: [UIColor] = []
    
    var delegate: ColorPickerControllerDelegate? = nil

    // MARK: - Constructors

    class func controller() -> ColorPickerController
    {
        let id = String(describing: self)
        let controller = UIStoryboard(name: id, bundle: nil).instantiateInitialViewController() as! ColorPickerController
        
        return controller
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad()
    {
        super.viewDidLoad()

        setupSubviews()
    }
    
    // MARK: - Actions

    @IBAction func changeColor(_ sender: ColorPickerView)
    {        
        delegate?.colorPickerController(self, didSelectColor: sender.selectedColor)
    }
    
    @IBAction func cancel(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Private methods
    
    fileprivate func setupSubviews()
    {
        backgroundImageView.image = UIApplication.shared.keyWindow?.snapshot()
        
        colorPickerView.selectedColor = selectedColor
    }
}

// MARK: - UICollectionViewDataSource

extension ColorPickerController: UICollectionViewDataSource
{
    fileprivate static let CellId = "ColorPaletteCell"
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return colorsPalette.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorPickerController.CellId, for: indexPath)
        let color = colorsPalette[indexPath.row]
        
        cell.contentView.circle()
        cell.contentView.backgroundColor = color
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension ColorPickerController: UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let color = colorsPalette[indexPath.row]
        colorPickerView.selectedColor = color
        colorPickerView.setNeedsDisplay()
    }
}
