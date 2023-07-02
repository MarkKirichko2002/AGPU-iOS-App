//
//  RealmManager + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 02.07.2023.
//

import UIKit
import RealmSwift

// MARK: - RealmManagerProtocol
extension RealmManager: RealmManagerProtocol {
    
    func fetchMusicList(completion: @escaping ([MusicModel]) -> Void) {
        var array = [MusicModel]()
        let items = realm.objects(MusicModel.self)
        for item in items {
            array.append(item)
        }
        print(array)
        completion(array)
    }
    
    func saveMusic(music: MusicModel, image: UIImage) {
        var newItem = MusicModel()
        newItem = music
        if let image = image.jpegData(compressionQuality: 0.9) {
            let data = NSData(data: image)
            newItem.image = data as Data
        }
        try! realm.write {
            realm.add(newItem)
        }
    }
    
    func toggleMusic(music: MusicModel, isChecked: Bool) {
        let newItem = realm.object(ofType: MusicModel.self, forPrimaryKey: music.id)
        try! realm.write {
            newItem?.isChecked = isChecked
            print(newItem)
        }
    }
    
    func findMusicItem(by id: ObjectId)-> MusicModel? {
        let music = realm.object(ofType: MusicModel.self, forPrimaryKey: id)
        if let music = music {
            return music
        } else {
            return nil
        }
    }
    
    func editMusic(music: MusicModel, title: String, file: String) {
        let newItem = realm.object(ofType: MusicModel.self, forPrimaryKey: music.id)
        try! realm.write {
            newItem?.name = title
            newItem?.fileName = file
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
