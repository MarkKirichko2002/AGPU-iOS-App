//
//  RecentMomentTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 10.08.2023.
//

import UIKit

class RecentMomentTableViewCell: UITableViewCell {

    static let identifier = "RecentMomentTableViewCell"
    
    @IBOutlet var MomentName: UILabel!
    @IBOutlet var MomentIcon: SpringImageView!
    
    func configure(moment: RecentMomentModel) {
        MomentName.text = moment.name
        MomentIcon.image = UIImage(named: moment.icon)
    }
}
