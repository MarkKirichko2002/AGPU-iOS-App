//
//  CustomTabBarOptionTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 24.03.2024.
//

import UIKit

final class CustomTabBarOptionTableViewCell: UITableViewCell {

    static let identifier = "CustomTabBarOptionTableViewCell"
    private let animation = AnimationClass()
    
    @IBOutlet var OptionIcon: SpringImageView!
    @IBOutlet var OptionName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        OptionIcon.tintColor = .label
        OptionName.tintColor = .label
    }
    
    func didTapCell(indexPath: IndexPath, completion: @escaping()->Void) {
        animation.flipAnimation(view: self, option: .transitionFlipFromLeft) {
            completion()
            HapticsManager.shared.hapticFeedback()
        }
    }
}
