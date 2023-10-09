//
//  NotificationsTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 09.10.2023.
//

import UIKit

class NotificationsTableViewCell: UITableViewCell {

    static let identifier = "NotificationsTableViewCell"
    
    @IBOutlet var NotificationIcon: SpringImageView!
    @IBOutlet var TitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationIcon.tintColor = .label
        TitleLabel.textColor = .label
    }
}
