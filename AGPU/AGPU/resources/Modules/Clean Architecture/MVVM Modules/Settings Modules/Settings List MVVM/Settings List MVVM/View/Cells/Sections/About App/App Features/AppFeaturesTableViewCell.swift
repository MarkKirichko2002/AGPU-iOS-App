//
//  AppFeaturesTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 26.07.2023.
//

import UIKit

class AppFeaturesTableViewCell: UITableViewCell {

    static let identifier = "AppFeaturesTableViewCell"
    private let animation = AnimationClass()
    
    @IBOutlet var InfoIcon: SpringImageView!
    @IBOutlet var TitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        InfoIcon.tintColor = .label
        TitleLabel.text = "Фишки приложения (всего: \(AppFeaturesList.features.count))"
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
