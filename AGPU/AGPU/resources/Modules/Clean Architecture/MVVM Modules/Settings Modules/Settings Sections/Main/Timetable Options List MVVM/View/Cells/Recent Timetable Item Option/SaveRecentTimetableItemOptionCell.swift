//
//  SaveRecentTimetableItemOptionCell.swift
//  AGPU
//
//  Created by Марк Киричко on 24.01.2024.
//

import UIKit

class SaveRecentTimetableItemOptionCell: UITableViewCell {

    static let identifier = "SaveRecentTimetableItemOptionCell"
    
    var userDefaults = UserDefaults.standard
    let animation = AnimationClass()
    
    @IBOutlet weak var Switch: UISwitch!
    @IBOutlet weak var OptionIcon: UIImageView!
    @IBOutlet weak var TitleLabel: UILabel!
    
    @IBAction func switchAction(_ sender: UISwitch) {
        
        userDefaults.set(sender.isOn, forKey: "onSaveRecentTimetableItem")
        
        if Switch.isOn == true {
            print("on")
            OptionIcon.tintColor = .label
            TitleLabel.textColor = .label
            userDefaults.set(true, forKey: "onSaveRecentTimetableItem")
            animation.springAnimation(view: OptionIcon)
        } else if Switch.isOn == false {
            print("off")
            OptionIcon.tintColor = .systemGray
            TitleLabel.textColor = .systemGray
            userDefaults.set(false, forKey: "onSaveRecentTimetableItem")
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
        let isSaveRecentTimetableItem = userDefaults.object(forKey: "onSaveRecentTimetableItem") as? Bool ?? true
        Switch.isOn = isSaveRecentTimetableItem
        OptionIcon.tintColor = isSaveRecentTimetableItem == true ? .label : .systemGray
        TitleLabel.textColor = isSaveRecentTimetableItem == true ? .label : .systemGray
    }
}
