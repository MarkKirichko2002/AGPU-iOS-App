//
//  SelectedFacultyOptionTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 12.10.2023.
//

import UIKit

class SelectedFacultyOptionTableViewCell: UITableViewCell {
    
    static let identifier = "SelectedFacultyOptionTableViewCell"
    private let animation = AnimationClass()
    
    @IBOutlet var SelectedFacultyIcon: SpringImageView!
    @IBOutlet var TitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        SelectedFacultyIcon.tintColor = .label
        TitleLabel.tintColor = .label
    }
    
    func configure(faculty: AGPUFacultyModel?) {
        if let faculty = faculty {
            TitleLabel.text = "Ваш факультет (\(faculty.abbreviation))"
        } else {
            TitleLabel.text = "Нет факультета"
        }
    }
    
    func didTapCell(indexPath: IndexPath) {
        animation.flipAnimation(view: self, option: .transitionFlipFromLeft) {
            HapticsManager.shared.hapticFeedback()
        }
    }
}
