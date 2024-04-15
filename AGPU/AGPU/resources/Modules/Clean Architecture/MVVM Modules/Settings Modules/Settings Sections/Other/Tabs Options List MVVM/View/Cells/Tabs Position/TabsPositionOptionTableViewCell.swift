//
//  TabsPositionOptionTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 15.04.2024.
//

import UIKit

class TabsPositionOptionTableViewCell: UITableViewCell {

    static let identifier = "TabsPositionOptionTableViewCell"
    
    @IBOutlet var TabsPositionOptionIcon: SpringImageView!
    @IBOutlet var TabsPositionOptionName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        TabsPositionOptionIcon.tintColor = .label
        TabsPositionOptionName.textColor = .label
        backgroundColor = .systemBackground
        tintColor = .systemGreen
    }
}
