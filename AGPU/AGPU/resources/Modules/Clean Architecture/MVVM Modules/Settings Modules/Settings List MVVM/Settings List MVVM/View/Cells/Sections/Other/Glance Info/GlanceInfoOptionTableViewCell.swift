//
//  GlanceInfoOptionTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 26.05.2024.
//

import UIKit

final class GlanceInfoOptionTableViewCell: UITableViewCell {

    static let identifier = "GlanceInfoOptionTableViewCell"
    
    var userDefaults = UserDefaults.standard
    private let animation = AnimationClass()
    
    @IBOutlet weak var GlanceInfoIcon: UIImageView!
    @IBOutlet weak var GlanceInfoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    private func setUpView() {
        GlanceInfoIcon.tintColor = .label
        GlanceInfoLabel.textColor = .label
    }
    
    func didTapCell(indexPath: IndexPath, completion: @escaping()->Void) {
        animation.flipAnimation(view: self, option: .transitionFlipFromLeft) {
            completion()
            HapticsManager.shared.hapticFeedback()
        }
    }
}
