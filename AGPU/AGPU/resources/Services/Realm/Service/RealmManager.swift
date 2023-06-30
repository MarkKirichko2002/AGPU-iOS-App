//
//  RealmManager.swift
//  AGPU
//
//  Created by Марк Киричко on 30.06.2023.
//

import RealmSwift
import Foundation

class RealmManager: RealmManagerProtocol {
    
    private let realm = try! Realm()
    
    func fetchMusicList(completion: @escaping ([MusicModel]) -> Void) {
        var array = [MusicModel]()
        let items = realm.objects(MusicModel.self)
        for item in items {
            array.append(item)
        }
        print(array)
        completion(array)
    }
    
    func saveMusic(music: MusicModel) {
        var newItem = MusicModel()
        newItem = music
        try! realm.write {
            realm.add(newItem)
        }
    }
    
    func toggleMusic(music: MusicModel, isChecked: Bool) {
        var newItem = realm.object(ofType: MusicModel.self, forPrimaryKey: music.id)
        try! realm.write {
            newItem?.isChecked = isChecked
            print(newItem)
        }
    }
    
    func editMusic(music: MusicModel, title: String, isChecked: Bool) {
        var newItem = realm.object(ofType: MusicModel.self, forPrimaryKey: music.id)
        try! realm.write {
            newItem?.name = title
            newItem?.isChecked = isChecked
            print(newItem)
        }
    }
    
    func deleteMusic(music: MusicModel) {
        let newItem = realm.object(ofType: MusicModel.self, forPrimaryKey: music.id)
        if let newItem = newItem {
            try! realm.write {
                realm.delete(newItem)
            }
        }
    }
}
