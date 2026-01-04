//
//  MapsOptionTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 02.01.2026.
//

import UIKit

final class MapsOptionTableViewCell: UITableViewCell {

    static let identifier = "MapsOptionTableViewCell"
    private let animation = AnimationClass()
    
    @IBOutlet var MapsOptionIcon: SpringImageView!
    @IBOutlet var TitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        MapsOptionIcon.tintColor = .label
        TitleLabel.tintColor = .label
    }
    
    func didTapCell(indexPath: IndexPath, completion: @escaping()->Void) {
        animation.flipAnimation(view: self, option: .transitionFlipFromLeft) {
            completion()
            HapticsManager.shared.hapticFeedback()
        }
    }
}
