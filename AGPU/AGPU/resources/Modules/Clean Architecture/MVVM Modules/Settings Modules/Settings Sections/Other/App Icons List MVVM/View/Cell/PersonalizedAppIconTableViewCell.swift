//
//  AppIconTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 10.10.2023.
//

import UIKit

class PersonalizedAppIconTableViewCell: UITableViewCell {
    
    static let identifier = "PersonalizedAppIconTableViewCell"
    var icon: AppIconModel?
    
    private let animation = AnimationClass()
    
    @IBOutlet var PersonalizedAppIcon: UIImageView!
    @IBOutlet var PersonalizedAppIconName: UILabel!
    
    func configure(icon: AppIconModel) {
        PersonalizedAppIcon.image = UIImage(named: icon.icon)
        PersonalizedAppIconName.text = icon.name
        self.icon = icon
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tintColor = .systemGreen
        PersonalizedAppIconName.tintColor = .label
        setUpImage()
    }
    
    private func setUpImage() {
        PersonalizedAppIcon.tintColor = .label
        PersonalizedAppIcon.clipsToBounds = true
        PersonalizedAppIcon.layer.cornerRadius = 12
        PersonalizedAppIcon.layer.borderWidth = 1
        PersonalizedAppIcon.layer.borderColor = UIColor.label.cgColor
    }
}
