//
//  ASPUButtonGesturesOptionTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 02.12.2024.
//

import UIKit

final class ASPUButtonGesturesOptionTableViewCell: UITableViewCell {

    static let identifier = "ASPUButtonGesturesOptionTableViewCell"
    
    @IBOutlet var OptionIcon: SpringImageView!
    @IBOutlet var OptionName: UILabel!
    
    func configure(gesture: ASPUButtonGestureOptions) {
        OptionName.text = "Жест для активации (\(gesture.rawValue))"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        OptionIcon.tintColor = .label
        OptionName.textColor = .label
        backgroundColor = .systemBackground
        tintColor = .systemGreen
    }
}
