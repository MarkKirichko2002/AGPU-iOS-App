//
//  CustomMusicListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 12.07.2023.
//

import UIKit

class CustomMusicListViewModel: NSObject {
    
    @objc dynamic var isChanged = false
    var observation: NSKeyValueObservation?
    
    var musicList = [MusicModel]()
    
    private let realmManager = RealmManager()
    
    // MARK: - Init
    override init() {
        super.init()
        GetMusicList()
        NotificationCenter.default.addObserver(forName: Notification.Name("Music Added"), object: nil, queue: .main) { _ in
            self.GetMusicList()
        }
    }
    
    // MARK: - Custom Music
    
    func GetMusicList() {
        realmManager.fetchMusicList { musicList in
            self.musicList = musicList
            self.isChanged.toggle()
        }
    }
    
    func DeleteMusic(index: Int) {
        let id = UserDefaults.standard.object(forKey: "id") as? Int ?? 0
        if musicItem(index: index).id == musicItem(index: id).id {
            UserDefaults.standard.setValue(nil, forKey: "id")
            AudioPlayer.shared.StopSound()
        }
        realmManager.deleteMusic(music: musicItem(index: index))
        GetMusicList()
    }
    
    func musicListCount()-> Int {
        return musicList.count
    }
    
    func musicItem(index: Int)-> MusicModel {
        return musicList[index]
    }
    
    func OnMusic(index: Int) {
        UserDefaults.standard.setValue(index, forKey: "id")
        musicList.forEach {
            realmManager.toggleMusic(music: $0, isChecked: false)
        }
        AudioPlayer.shared.StopSound()
        ToggleMusic(index: index, isChecked: true)
    }
    
    func OffMusic(index: Int) {
        if musicItem(index: index).isChecked {
            ToggleMusic(index: index, isChecked: false)
        }
    }
    
    func RestartMusic(index: Int) {
        if musicItem(index: index).isChecked {
            AudioPlayer.shared.StopSound()
            UserDefaults.standard.setValue(0, forKey: "time")
            ToggleMusic(index: index, isChecked: true)
        }
    }
    
    func ToggleMusic(index: Int, isChecked: Bool) {
        realmManager.toggleMusic(music: musicList[index], isChecked: isChecked)
        GetMusicList()
        UserDefaults.standard.setValue(index, forKey: "id")
        if musicList[index].isChecked {
            AudioPlayer.shared.PlaySound(resource: self.musicList[index].fileName)
            self.isChanged.toggle()
        } else {
            AudioPlayer.shared.StopSound()
            self.isChanged.toggle()
        }
    }
    
    func isMusicSelected(index: Int)-> UITableViewCell.AccessoryType {
        if musicList[index].isChecked {
            return .checkmark
        } else {
            return .none
        }
    }
}
