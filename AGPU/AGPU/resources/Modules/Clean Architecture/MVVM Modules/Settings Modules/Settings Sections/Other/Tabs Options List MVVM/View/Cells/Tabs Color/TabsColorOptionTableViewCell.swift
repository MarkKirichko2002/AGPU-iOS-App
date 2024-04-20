//
//  TabsColorOptionTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 18.04.2024.
//

import UIKit

class TabsColorOptionTableViewCell: UITableViewCell {
        
    static let identifier = "TabsColorOptionTableViewCell"
    
    @IBOutlet var OptionIcon: SpringImageView!
    @IBOutlet var OptionName: UILabel!
    
    func configure(color: Colors) {
        OptionIcon.tintColor = color.color
        OptionName.text = "Цвет (\(color.title))"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        OptionName.textColor = .label
    }
}
