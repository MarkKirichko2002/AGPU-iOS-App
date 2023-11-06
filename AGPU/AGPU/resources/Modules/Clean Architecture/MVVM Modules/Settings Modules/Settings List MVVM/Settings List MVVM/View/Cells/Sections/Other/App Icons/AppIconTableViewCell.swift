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
    
    func configure(icon: String) {
        AppIconName.text = "текущая иконка (\(icon))"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        AppIcon.tintColor = .label
        AppIconName.tintColor = .label
    }
}
