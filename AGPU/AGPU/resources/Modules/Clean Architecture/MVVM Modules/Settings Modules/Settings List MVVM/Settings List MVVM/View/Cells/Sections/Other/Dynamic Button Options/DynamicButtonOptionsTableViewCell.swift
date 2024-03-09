//
//  DynamicButtonOptionsTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 04.02.2024.
//

import UIKit

class DynamicButtonOptionsTableViewCell: UITableViewCell {

    static let identifier = "DynamicButtonOptionsTableViewCell"
    
    @IBOutlet var OptionIcon: SpringImageView!
    @IBOutlet var TitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        OptionIcon.tintColor = .label
        TitleLabel.textColor = .label
    }
    
    func configure(action: DynamicButtonActions) {
        TitleLabel.text = action.rawValue
    }
}
