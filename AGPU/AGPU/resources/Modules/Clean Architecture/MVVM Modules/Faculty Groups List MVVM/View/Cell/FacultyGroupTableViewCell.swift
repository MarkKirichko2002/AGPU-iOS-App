//
//  FacultyGroupTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 22.07.2023.
//

import UIKit

class FacultyGroupTableViewCell: UITableViewCell {
    
    static let identifier = "FacultyGroupTableViewCell"
    
    @IBOutlet var AGPUFacultyIcon: SpringImageView!
    @IBOutlet var GroupName: UILabel!
    
    func configure(faculty: AGPUFacultyModel, group: String) {
        AGPUFacultyIcon.image = UIImage(named: faculty.icon)
        GroupName.text = group
        self.backgroundColor = .clear
    }
}
