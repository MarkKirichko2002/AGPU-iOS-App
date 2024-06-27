//
//  VoiceScrollTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 27.06.2024.
//

import UIKit

class VoiceScrollTableViewCell: UITableViewCell {

    static let identifier = "VoiceScrollTableViewCell"
    
    var userDefaults = UserDefaults.standard
    let animation = AnimationClass()
    
    @IBOutlet weak var Switch: UISwitch!
    @IBOutlet weak var OptionIcon: UIImageView!
    @IBOutlet weak var TitleLabel: UILabel!
    
    @IBAction func switchAction(_ sender: UISwitch) {
        
        userDefaults.set(sender.isOn, forKey: "onVoiceScrollTimetable")
        
        if Switch.isOn == true {
            print("on")
            OptionIcon.tintColor = .label
            TitleLabel.textColor = .label
            userDefaults.set(true, forKey: "onVoiceScrollTimetable")
            animation.springAnimation(view: OptionIcon)
        } else if Switch.isOn == false {
            print("off")
            OptionIcon.tintColor = .systemGray
            TitleLabel.textColor = .systemGray
            userDefaults.set(false, forKey: "onVoiceScrollTimetable")
        }
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
        let isVoiceScrollTimetable = userDefaults.object(forKey: "onVoiceScrollTimetable") as? Bool ?? false
        Switch.isOn = isVoiceScrollTimetable
        OptionIcon.tintColor = isVoiceScrollTimetable == true ? .label : .systemGray
        TitleLabel.textColor = isVoiceScrollTimetable == true ? .label : .systemGray
    }
}
