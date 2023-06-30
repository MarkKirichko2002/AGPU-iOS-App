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
    func editMusic(music: MusicModel)
    func deleteMusic(music: MusicModel)
}
