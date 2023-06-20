//
//  SettingsListViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 20.06.2023.
//

import UIKit

class SettingsListViewController: UIViewController {
    
    private var tableView = UITableView()
    
    private var musicArray = [
        MusicModel(id: 1, name: "информатика", fileName: "informatics music.mp3", isChecked: false),
        MusicModel(id: 2, name: "литература", fileName: "literature music.mp3", isChecked: false),
        MusicModel(id: 3, name: "спорт", fileName: "sport music.mp3", isChecked: false)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUpTable()
    }
    
    private func SetUpTable() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SettingsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Релакс Режим"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var music = musicArray[indexPath.row]
        music.setDone(!self.musicArray[indexPath.row].isChecked)
        musicArray[indexPath.row].setDone(music.isChecked)
        NotificationCenter.default.post(name: Notification.Name("music"), object: musicArray[indexPath.row])
        tableView.reloadData()
        do {
            let data = try JSONEncoder().encode(music)
            UserDefaults.standard.setValue(data, forKey: "music")
        } catch {
            print(error)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = UserDefaults.loadData()
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if data?.id == musicArray[indexPath.row].id && data?.isChecked == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        cell.textLabel?.text = "\(musicArray[indexPath.row].id)) \(musicArray[indexPath.row].name)"
        return cell
    }
}
