//
//  UserStatusTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 31.08.2023.
//

import UIKit

class UserStatusTableViewCell: UITableViewCell {

    static let identifier = "UserStatusTableViewCell"
    
    @IBOutlet var StatusIcon: SpringImageView!
    @IBOutlet var StatusName: UILabel!
    
    func configure(type: UserStatusModel) {
        StatusIcon.image = UIImage(named: type.icon)
        StatusName.text = type.name
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        StatusIcon.tintColor = .label
    }
}
