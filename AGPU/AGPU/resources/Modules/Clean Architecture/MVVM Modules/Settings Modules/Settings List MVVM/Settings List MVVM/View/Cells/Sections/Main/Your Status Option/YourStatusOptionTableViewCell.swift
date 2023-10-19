//
//  YourStatusOptionTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 12.10.2023.
//

import UIKit

class YourStatusOptionTableViewCell: UITableViewCell {

    static let identifier = "YourStatusOptionTableViewCell"
    
    @IBOutlet var YourStatusIcon: SpringImageView!
    @IBOutlet var TitleLabel: UILabel!
    
    func configure(status: UserStatusModel) {
        YourStatusIcon.image = UIImage(named: status.icon)
        TitleLabel.text = "ваш статус (\(status.name))"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        YourStatusIcon.tintColor = .label
        TitleLabel.tintColor = .label
    }
}
