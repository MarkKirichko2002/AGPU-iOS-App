//
//  FacultyGroupTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 22.07.2023.
//

import UIKit

final class FacultyGroupTableViewCell: UITableViewCell {
    
    static let identifier = "FacultyGroupTableViewCell"
    
    @IBOutlet var AGPUFacultyIcon: SpringImageView!
    @IBOutlet var GroupName: UILabel!
    
    func configure(facultyIcon: String, group: String) {
        AGPUFacultyIcon.image = UIImage(named: facultyIcon)
        GroupName.text = group
        self.backgroundColor = .clear
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        GroupName.textColor = .label
        backgroundColor = .systemBackground
    }
}
