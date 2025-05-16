//
//  SoundOptionsTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 22.10.2024.
//

import UIKit

final class SoundOptionsTableViewCell: UITableViewCell {

    static let identifier = "SoundOptionsTableViewCell"
    
    @IBOutlet var OptionIcon: SpringImageView!
    @IBOutlet var OptionName: UILabel!
    
    func configure(option: TabBarSoundOptions) {
        OptionName.text = "Звуки (\(option.rawValue))"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        OptionIcon.tintColor = .label
        OptionName.textColor = .label
    }
}
