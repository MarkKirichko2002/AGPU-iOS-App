//
//  DifferentWayOptionTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 05.12.2025.
//

import UIKit

final class DifferentWayOptionTableViewCell: UITableViewCell {

    static let identifier = "DifferentWayOptionTableViewCell"
    
    var userDefaults = UserDefaults.standard
    private let animation = AnimationClass()
    
    @IBOutlet weak var optionIcon: UIImageView!
    @IBOutlet weak var optionTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    private func setUpView() {
        optionIcon.tintColor = .label
        optionTitle.textColor = .label
    }
    
    func didTapCell(indexPath: IndexPath, completion: @escaping()->Void) {
        animation.flipAnimation(view: self, option: .transitionFlipFromLeft) {
            completion()
            HapticsManager.shared.hapticFeedback()
        }
    }
}
