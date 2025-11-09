//
//  ASPUButtonIconTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 30.03.2024.
//

import UIKit

final class ASPUButtonIconTableViewCell: UITableViewCell {

    static let identifier = "ASPUButtonIconTableViewCell"
    
    @IBOutlet var ASPUButtonIcon: SpringImageView!
    @IBOutlet var ASPUButtonIconName: UILabel!
    
    func configure(icon: ASPUButtonIconModel) {
        configureIcon(icon: icon)
        ASPUButtonIconName.text = icon.name
    }
    
    func configureIcon(icon: ASPUButtonIconModel) {
        if icon.id == 6 {
            configureCustomIcon()
        }
        ASPUButtonIcon.image = UIImage(data: icon.icon)?.withRenderingMode(.alwaysOriginal)
    }
    
    func configureCustomIcon() {
        ASPUButtonIcon.layer.cornerRadius = ASPUButtonIcon.frame.width / 2
        ASPUButtonIcon.clipsToBounds = true
        ASPUButtonIcon.layer.borderWidth = 2.0
        ASPUButtonIcon.layer.borderColor = UIColor.label.cgColor
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tintColor = .systemGreen
        ASPUButtonIcon.tintColor = .label
        ASPUButtonIconName.tintColor = .label
    }
}
