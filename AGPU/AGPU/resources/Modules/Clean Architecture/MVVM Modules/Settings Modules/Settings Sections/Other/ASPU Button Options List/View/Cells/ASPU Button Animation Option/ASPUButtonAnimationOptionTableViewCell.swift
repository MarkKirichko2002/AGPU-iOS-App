//
//  ASPUButtonAnimationOptionTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 16.04.2024.
//

import UIKit

class ASPUButtonAnimationOptionTableViewCell: UITableViewCell {

    static let identifier = "ASPUButtonAnimationOptionTableViewCell"
    
    @IBOutlet var OptionIcon: SpringImageView!
    @IBOutlet var OptionName: UILabel!
    
    func configure(action: String) {
        OptionName.text = "Анимация (\(action))"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        OptionIcon.tintColor = .label
        OptionName.textColor = .label
        backgroundColor = .systemBackground
        tintColor = .systemGreen
    }
}
