//
//  SavedImageTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 09.05.2024.
//

import UIKit

class SavedImageTableViewCell: UITableViewCell {
    
    static let identifier = "SavedImageTableViewCell"
    
    @IBOutlet var SavedImage: SpringImageView!
    @IBOutlet var DateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpImage()
    }
    
    func configure(image: ImageModel) {
        SavedImage.image = UIImage(data: image.image)
        DateLabel.text = image.date
    }
    
    private func setUpImage() {
        SavedImage.clipsToBounds = true
        SavedImage.layer.cornerRadius = 8
        SavedImage.layer.borderWidth = 2
        SavedImage.layer.borderColor = UIColor.label.cgColor
        SavedImage.isInteraction = false
        SavedImage.contentMode = .scaleAspectFill
    }
}
