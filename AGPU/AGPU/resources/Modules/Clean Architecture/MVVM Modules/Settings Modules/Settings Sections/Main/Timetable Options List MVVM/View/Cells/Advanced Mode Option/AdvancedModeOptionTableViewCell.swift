//
//  AdvancedModeOptionTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 23.08.2024.
//

import UIKit

class AdvancedModeOptionTableViewCell: UITableViewCell {

    static let identifier = "AdvancedModeOptionTableViewCell"
    
    var userDefaults = UserDefaults.standard
    let animation = AnimationClass()
    
    @IBOutlet weak var Switch: UISwitch!
    @IBOutlet weak var OptionIcon: UIImageView!
    @IBOutlet weak var TitleLabel: UILabel!
    
    @IBAction func switchAction(_ sender: UISwitch) {
        
        userDefaults.set(sender.isOn, forKey: "onAdvancedMode")
        
        if Switch.isOn == true {
            print("on")
            OptionIcon.tintColor = .label
            TitleLabel.textColor = .label
            userDefaults.set(true, forKey: "onAdvancedMode")
            animation.springAnimation(view: OptionIcon)
        } else if Switch.isOn == false {
            print("off")
            OptionIcon.tintColor = .systemGray
            TitleLabel.textColor = .systemGray
            userDefaults.set(false, forKey: "onAdvancedMode")
        }
        
        NotificationCenter.default.post(name: Notification.Name("advanced mode"), object: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    private func setUpView() {
        OptionIcon.tintColor = .label
        backgroundColor = .systemBackground
        TitleLabel.textColor = .label
        setUpState()
    }
    
    private func setUpState() {
        let onAdvancedMode = userDefaults.object(forKey: "onAdvancedMode") as? Bool ?? false
        Switch.isOn = onAdvancedMode
        OptionIcon.tintColor = onAdvancedMode == true ? .label : .systemGray
        TitleLabel.textColor = onAdvancedMode == true ? .label : .systemGray
    }
}
