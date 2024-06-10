//
//  ActionToRecallOptionTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 23.07.2023.
//

import UIKit

// MARK: - ActionToRecallOptionTableViewCellDelegate
protocol ActionToRecallOptionTableViewCellDelegate: AnyObject {
    func iconWasTapped()
}

final class ActionToRecallOptionTableViewCell: UITableViewCell {

    static let identifier = "ActionToRecallOptionTableViewCell"
    
    var userDefaults = UserDefaults.standard
    var animation = AnimationClass()
    
    weak var delegate: ActionToRecallOptionTableViewCellDelegate?
    
    @IBOutlet weak var Switch: UISwitch!
    @IBOutlet weak var ActionToRecallIcon: SpringImageView!
    @IBOutlet weak var ActionToRecallLabel: UILabel!
    
    @IBAction func switchAction(_ sender: UISwitch) {
        
        userDefaults.set(sender.isOn, forKey: "onShakeToRecall")
        
        if Switch.isOn == true {
            print("on")
            ActionToRecallIcon.tintColor = .label
            ActionToRecallLabel.textColor = .label
            userDefaults.set(true, forKey: "onShakeToRecall")
            animation.springAnimation(view: ActionToRecallIcon)
        } else if Switch.isOn == false {
            print("off")
            ActionToRecallIcon.tintColor = .systemGray
            ActionToRecallLabel.textColor = .systemGray
            userDefaults.set(false, forKey: "onShakeToRecall")
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    private func setUpView() {
        ActionToRecallIcon.tintColor = .label
        ActionToRecallIcon.delegate = self
        backgroundColor = .systemBackground
        ActionToRecallLabel.textColor = .label
        setUpState()
    }
    
    private func setUpState() {
        let isShakeToRecall = userDefaults.object(forKey: "onShakeToRecall") as? Bool ?? true
        Switch.isOn = isShakeToRecall
        ActionToRecallIcon.tintColor = isShakeToRecall == true ? .label : .systemGray
        ActionToRecallLabel.textColor = isShakeToRecall == true ? .label : .systemGray
    }
}

// MARK: - SpringImageViewDelegate
extension ActionToRecallOptionTableViewCell: SpringImageViewDelegate {
    
    func imageWasTapped() {
        delegate?.iconWasTapped()
    }
}
