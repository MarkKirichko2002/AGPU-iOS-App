//
//  AppIconTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 10.10.2023.
//

import UIKit

class PersonalizedAppIconTableViewCell: UITableViewCell {

    static let identifier = "PersonalizedAppIconTableViewCell"
    
    @IBOutlet var PersonalizedAppIcon: SpringImageView!
    @IBOutlet var PersonalizedAppIconName: UILabel!
    
    func configure(icon: AppIconModel) {
        PersonalizedAppIcon.image = UIImage(named: icon.icon)
        PersonalizedAppIconName.text = icon.name
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tintColor = .systemGreen
        PersonalizedAppIcon.tintColor = .label
        PersonalizedAppIconName.tintColor = .label
    }
}
