//
//  SplashScreenOptionTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 04.01.2024.
//

import UIKit

class SplashScreenOptionTableViewCell: UITableViewCell {

    static let identifier = "SplashScreenOptionTableViewCell"
    private let animation = AnimationClass()
    
    @IBOutlet var SplashScreenIcon: SpringImageView!
    @IBOutlet var SplashScreenName: UILabel!
    
    func configure(name: String) {
        SplashScreenName.text = "Экран заставки (\(name))"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        SplashScreenIcon.tintColor = .label
        SplashScreenName.tintColor = .label
    }
    
    func didTapCell(indexPath: IndexPath) {
        animation.flipAnimation(view: self, option: .transitionFlipFromLeft) {
            HapticsManager.shared.hapticFeedback()
        }
    }
}
