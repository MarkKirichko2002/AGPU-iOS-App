//
//  ForStudentTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 25.07.2023.
//

import UIKit

class ForStudentTableViewCell: UITableViewCell {
    
    static let identifier = "ForStudentTableViewCell"
    
    @IBOutlet var SectionIcon: SpringImageView!
    @IBOutlet var SectionName: UILabel!
    
    func configure(for student: ForStudentModel) {
        SectionIcon.image = UIImage(named: student.icon)
        SectionName.text = student.name
    }
}
