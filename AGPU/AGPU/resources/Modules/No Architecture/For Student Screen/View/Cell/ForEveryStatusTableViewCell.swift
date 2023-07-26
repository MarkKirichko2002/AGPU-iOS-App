//
//  ForEveryStatusTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 25.07.2023.
//

import UIKit

class ForEveryStatusTableViewCell: UITableViewCell {
    
    static let identifier = "ForEveryStatusTableViewCell"
    
    @IBOutlet var SectionIcon: SpringImageView!
    @IBOutlet var SectionName: UILabel!
    
    func configure(for student: ForEveryStatusModel) {
        SectionIcon.image = UIImage(named: student.icon)
        SectionName.text = student.name
    }
}
