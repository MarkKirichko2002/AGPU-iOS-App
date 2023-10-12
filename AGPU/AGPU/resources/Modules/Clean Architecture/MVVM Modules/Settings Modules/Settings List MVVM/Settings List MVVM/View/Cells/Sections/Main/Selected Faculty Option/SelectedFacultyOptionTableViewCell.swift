//
//  SelectedFacultyOptionTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 12.10.2023.
//

import UIKit

class SelectedFacultyOptionTableViewCell: UITableViewCell {
    
    static let identifier = "SelectedFacultyOptionTableViewCell"
    
    @IBOutlet var SelectedFacultyIcon: SpringImageView!
    @IBOutlet var TitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        SelectedFacultyIcon.tintColor = .label
        TitleLabel.tintColor = .label
    }
}
