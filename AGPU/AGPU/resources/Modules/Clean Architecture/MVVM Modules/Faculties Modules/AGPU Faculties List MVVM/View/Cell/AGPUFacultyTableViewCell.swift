//
//  AGPUFacultyTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 26.06.2023.
//

import UIKit

final class AGPUFacultyTableViewCell: UITableViewCell {
    
    static let identifier = "AGPUFacultyTableViewCell"
    
    weak var delegate: AGPUFacultyTableViewCellDelegate?
    private var faculty: AGPUFacultyModel?
    private let animation = AnimationClass()
    
    @IBOutlet var AGPUFacultyIcon: UIImageView!
    @IBOutlet var AGPUFacultyName: UILabel!
     
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpCell()
        setUpIcon()
    }
    
    private func setUpCell() {
        tintColor = .systemGreen
        AGPUFacultyName.textColor = .label
        backgroundColor = .systemBackground
    }
    
    func configure(faculty: AGPUFacultyModel) {
        AGPUFacultyIcon.image = UIImage(named: faculty.icon)
        AGPUFacultyName.text = faculty.name
        self.faculty = faculty
        self.backgroundColor = .clear
    }
    
    private func setUpIcon() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(openInfo))
        AGPUFacultyIcon.isUserInteractionEnabled = true
        AGPUFacultyIcon.addGestureRecognizer(tap)
    }
    
    @objc private func openInfo() {
        if let faculty = faculty {
            animation.flipAnimation(view: self.AGPUFacultyIcon, option: .transitionFlipFromRight) {
                self.delegate?.openFacultyInfo(faculty: faculty)
            }
        }
    }
}
