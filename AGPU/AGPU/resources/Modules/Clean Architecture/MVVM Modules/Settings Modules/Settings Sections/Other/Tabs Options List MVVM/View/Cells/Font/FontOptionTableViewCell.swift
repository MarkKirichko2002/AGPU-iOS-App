//
//  FontOptionTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 16.12.2024.
//

import UIKit

class FontOptionTableViewCell: UITableViewCell {

    static let identifier = "FontOptionTableViewCell"
    
    @IBOutlet var OptionIcon: SpringImageView!
    @IBOutlet var OptionName: UILabel!
    
    func configure(font: TabFonts) {
        OptionName.text = "Шрифт (\(font.rawValue))"
        OptionName.font = font.font
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        OptionIcon.tintColor = .label
        OptionName.textColor = .label
    }
}
