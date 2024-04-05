//
//  ShowOnlyDailyNewsTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 05.04.2024.
//

import UIKit

class ShowOnlyDailyNewsTableViewCell: UITableViewCell {

    static let identifier = "ShowOnlyDailyNewsTableViewCell"
    
    var userDefaults = UserDefaults.standard
    let animation = AnimationClass()
    
    @IBOutlet weak var Switch: UISwitch!
    @IBOutlet weak var OptionIcon: UIImageView!
    @IBOutlet weak var TitleLabel: UILabel!
    
    @IBAction func switchAction(_ sender: UISwitch) {
        
        userDefaults.set(sender.isOn, forKey: "onShowOnlyDailyNews")
        
        if Switch.isOn == true {
            print("on")
            userDefaults.set(true, forKey: "onShowOnlyDailyNews")
            animation.springAnimation(view: OptionIcon)
            saveOption(option: .today)
        } else if Switch.isOn == false {
            print("off")
            userDefaults.set(false, forKey: "onShowOnlyDailyNews")
            saveOption(option: .all)
        }
    }
    
    private func saveOption(option: NewsOptionsFilters) {
        UserDefaults.saveData(object: option, key: "news filter") {
            NotificationCenter.default.post(name: Notification.Name("news filter option"), object: option)
            HapticsManager.shared.hapticFeedback()
            print("сохранено")
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
        Switch.isOn = userDefaults.object(forKey: "onShowOnlyDailyNews") as? Bool ?? false
    }
}
