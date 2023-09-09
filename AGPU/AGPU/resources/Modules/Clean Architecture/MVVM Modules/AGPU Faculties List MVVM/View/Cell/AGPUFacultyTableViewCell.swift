//
//  AGPUFacultyTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 26.06.2023.
//

import UIKit

final class AGPUFacultyTableViewCell: UITableViewCell {
    
    static let identifier = "AGPUFacultyTableViewCell"
    
    @IBOutlet var AGPUFacultyIcon: SpringImageView!
    @IBOutlet var AGPUFacultyName: UILabel!
     
    func configure(faculty: AGPUFacultyModel) {
        AGPUFacultyIcon.image = UIImage(named: faculty.icon)
        AGPUFacultyName.text = faculty.name
        self.backgroundColor = .clear
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        AGPUFacultyName.textColor = .label
        backgroundColor = .systemBackground
    }
}
