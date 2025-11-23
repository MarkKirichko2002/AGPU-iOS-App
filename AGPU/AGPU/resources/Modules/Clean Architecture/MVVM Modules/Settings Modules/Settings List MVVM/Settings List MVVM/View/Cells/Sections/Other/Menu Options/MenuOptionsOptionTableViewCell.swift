//
//  MenuOptionsOptionTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 10.11.2025.
//

import UIKit

class MenuOptionsOptionTableViewCell: UITableViewCell {

    static let identifier = "MenuOptionsOptionTableViewCell"
    private let animation = AnimationClass()
    
    @IBOutlet var OptionImage: SpringImageView!
    @IBOutlet var OptionName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        OptionImage.tintColor = .label
        OptionName.textColor = .label
    }
    
    func didTapCell(indexPath: IndexPath, completion: @escaping()->Void) {
        animation.flipAnimation(view: self, option: .transitionFlipFromLeft) {
            completion()
            HapticsManager.shared.hapticFeedback()
        }
    }
}
