//
//  NewsAdvancedModeOptionTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 02.03.2025.
//

import UIKit

class NewsAdvancedModeOptionTableViewCell: UITableViewCell {

    static let identifier = "NewsAdvancedModeOptionTableViewCell"
    
    var userDefaults = UserDefaults.standard
    let animation = AnimationClass()
    
    @IBOutlet weak var Switch: UISwitch!
    @IBOutlet weak var OptionIcon: UIImageView!
    @IBOutlet weak var TitleLabel: UILabel!
    
    @IBAction func switchAction(_ sender: UISwitch) {
        
        userDefaults.set(sender.isOn, forKey: "onAdvancedModeNews")
        
        if Switch.isOn == true {
            print("on")
            OptionIcon.tintColor = .label
            TitleLabel.textColor = .label
            userDefaults.set(true, forKey: "onAdvancedModeNews")
            animation.springAnimation(view: OptionIcon)
        } else if Switch.isOn == false {
            print("off")
            OptionIcon.tintColor = .systemGray
            TitleLabel.textColor = .systemGray
            userDefaults.set(false, forKey: "onAdvancedModeNews")
        }
        
        NotificationCenter.default.post(name: Notification.Name("news advanced mode"), object: nil)
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
        let onAdvancedMode = userDefaults.object(forKey: "onAdvancedModeNews") as? Bool ?? false
        Switch.isOn = onAdvancedMode
        OptionIcon.tintColor = onAdvancedMode == true ? .label : .systemGray
        TitleLabel.textColor = onAdvancedMode == true ? .label : .systemGray
    }
}
