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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        AdaptiveNewsIcon.tintColor = .label
        TitleLabel.tintColor = .label
    }
}
