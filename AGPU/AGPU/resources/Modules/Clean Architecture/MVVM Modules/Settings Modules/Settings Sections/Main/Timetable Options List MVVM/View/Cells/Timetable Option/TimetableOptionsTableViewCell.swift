//
//  TimetableOptionsTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 19.11.2023.
//

import UIKit

class TimetableOptionsTableViewCell: UITableViewCell {

    static let identifier = "TimetableOptionsTableViewCell"
    
    @IBOutlet var OptionIcon: SpringImageView!
    @IBOutlet var OptionName: UILabel!
    
    func configure(option: TimetableSettingsOptionModel) {
        OptionIcon.image = UIImage(named: option.icon)
        if option.info != "" {
            OptionName.text = "\(option.name) (\(option.info))"
        } else {
            OptionName.text = option.name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tintColor = .systemGreen
        OptionIcon.tintColor = .label
        OptionName.tintColor = .label
    }
}
