//
//  TabsIconStyleTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 23.06.2024.
//

import UIKit

class TabsIconStyleTableViewCell: UITableViewCell {
        
    static let identifier = "TabsIconStyleTableViewCell"
    
    @IBOutlet var OptionIcon: SpringImageView!
    @IBOutlet var OptionName: UILabel!
    
    func configure(style: TabBarIconsStyle) {
        OptionName.text = "Стиль иконок (\(style.rawValue))"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        OptionIcon.tintColor = .label
        OptionName.textColor = .label
    }
}
