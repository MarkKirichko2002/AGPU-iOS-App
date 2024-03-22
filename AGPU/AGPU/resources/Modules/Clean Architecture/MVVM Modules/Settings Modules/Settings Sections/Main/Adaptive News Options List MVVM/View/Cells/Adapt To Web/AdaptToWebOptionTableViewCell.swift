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
            userDefaults.set(true, forKey: "onAdaptToWeb")
            animation.springAnimation(view: OptionIcon)
        } else if Switch.isOn == false {
            print("off")
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
        Switch.isOn = userDefaults.object(forKey: "onAdaptToWeb") as? Bool ?? true
    }
}
