//
//  AppIconTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 10.10.2023.
//

import UIKit

class AppIconTableViewCell: UITableViewCell {

    static let identifier = "AppIconTableViewCell"
    
    @IBOutlet var AppIcon: SpringImageView!
    @IBOutlet var AppIconName: UILabel!
    
    func configure(type: UserStatusModel) {
        AppIcon.image = UIImage(named: type.icon)
        AppIconName.text = type.name
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        AppIcon.tintColor = .label
        AppIconName.tintColor = .label
    }
}
