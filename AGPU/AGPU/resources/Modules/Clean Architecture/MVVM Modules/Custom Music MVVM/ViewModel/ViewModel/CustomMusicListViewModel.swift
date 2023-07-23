//
//  CustomMusicListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 12.07.2023.
//

import UIKit

final class CustomMusicListViewModel: NSObject {
    
    @objc dynamic var isChanged = false
    var observation: NSKeyValueObservation?
    
    var musicList = [MusicModel]()
    
    let realmManager = RealmManager()
    
    // MARK: - Init
    override init() {
        super.init()
        GetMusicList()
        NotificationCenter.default.addObserver(forName: Notification.Name("Music Added"), object: nil, queue: .main) { _ in
            self.GetMusicList()
        }
    }
}
