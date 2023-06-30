//
//  RealmManagerProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 30.06.2023.
//

import Foundation

protocol RealmManagerProtocol {
    func fetchMusicList(completion: @escaping([MusicModel])->Void)
    func saveMusic(music: MusicModel)
    func toggleMusic(music: MusicModel, isChecked: Bool)
    func editMusic(music: MusicModel, title: String, isChecked: Bool)
    func deleteMusic(music: MusicModel)
}
