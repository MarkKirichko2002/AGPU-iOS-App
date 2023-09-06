//
//  AppFeaturesTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 26.07.2023.
//

import UIKit

class AppFeaturesTableViewCell: UITableViewCell {

    static let identifier = "AppFeaturesTableViewCell"
    
    @IBOutlet var InfoIcon: SpringImageView!
    @IBOutlet var TitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        InfoIcon.tintColor = .label
        TitleLabel.textColor = .label
    }
}
