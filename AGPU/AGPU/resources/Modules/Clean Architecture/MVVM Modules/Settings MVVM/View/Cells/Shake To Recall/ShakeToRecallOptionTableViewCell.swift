//
//  ShakeToRecallOptionTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 23.07.2023.
//

import UIKit

final class ShakeToRecallOptionTableViewCell: UITableViewCell {

    static let identifier = "ShakeToRecallOptionTableViewCell"
    
    var userDefaults = UserDefaults.standard
    var animation = AnimationClass()
    
    @IBOutlet weak var Switch: UISwitch!
    @IBOutlet weak var ShakeToRecallLabel: UILabel!
    @IBOutlet weak var ShakeToRecallIcon: UIImageView!
    
    @IBAction func switchAction(_ sender: UISwitch) {
        
        userDefaults.set(sender.isOn, forKey: "onShakeToRecall")
        userDefaults.set(sender.isOn, forKey: "offShakeToRecall")
        
        if Switch.isOn == true {
            print("on")
            userDefaults.set(true, forKey: "onShakeToRecallOption")
            animation.springAnimation(view: ShakeToRecallIcon)
        } else if Switch.isOn == false {
            print("off")
            userDefaults.set(false, forKey: "onShakeToRecallOption")
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        Switch.isOn = userDefaults.bool(forKey: "onShakeToRecall")
        Switch.isOn = userDefaults.bool(forKey: "offShakeToRecall")
    }
}
