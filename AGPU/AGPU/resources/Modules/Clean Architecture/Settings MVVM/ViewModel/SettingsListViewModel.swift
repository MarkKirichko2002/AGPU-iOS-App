//
//  SettingsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 21.06.2023.
//

import UIKit

class SettingsListViewModel: NSObject {
    
    @objc dynamic var isChanged = false
    
    var observation: NSKeyValueObservation?
    
    func sectionsCount()-> Int {
        return 2
    }
    
    func numberOfRowsInSection(section: Int)-> Int {
        switch section {
        case 0:
            return musicListCount()
        case 1:
            return iconsListCount()
        default:
            return 0
        }
    }
    
    func cellForRowAt(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.accessoryType = isMusicSelected(index: indexPath.row)
            cell.tintColor = .systemGreen
            cell.textLabel?.text = "\(musicItem(index: indexPath.row).id)) \(musicItem(index: indexPath.row).name)"
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomIconTableViewCell.identifier, for: indexPath) as? CustomIconTableViewCell else {return UITableViewCell()}
            cell.accessoryType = isIconSelected(index: indexPath.row)
            cell.tintColor = .systemGreen
            cell.configure(icon: customIconItem(index: indexPath.row))
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func DidSelectRow(at indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            print("музыка")
        case 1:
            ChangeIcon(index: indexPath.row)
        default:
            break
        }
    }
    
    func titleForSection(_ section: Int)-> String {
        switch section {
            
        case 0:
            return "Релакс Режим"
         
        case 1:
            return "Избранный Факультет"
            
        default:
            return ""
        }
    }
    
    // MARK: - Relax Mode
    
    func musicListCount()-> Int {
        return MusicList.musicArray.count
    }
    
    func musicItem(index: Int)-> MusicModel {
        return MusicList.musicArray[index]
    }
    
    func ToggleMusic(index: Int, isChecked: Bool) {
        MusicList.musicArray[index].isChecked = isChecked
        UserDefaults.SaveData(object: MusicList.musicArray[index], key: "music") {
            self.isChanged = true
            if MusicList.musicArray[index].isChecked {
                AudioPlayer.shared.PlaySound(resource: MusicList.musicArray[index].fileName)
            } else {
                AudioPlayer.shared.StopSound(resource: MusicList.musicArray[index].fileName)
            }
        }
    }
    
    func isMusicSelected(index: Int)-> UITableViewCell.AccessoryType {
        let data = UserDefaults.loadData(type: MusicModel.self, key: "music")
        if data?.id == MusicList.musicArray[index].id && data?.isChecked == true {
            return .checkmark
        } else {
            return .none
        }
    }
    
    // MARK: - Elected Faculty
    
    func iconsListCount()-> Int {
        return AlternateIcons.icons.count
    }
    
    func customIconItem(index: Int)-> AlternateIconModel {
        return AlternateIcons.icons[index]
    }
    
    func ChangeIcon(index: Int) {
        var icon = AlternateIcons.icons[index]
        icon.isSelected = true
        UIApplication.shared.setAlternateIconName(icon.appIcon)
        NotificationCenter.default.post(name: Notification.Name("icon"), object: icon)
        UserDefaults.SaveData(object: icon, key: "icon") {
            self.isChanged = true
        }
    }
    
    func isIconSelected(index: Int)-> UITableViewCell.AccessoryType {
        let data = UserDefaults.loadData(type: AlternateIconModel.self, key: "icon")
        if data?.id == AlternateIcons.icons[index].id && data?.isSelected == true {
            return .checkmark
        } else {
            return .none
        }
    }
}
