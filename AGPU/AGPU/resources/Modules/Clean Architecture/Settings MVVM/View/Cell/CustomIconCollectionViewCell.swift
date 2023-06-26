//
//  CustomIconTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 26.06.2023.
//

import UIKit

class CustomIconTableViewCell: UITableViewCell {
    
    static let identifier = "CustomIconTableViewCell"
    
    @IBOutlet var CustomIcon: UIImageView!
    @IBOutlet var TitleLabel: UILabel!
     
    func configure(icon: AlternateIconModel) {
        CustomIcon.image = UIImage(named: icon.icon)
        TitleLabel.text = icon.name
    }
}
