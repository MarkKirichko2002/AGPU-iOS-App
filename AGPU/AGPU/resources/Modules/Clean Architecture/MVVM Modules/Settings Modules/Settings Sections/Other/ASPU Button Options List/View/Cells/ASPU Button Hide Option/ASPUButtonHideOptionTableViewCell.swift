//
//  ASPUButtonHideOptionTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 10.12.2024.
//

import UIKit

final class ASPUButtonHideOptionTableViewCell: UITableViewCell {

    static let identifier = "ASPUButtonHideOptionTableViewCell"
    
    var userDefaults = UserDefaults.standard
    let animation = AnimationClass()
    
    @IBOutlet weak var Switch: UISwitch!
    @IBOutlet weak var OptionIcon: UIImageView!
    @IBOutlet weak var TitleLabel: UILabel!
    
    @IBAction func switchAction(_ sender: UISwitch) {
        
        userDefaults.set(sender.isOn, forKey: "isButtonShown")
        
        if Switch.isOn == true {
            print("on")
            OptionIcon.tintColor = .label
            TitleLabel.textColor = .label
            animation.springAnimation(view: OptionIcon)
        } else if Switch.isOn == false {
            print("off")
            OptionIcon.tintColor = .systemGray
            TitleLabel.textColor = .systemGray
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
        let isTabsAnimation = userDefaults.object(forKey: "isButtonShown") as? Bool ?? true
        Switch.isOn = isTabsAnimation
        OptionIcon.tintColor = isTabsAnimation == true ? .label : .systemGray
        TitleLabel.textColor = isTabsAnimation == true ? .label : .systemGray
    }
}
