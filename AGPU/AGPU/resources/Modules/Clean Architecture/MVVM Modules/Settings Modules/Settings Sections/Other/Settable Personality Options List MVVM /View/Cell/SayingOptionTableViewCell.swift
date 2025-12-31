//
//  SayingOptionTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 07.08.2024.
//

import UIKit

final class SayingOptionTableViewCell: UITableViewCell {

    static let identifier = "SayingOptionTableViewCell"
    
    var userDefaults = UserDefaults.standard
    var animation = AnimationClass()
    
    @IBOutlet weak var Switch: UISwitch!
    @IBOutlet weak var SayingOptionIcon: SpringImageView!
    @IBOutlet weak var SayingOptionLabel: UILabel!
    
    @IBAction func switchAction(_ sender: UISwitch) {
        
        userDefaults.set(sender.isOn, forKey: "isSaying")
        
        if Switch.isOn == true {
            print("on")
            SayingOptionIcon.tintColor = .label
            SayingOptionLabel.textColor = .label
            userDefaults.set(true, forKey: "isSaying")
            animation.springAnimation(view: SayingOptionIcon)
        } else if Switch.isOn == false {
            print("off")
            SayingOptionIcon.tintColor = .systemGray
            SayingOptionLabel.textColor = .systemGray
            userDefaults.set(false, forKey: "isSaying")
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    private func setUpView() {
        SayingOptionIcon.tintColor = .label
        backgroundColor = .systemBackground
        SayingOptionLabel.textColor = .label
        setUpState()
    }
    
    private func setUpState() {
        let isShakeToRecall = userDefaults.object(forKey: "isSaying") as? Bool ?? false
        Switch.isOn = isShakeToRecall
        SayingOptionIcon.tintColor = isShakeToRecall == true ? .label : .systemGray
        SayingOptionLabel.textColor = isShakeToRecall == true ? .label : .systemGray
    }
}
