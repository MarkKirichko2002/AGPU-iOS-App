//
//  VisualChangesOptionTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 26.05.2024.
//

import UIKit

final class VisualChangesOptionTableViewCell: UITableViewCell {

    static let identifier = "VisualChangesOptionTableViewCell"
    
    var userDefaults = UserDefaults.standard
    private let animation = AnimationClass()
    
    @IBOutlet weak var VisualChangesIcon: UIImageView!
    @IBOutlet weak var VisualChangesLabel: UILabel!
    
    func configure(name: String) {
        VisualChangesLabel.text = "Отображение (\(name))"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    private func setUpView() {
        VisualChangesIcon.tintColor = .label
        VisualChangesLabel.textColor = .label
    }
    
    func didTapCell(indexPath: IndexPath) {
        animation.flipAnimation(view: self, option: .transitionFlipFromLeft) {
            HapticsManager.shared.hapticFeedback()
        }
    }
}
