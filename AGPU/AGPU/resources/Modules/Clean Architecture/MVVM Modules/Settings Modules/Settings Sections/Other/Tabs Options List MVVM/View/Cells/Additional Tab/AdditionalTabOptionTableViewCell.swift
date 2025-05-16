//
//  AdditionalTabOptionTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 24.12.2024.
//

import UIKit

class AdditionalTabOptionTableViewCell: UITableViewCell {

    static let identifier = "AdditionalTabOptionTableViewCell"
    
    @IBOutlet var OptionIcon: SpringImageView!
    @IBOutlet var OptionName: UILabel!
    
    func configure(option: AdditionalTabVariants) {
        OptionName.text = "Доп. вкладка: (\(option.rawValue))"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        OptionIcon.tintColor = .label
        OptionName.textColor = .label
    }
}
