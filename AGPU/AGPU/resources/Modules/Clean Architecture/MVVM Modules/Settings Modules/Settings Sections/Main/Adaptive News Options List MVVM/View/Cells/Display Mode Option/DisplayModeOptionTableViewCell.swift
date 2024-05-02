//
//  DisplayModeOptionTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 01.05.2024.
//

import UIKit

class DisplayModeOptionTableViewCell: UITableViewCell {

    static let identifier = "DisplayModeOptionTableViewCell"
    
    @IBOutlet var DisplayModeOptionIcon: SpringImageView!
    @IBOutlet var DisplayModeOptionName: UILabel!
    
    func configure(mode: String) {
        DisplayModeOptionName.text = "Вид (\(mode))"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        DisplayModeOptionIcon.tintColor = .label
        DisplayModeOptionName.textColor = .label
        backgroundColor = .systemBackground
        tintColor = .systemGreen
    }
}
