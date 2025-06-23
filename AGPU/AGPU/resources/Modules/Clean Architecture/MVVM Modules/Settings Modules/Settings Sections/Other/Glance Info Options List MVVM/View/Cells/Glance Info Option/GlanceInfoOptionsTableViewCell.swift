//
//  GlanceInfoOptionsTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 17.06.2025.
//

import UIKit

class GlanceInfoOptionsTableViewCell: UITableViewCell {

    static let identifier = "GlanceInfoOptionsTableViewCell"
    
    @IBOutlet var OptionIcon: SpringImageView!
    @IBOutlet var OptionName: UILabel!
    
    func configure(option: GlanceInfoOptionModel) {
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
