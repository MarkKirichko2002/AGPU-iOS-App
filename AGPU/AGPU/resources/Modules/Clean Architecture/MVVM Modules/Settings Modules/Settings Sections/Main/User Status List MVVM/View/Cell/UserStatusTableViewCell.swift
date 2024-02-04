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
    
    func configure(status: UserStatusModel, viewModel: UserStatusListViewModel) {
        StatusIcon.image = UIImage(named: viewModel.isStatusSelected(index: status.id - 1) ? status.iconSelected : status.icon)
        StatusName.text = status.name
        StatusName.textColor = viewModel.isStatusSelected(index: status.id - 1) ? .systemGreen : .label
        accessoryType = viewModel.isStatusSelected(index: status.id - 1) ? .checkmark : .none
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tintColor = .systemGreen
        StatusIcon.tintColor = .label
        StatusName.tintColor = .label
    }
}
