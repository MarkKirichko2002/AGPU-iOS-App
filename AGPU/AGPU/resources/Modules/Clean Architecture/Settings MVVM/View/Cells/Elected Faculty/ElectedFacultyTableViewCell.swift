//
//  ElectedFacultyTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 26.06.2023.
//

import UIKit

class ElectedFacultyTableViewCell: UITableViewCell {
    
    static let identifier = "ElectedFacultyTableViewCell"
    
    @IBOutlet var ElectedFacultyIcon: SpringImageView!
    @IBOutlet var TitleLabel: UILabel!
     
    func configure(icon: AlternateIconModel) {
        ElectedFacultyIcon.image = UIImage(named: icon.icon)
        TitleLabel.text = icon.name
    }
}
