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
    @IBOutlet var ElectedFacultyName: UILabel!
     
    func configure(faculty: ElectedFacultyModel) {
        ElectedFacultyIcon.image = UIImage(named: faculty.icon)
        ElectedFacultyName.text = faculty.name
    }
}
