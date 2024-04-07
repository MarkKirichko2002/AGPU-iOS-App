//
//  CustomTabBarOptionTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 24.03.2024.
//

import UIKit

class CustomTabBarOptionTableViewCell: UITableViewCell {

    static let identifier = "CustomTabBarOptionTableViewCell"
    
    @IBOutlet var OptionIcon: SpringImageView!
    @IBOutlet var OptionName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        OptionIcon.tintColor = .label
        OptionName.tintColor = .label
    }
}
