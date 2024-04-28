//
//  AdaptToWebOptionTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 22.03.2024.
//

import UIKit

class AdaptToWebOptionTableViewCell: UITableViewCell {

    static let identifier = "AdaptToWebOptionTableViewCell"
    
    var userDefaults = UserDefaults.standard
    let animation = AnimationClass()
    
    @IBOutlet weak var Switch: UISwitch!
    @IBOutlet weak var OptionIcon: UIImageView!
    @IBOutlet weak var TitleLabel: UILabel!
    
    @IBAction func switchAction(_ sender: UISwitch) {
        
        userDefaults.set(sender.isOn, forKey: "onAdaptToWeb")
        
        if Switch.isOn == true {
            print("on")
            OptionIcon.tintColor = .label
            TitleLabel.textColor = .label
            userDefaults.set(true, forKey: "onAdaptToWeb")
            animation.springAnimation(view: OptionIcon)
        } else if Switch.isOn == false {
            print("off")
            OptionIcon.tintColor = .systemGray
            TitleLabel.textColor = .systemGray
            userDefaults.set(false, forKey: "onAdaptToWeb")
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
        let isAdaptToWeb = userDefaults.object(forKey: "onAdaptToWeb") as? Bool ?? true
        Switch.isOn = isAdaptToWeb
        OptionIcon.tintColor = isAdaptToWeb == true ? .label : .systemGray
        TitleLabel.textColor = isAdaptToWeb == true ? .label : .systemGray
    }
}
