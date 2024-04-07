//
//  ASPUButtonIconOptionTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 30.03.2024.
//

import UIKit

class ASPUButtonIconOptionTableViewCell: UITableViewCell {

    static let identifier = "ASPUButtonIconOptionTableViewCell"
    
    @IBOutlet var OptionIcon: SpringImageView!
    @IBOutlet var OptionName: UILabel!
    
    func configure(action: String) {
        OptionName.text = "Иконка (\(action))"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        OptionIcon.tintColor = .label
        OptionName.textColor = .label
        backgroundColor = .systemBackground
        tintColor = .systemGreen
    }
}
