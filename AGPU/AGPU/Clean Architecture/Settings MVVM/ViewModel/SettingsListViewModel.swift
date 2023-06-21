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
    
    func ToggleMusic(index: Int, isChecked: Bool) {
        MusicList.musicArray[index].isChecked = isChecked
        do {
            let data = try JSONEncoder().encode(MusicList.musicArray[index])
            UserDefaults.standard.setValue(data, forKey: "music")
            isChanged = true
            NotificationCenter.default.post(name: Notification.Name("music"), object: MusicList.musicArray[index])
        } catch {
            print(error)
        }
    }
    
    func sectionsCount()->Int {
        return 1
    }
    
    func titleForSection(_ section: Int)-> String {
        switch section {
            
        case 0:
            return "Релакс Режим"
            
        default:
            return ""
        }
    }
    
    func musicListCount()-> Int {
        return MusicList.musicArray.count
    }
    
    func musicItem(index: Int)-> MusicModel {
        return MusicList.musicArray[index]
    }
    
    func isMusicSelected(index: Int)->UITableViewCell.AccessoryType {
        let data = UserDefaults.loadData()
        if data?.id == MusicList.musicArray[index].id && data?.isChecked == true {
            return .checkmark
        } else {
            return .none
        }
    }
}
