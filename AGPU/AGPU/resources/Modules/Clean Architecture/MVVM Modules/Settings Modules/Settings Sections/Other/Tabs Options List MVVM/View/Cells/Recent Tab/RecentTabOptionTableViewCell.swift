//
//  RecentTabOptionTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 28.04.2024.
//

import UIKit

class RecentTabOptionTableViewCell: UITableViewCell {

    static let identifier = "RecentTabOptionTableViewCell"
    
    var userDefaults = UserDefaults.standard
    let animation = AnimationClass()
    
    @IBOutlet weak var Switch: UISwitch!
    @IBOutlet weak var OptionIcon: UIImageView!
    @IBOutlet weak var TitleLabel: UILabel!
    
    @IBAction func switchAction(_ sender: UISwitch) {
        
        userDefaults.set(sender.isOn, forKey: "onRecentTab")
        
        if Switch.isOn == true {
            print("on")
            OptionIcon.tintColor = .label
            TitleLabel.textColor = .label
            userDefaults.set(true, forKey: "onRecentTab")
            animation.springAnimation(view: OptionIcon)
        } else if Switch.isOn == false {
            print("off")
            OptionIcon.tintColor = .systemGray
            TitleLabel.textColor = .systemGray
            userDefaults.setValue(0, forKey: "index")
            userDefaults.set(false, forKey: "onRecentTab")
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
        let isRecentTab = userDefaults.object(forKey: "onRecentTab") as? Bool ?? true
        Switch.isOn = isRecentTab
        OptionIcon.tintColor = isRecentTab == true ? .label : .systemGray
        TitleLabel.textColor = isRecentTab == true ? .label : .systemGray
    }
}
