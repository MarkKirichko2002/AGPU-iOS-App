//
//  ASPUButtonOptionTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 04.02.2024.
//

import UIKit

class ASPUButtonOptionTableViewCell: UITableViewCell {

    static let identifier = "ASPUButtonOptionTableViewCell"
    private let animation = AnimationClass()
    
    @IBOutlet var OptionIcon: SpringImageView!
    @IBOutlet var TitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        OptionIcon.tintColor = .label
        TitleLabel.textColor = .label
    }
    
    func configure(action: ASPUButtonActions) {
        TitleLabel.text = action.rawValue
    }
    
    func didTapCell(indexPath: IndexPath) {
        animation.flipAnimation(view: self, option: .transitionFlipFromLeft) {
            HapticsManager.shared.hapticFeedback()
        }
    }
}
