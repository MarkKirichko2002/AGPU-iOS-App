//
//  BorderForDailyNewsTableViewCell.swift
//  AGPU
//
//  Created by Марк Киричко on 20.04.2024.
//

import UIKit

class BorderForDailyNewsTableViewCell: UITableViewCell {

    static let identifier = "BorderForDailyNewsTableViewCell"
    
    var userDefaults = UserDefaults.standard
    let animation = AnimationClass()
    
    @IBOutlet weak var Switch: UISwitch!
    @IBOutlet weak var OptionIcon: UIImageView!
    @IBOutlet weak var TitleLabel: UILabel!
    
    @IBAction func switchAction(_ sender: UISwitch) {
        
        userDefaults.set(sender.isOn, forKey: "onBorderForDailyNews")
        
        if Switch.isOn == true {
            print("on")
            OptionIcon.tintColor = .label
            TitleLabel.textColor = .label
            userDefaults.set(true, forKey: "onBorderForDailyNews")
            animation.springAnimation(view: OptionIcon)
            saveOption(option: .today)
        } else if Switch.isOn == false {
            print("off")
            OptionIcon.tintColor = .systemGray
            TitleLabel.textColor = .systemGray
            userDefaults.set(false, forKey: "onBorderForDailyNews")
            saveOption(option: .all)
        }
    }
    
    private func saveOption(option: NewsOptionsFilters) {
        UserDefaults.saveData(object: option, key: "news filter") {
            NotificationCenter.default.post(name: Notification.Name("daily news border option"), object: option)
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
        setUpState()
    }
    
    private func setUpState() {
        let isBorderForDailyNews = userDefaults.object(forKey: "onBorderForDailyNews") as? Bool ?? true
        Switch.isOn = isBorderForDailyNews
        OptionIcon.tintColor = isBorderForDailyNews == true ? .label : .systemGray
        TitleLabel.textColor = isBorderForDailyNews == true ? .label : .systemGray
    }
}
