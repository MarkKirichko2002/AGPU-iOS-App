//
//  AROptionTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 24.08.2024.
//

import UIKit

class AROptionTableViewCell: UITableViewCell {

    static let identifier = "AROptionTableViewCell"
    
    var userDefaults = UserDefaults.standard
    var animation = AnimationClass()
    
    @IBOutlet weak var Switch: UISwitch!
    @IBOutlet weak var ARIcon: SpringImageView!
    @IBOutlet weak var OptionLabel: UILabel!
    
    @IBAction func switchAction(_ sender: UISwitch) {
        
        userDefaults.set(sender.isOn, forKey: "onVoiceCommands")
        
        if Switch.isOn == true {
            print("on")
            ARIcon.tintColor = .label
            OptionLabel.textColor = .label
            userDefaults.set(true, forKey: "onVoiceCommands")
            animation.springAnimation(view: ARIcon)
        } else if Switch.isOn == false {
            print("off")
            ARIcon.tintColor = .systemGray
            OptionLabel.textColor = .systemGray
            userDefaults.set(false, forKey: "onVoiceCommands")
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    private func setUpView() {
        ARIcon.tintColor = .label
        backgroundColor = .systemBackground
        OptionLabel.textColor = .label
        setUpState()
    }
    
    private func setUpState() {
        let isVoiceCommands = userDefaults.object(forKey: "onVoiceCommands") as? Bool ?? false
        Switch.isOn = isVoiceCommands
        ARIcon.tintColor = isVoiceCommands == true ? .label : .systemGray
        OptionLabel.textColor = isVoiceCommands == true ? .label : .systemGray
    }
}
