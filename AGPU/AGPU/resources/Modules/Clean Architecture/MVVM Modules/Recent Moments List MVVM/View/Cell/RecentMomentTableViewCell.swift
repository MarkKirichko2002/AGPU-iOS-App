//
//  RecentMomentTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 10.08.2023.
//

import UIKit

class RecentMomentTableViewCell: UITableViewCell {

    static let identifier = "RecentMomentTableViewCell"
    
    @IBOutlet var MomentIcon: SpringImageView!
    @IBOutlet var MomentName: UILabel!
    
    func configure(moment: RecentMomentModel) {
        MomentName.text = moment.name
        MomentIcon.image = UIImage(named: moment.icon)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        MomentIcon.tintColor = .label
        MomentName.textColor = .label
        backgroundColor = .systemBackground
    }
}
