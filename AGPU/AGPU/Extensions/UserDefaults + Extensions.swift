//
//  UserDefaults + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 21.06.2023.
//

import Foundation

extension UserDefaults {
    
    static func loadData()-> MusicModel? {
        do {
            if let data = UserDefaults.standard.data(forKey: "music") {
                let music = try JSONDecoder().decode(MusicModel.self, from: data)
                print(music)
                return music
            }
        } catch {
            
        }
        return nil
    }
}
