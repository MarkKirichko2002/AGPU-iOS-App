//
//  SettingsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 21.06.2023.
//

import UIKit
import RealmSwift

class SettingsListViewModel: NSObject {
    
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
    
    func GetMusicList() {
        realmManager.fetchMusicList { musicList in
            self.musicList = musicList
            self.isChanged.toggle()
        }
    }
    
    func DeleteMusic(index: Int) {
        let id = UserDefaults.standard.object(forKey: "id") as? Int ?? 0
        if musicItem(index: index).id == musicItem(index: id).id {
            AudioPlayer.shared.StopSound()
        }
        realmManager.deleteMusic(music: musicItem(index: index))
        GetMusicList()
    }
    
    func sectionsCount()-> Int {
        return 2
    }
    
    func numberOfRowsInSection(section: Int)-> Int {
        switch section {
        case 0:
            return musicListCount()
        case 1:
            return facultiesListCount()
        default:
            return 0
        }
    }
    
    func cellForRowAt(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomMusicTableViewCell.identifier, for: indexPath) as? CustomMusicTableViewCell else {return UITableViewCell()}
            cell.accessoryType = isMusicSelected(index: indexPath.row)
            cell.tintColor = .systemGreen
            cell.configure(music: musicItem(index: indexPath.row))
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ElectedFacultyTableViewCell.identifier, for: indexPath) as? ElectedFacultyTableViewCell else {return UITableViewCell()}
            cell.accessoryType = isIconSelected(index: indexPath.row)
            cell.tintColor = .systemGreen
            cell.configure(faculty: electedFacultyItem(index: indexPath.row))
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func DidSelectRow(at indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            print(musicItem(index: indexPath.row))
        case 1:
            print(electedFacultyItem(index: indexPath.row))
        default:
            break
        }
    }
    
    func titleForSection(_ section: Int)-> String {
        switch section {
            
        case 0:
            return "Своя Музыка"
            
        case 1:
            return "Избранный Факультет"
            
        default:
            return ""
        }
    }
    
    // MARK: - Custom Music
    
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
    
    // MARK: - Elected Faculty
    
    func facultiesListCount()-> Int {
        return ElectedFaculties.faculties.count
    }
    
    func electedFacultyItem(index: Int)-> ElectedFacultyModel {
        return ElectedFaculties.faculties[index]
    }
    
    func ChangeIcon(index: Int) {
        var icon = ElectedFaculties.faculties[index]
        icon.isSelected = true
        UIApplication.shared.setAlternateIconName(icon.appIcon)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            NotificationCenter.default.post(name: Notification.Name("icon"), object: icon)
        }
        UserDefaults.SaveData(object: icon, key: "icon") {
            self.isChanged.toggle()
        }
    }
    
    func isIconSelected(index: Int)-> UITableViewCell.AccessoryType {
        let data = UserDefaults.loadData(type: ElectedFacultyModel.self, key: "icon")
        if data?.id == ElectedFaculties.faculties[index].id && data?.isSelected == true {
            return .checkmark
        } else {
            return .none
        }
    }
}
