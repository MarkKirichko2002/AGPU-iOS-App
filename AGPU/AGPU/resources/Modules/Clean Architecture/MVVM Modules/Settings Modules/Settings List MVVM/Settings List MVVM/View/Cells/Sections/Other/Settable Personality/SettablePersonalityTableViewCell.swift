//
//  SettablePersonalityTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 12.07.2024.
//

import UIKit

final class SettablePersonalityTableViewCell: UITableViewCell {
    
    static let identifier = "SettablePersonalityTableViewCell"
    private let animation = AnimationClass()
    
    @IBOutlet var OptionIcon: SpringImageView!
    @IBOutlet var TitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        OptionIcon.tintColor = .label
        TitleLabel.textColor = .label
    }
    
    func didTapCell(indexPath: IndexPath, completion: @escaping()->Void) {
        animation.flipAnimation(view: self, option: .transitionFlipFromLeft) {
            completion()
            HapticsManager.shared.hapticFeedback()
        }
    }
}
