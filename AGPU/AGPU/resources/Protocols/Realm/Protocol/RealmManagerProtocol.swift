//
//  RealmManagerProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 30.06.2023.
//

import RealmSwift
import UIKit

protocol RealmManagerProtocol {
    func fetchMusicList(completion: @escaping([MusicModel])->Void)
    func saveMusic(music: MusicModel, image: UIImage)
    func toggleMusic(music: MusicModel, isChecked: Bool)
    func findMusicItem(by id: ObjectId)-> MusicModel?
    func editMusic(music: MusicModel, title: String, file: String)
    func deleteMusic(music: MusicModel)
}
