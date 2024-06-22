//
//  YourStatusOptionTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 12.10.2023.
//

import UIKit

class YourStatusOptionTableViewCell: UITableViewCell {

    static let identifier = "YourStatusOptionTableViewCell"
    private let animation = AnimationClass()
    
    @IBOutlet var YourStatusIcon: SpringImageView!
    @IBOutlet var TitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        YourStatusIcon.tintColor = .label
        TitleLabel.tintColor = .label
    }
    
    func configure(status: UserStatusModel) {
        YourStatusIcon.image = UIImage(named: status.icon)
        TitleLabel.text = "Ваш статус (\(status.name))"
    }
    
    func didTapCell(indexPath: IndexPath) {
        animation.flipAnimation(view: self, option: .transitionFlipFromLeft) {
            HapticsManager.shared.hapticFeedback()
        }
    }
}
