//
//  ShowInfoDateOptionTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 21.01.2025.
//

import UIKit

final class ShowInfoDateOptionTableViewCell: UITableViewCell {

    static let identifier = "ShowInfoDateOptionTableViewCell"
    
    var userDefaults = UserDefaults.standard
    var animation = AnimationClass()
    
    @IBOutlet weak var Switch: UISwitch!
    @IBOutlet weak var OptionIcon: SpringImageView!
    @IBOutlet weak var OptionTitle: UILabel!
    
    @IBAction func switchAction(_ sender: UISwitch) {
        
        userDefaults.set(sender.isOn, forKey: "onShowDateInfo")
        
        if Switch.isOn == true {
            print("on")
            OptionIcon.tintColor = .label
            OptionTitle.textColor = .label
            userDefaults.set(true, forKey: "onShowDateInfo")
            animation.springAnimation(view: OptionIcon)
        } else if Switch.isOn == false {
            print("off")
            OptionIcon.tintColor = .systemGray
            OptionTitle.textColor = .systemGray
            userDefaults.set(false, forKey: "onShowDateInfo")
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    private func setUpView() {
        OptionIcon.tintColor = .label
        backgroundColor = .systemBackground
        OptionTitle.textColor = .label
        setUpState()
    }
    
    private func setUpState() {
        let isOnShowDateInfo = userDefaults.object(forKey: "onShowDateInfo") as? Bool ?? true
        Switch.isOn = isOnShowDateInfo
        OptionIcon.tintColor = isOnShowDateInfo == true ? .label : .systemGray
        OptionTitle.textColor = isOnShowDateInfo == true ? .label : .systemGray
    }
}
