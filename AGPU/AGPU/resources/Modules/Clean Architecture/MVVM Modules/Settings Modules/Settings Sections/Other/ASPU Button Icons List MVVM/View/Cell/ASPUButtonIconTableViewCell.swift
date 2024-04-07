//
//  ASPUButtonIconTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 30.03.2024.
//

import UIKit

class ASPUButtonIconTableViewCell: UITableViewCell {

    static let identifier = "ASPUButtonIconTableViewCell"
    
    @IBOutlet var ASPUButtonIcon: SpringImageView!
    @IBOutlet var ASPUButtonIconName: UILabel!
    
    func configure(icon: ASPUButtonIconModel) {
        ASPUButtonIcon.image = UIImage(named: icon.icon)
        ASPUButtonIconName.text = icon.name
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tintColor = .systemGreen
        ASPUButtonIcon.tintColor = .label
        ASPUButtonIconName.tintColor = .label
    }
}
