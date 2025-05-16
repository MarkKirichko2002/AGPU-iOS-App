//
//  GestureRecognitionOptionTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 15.03.2025.
//

import UIKit

final class GestureRecognitionOptionTableViewCell: UITableViewCell {

    static let identifier = "GestureRecognitionOptionTableViewCell"
    
    var userDefaults = UserDefaults.standard
    let animation = AnimationClass()
    
    @IBOutlet weak var Switch: UISwitch!
    @IBOutlet weak var OptionIcon: UIImageView!
    @IBOutlet weak var TitleLabel: UILabel!
    
    @IBAction func switchAction(_ sender: UISwitch) {
        
        userDefaults.set(sender.isOn, forKey: "onGestureButton timetable")
        
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
        
        NotificationCenter.default.post(name: Notification.Name("gesture button timetable"), object: nil)
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
        let onFloatingButton = userDefaults.object(forKey: "onGestureButton timetable") as? Bool ?? false
        Switch.isOn = onFloatingButton
        OptionIcon.tintColor = onFloatingButton == true ? .label : .systemGray
        TitleLabel.textColor = onFloatingButton == true ? .label : .systemGray
    }
}
