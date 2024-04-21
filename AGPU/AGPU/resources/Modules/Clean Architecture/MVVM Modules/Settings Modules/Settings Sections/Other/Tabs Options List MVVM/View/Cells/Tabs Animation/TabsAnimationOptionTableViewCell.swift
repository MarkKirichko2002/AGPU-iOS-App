//
//  TabsAnimationOptionTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 15.04.2024.
//

import UIKit

class TabsAnimationOptionTableViewCell: UITableViewCell {
    
    static let identifier = "TabsAnimationOptionTableViewCell"
    
    var userDefaults = UserDefaults.standard
    let animation = AnimationClass()
    
    @IBOutlet weak var Switch: UISwitch!
    @IBOutlet weak var OptionIcon: UIImageView!
    @IBOutlet weak var TitleLabel: UILabel!
    
    @IBAction func switchAction(_ sender: UISwitch) {
        
        userDefaults.set(sender.isOn, forKey: "onTabsAnimation")
        
        if Switch.isOn == true {
            print("on")
            userDefaults.set(true, forKey: "onTabsAnimation")
            animation.springAnimation(view: OptionIcon)
        } else if Switch.isOn == false {
            print("off")
            userDefaults.set(false, forKey: "onTabsAnimation")
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
        Switch.isOn = userDefaults.object(forKey: "onTabsAnimation") as? Bool ?? true
    }
}