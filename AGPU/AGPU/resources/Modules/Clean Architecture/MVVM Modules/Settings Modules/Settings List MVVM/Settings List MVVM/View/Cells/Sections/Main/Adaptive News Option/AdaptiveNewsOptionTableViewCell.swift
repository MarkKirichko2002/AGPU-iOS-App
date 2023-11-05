//
//  AdaptiveNewsOptionTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 04.11.2023.
//

import UIKit

class AdaptiveNewsOptionTableViewCell: UITableViewCell {
    
    static let identifier = "AdaptiveNewsOptionTableViewCell"
    
    @IBOutlet var AdaptiveNewsIcon: SpringImageView!
    @IBOutlet var TitleLabel: UILabel!
    
    func configure(category: String) {
        TitleLabel.text = "ваша категория (\(category))"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        AdaptiveNewsIcon.tintColor = .label
        TitleLabel.tintColor = .label
    }
}
