//
//  FacultyCathedraTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 24.07.2023.
//

import UIKit

final class FacultyCathedraTableViewCell: UITableViewCell {
    
    static let identifier = "FacultyCathedraTableViewCell"
    
    @IBOutlet var FacultyIcon: SpringImageView!
    @IBOutlet var CathedraName: UILabel!
    
    func configure(cathedra: FacultyCathedraModel, faculty: AGPUFacultyModel) {
        FacultyIcon.image = UIImage(named: faculty.icon)
        CathedraName.text = cathedra.name
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        CathedraName.textColor = .label
        backgroundColor = .systemBackground
    }
}
