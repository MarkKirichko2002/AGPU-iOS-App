//
//  AppIconTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 10.10.2023.
//

import UIKit

class AppIconTableViewCell: UITableViewCell {

    static let identifier = "AppIconTableViewCell"
    private let animation = AnimationClass()
    
    @IBOutlet var AppIcon: SpringImageView!
    @IBOutlet var AppIconName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        AppIcon.tintColor = .label
        AppIconName.tintColor = .label
    }
    
    func configure(icon: String) {
        AppIconName.text = "Текущая иконка (\(icon))"
    }
    
    func didTapCell(indexPath: IndexPath) {
        animation.flipAnimation(view: self, option: .transitionFlipFromLeft) {
            HapticsManager.shared.hapticFeedback()
        }
    }
}
