//
//  ShakeToRecallOptionTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 23.07.2023.
//

import UIKit

final class ShakeToRecallOptionTableViewCell: UITableViewCell {

    static let identifier = "ShakeToRecallOptionTableViewCell"
    
    var userDefaults = UserDefaults.standard
    var animation = AnimationClass()
    
    @IBOutlet weak var Switch: UISwitch!
    @IBOutlet weak var ShakeToRecallIcon: UIImageView!
    @IBOutlet weak var ShakeToRecallLabel: UILabel!
    
    @IBAction func switchAction(_ sender: UISwitch) {
        
        userDefaults.set(sender.isOn, forKey: "onShakeToRecall")
        
        if Switch.isOn == true {
            print("on")
            ShakeToRecallIcon.tintColor = .label
            ShakeToRecallLabel.textColor = .label
            userDefaults.set(true, forKey: "onShakeToRecall")
            animation.springAnimation(view: ShakeToRecallIcon)
        } else if Switch.isOn == false {
            print("off")
            ShakeToRecallIcon.tintColor = .systemGray
            ShakeToRecallLabel.textColor = .systemGray
            userDefaults.set(false, forKey: "onShakeToRecall")
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    private func setUpView() {
        ShakeToRecallIcon.tintColor = .label
        backgroundColor = .systemBackground
        ShakeToRecallLabel.textColor = .label
        setUpState()
    }
    
    private func setUpState() {
        let isShakeToRecall = userDefaults.object(forKey: "onShakeToRecall") as? Bool ?? true
        Switch.isOn = isShakeToRecall
        ShakeToRecallIcon.tintColor = isShakeToRecall == true ? .label : .systemGray
        ShakeToRecallLabel.textColor = isShakeToRecall == true ? .label : .systemGray
    }
}
