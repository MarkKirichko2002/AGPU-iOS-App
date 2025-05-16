//
//  ShortcutOptionTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 06.12.2024.
//

import UIKit

class ShortcutOptionTableViewCell: UITableViewCell {

    static let identifier = "ShortcutOptionTableViewCell"
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
