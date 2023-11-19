//
//  TimetableOptionTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 18.11.2023.
//

import UIKit

class TimetableOptionTableViewCell: UITableViewCell {

    static let identifier = "TimetableOptionTableViewCell"
    
    @IBOutlet var TimetableOptionIcon: SpringImageView!
    @IBOutlet var TitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        TimetableOptionIcon.tintColor = .label
        TitleLabel.tintColor = .label
    }
}
