//
//  VolumeControlOptionTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 27.04.2025.
//

import UIKit

final class VolumeControlOptionTableViewCell: UITableViewCell {

    static let identifier = "VolumeControlOptionTableViewCell"
    
    var userDefaults = UserDefaults.standard
    let animation = AnimationClass()
    
    @IBOutlet weak var Switch: UISwitch!
    @IBOutlet weak var OptionIcon: UIImageView!
    @IBOutlet weak var TitleLabel: UILabel!
    
    @IBAction func switchAction(_ sender: UISwitch) {
        
        userDefaults.set(sender.isOn, forKey: "onVolumeContol timetable")
        
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
        let onFloatingButton = userDefaults.object(forKey: "onVolumeContol timetable") as? Bool ?? false
        Switch.isOn = onFloatingButton
        OptionIcon.tintColor = onFloatingButton == true ? .label : .systemGray
        TitleLabel.textColor = onFloatingButton == true ? .label : .systemGray
    }
}
