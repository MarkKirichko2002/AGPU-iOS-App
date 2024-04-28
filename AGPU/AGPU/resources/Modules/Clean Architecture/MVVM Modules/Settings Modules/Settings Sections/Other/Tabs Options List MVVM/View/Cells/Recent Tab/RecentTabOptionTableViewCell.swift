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
            userDefaults.set(true, forKey: "onRecentTab")
            animation.springAnimation(view: OptionIcon)
        } else if Switch.isOn == false {
            print("off")
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
        Switch.isOn = userDefaults.object(forKey: "onRecentTab") as? Bool ?? true
    }
}
