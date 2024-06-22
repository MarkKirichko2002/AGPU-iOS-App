//
//  AppThemesTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 22.09.2023.
//

import UIKit

class AppThemesTableViewCell: UITableViewCell {

    static let identifier = "AppThemesTableViewCell"
    private let animation = AnimationClass()
    
    @IBOutlet var ThemeIcon: SpringImageView!
    @IBOutlet var TitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ThemeIcon.tintColor = .label
        TitleLabel.textColor = .label
    }
    
    func configure(theme: AppThemeModel) {
        TitleLabel.text = "Текущая тема (\(theme.name))"
    }
    
    func didTapCell(indexPath: IndexPath) {
        animation.flipAnimation(view: self, option: .transitionFlipFromLeft) {
            HapticsManager.shared.hapticFeedback()
        }
    }
}
