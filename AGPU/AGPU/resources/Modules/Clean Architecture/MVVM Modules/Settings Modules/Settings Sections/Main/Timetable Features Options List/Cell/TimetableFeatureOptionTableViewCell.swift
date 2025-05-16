//
//  TimetableFeatureOptionTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 27.10.2024.
//

import UIKit

class TimetableFeatureOptionTableViewCell: UITableViewCell {

    static let identifier = "TimetableFeatureOptionTableViewCell"
    private let animation = AnimationClass()
    
    @IBOutlet var TimetableOptionIcon: SpringImageView!
    @IBOutlet var TitleLabel: UILabel!
    
    func configure(feature: TimetableFeatureModel) {
        TimetableOptionIcon.image = UIImage(named: feature.icon)
        TitleLabel.text = feature.name
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        TimetableOptionIcon.tintColor = .label
        TitleLabel.tintColor = .label
    }
    
    func didTapCell(indexPath: IndexPath, completion: @escaping()->Void) {
        animation.flipAnimation(view: self, option: .transitionFlipFromLeft) {
            completion()
            HapticsManager.shared.hapticFeedback()
        }
    }
}
