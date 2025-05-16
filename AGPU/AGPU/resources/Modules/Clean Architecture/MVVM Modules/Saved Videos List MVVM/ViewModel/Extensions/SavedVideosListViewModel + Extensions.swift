//
//  SavedVideosListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 02.06.2024.
//

import UIKit

// MARK: - ISavedVideosListViewModel
extension SavedVideosListViewModel: ISavedVideosListViewModel {
    
    func videosCount() -> Int {
        return videos.count
    }
    
    func videoItem(index: Int)-> VideoModel {
        return videos[index]
    }
    
    func saveVideo(video: VideoModel) {
        if isValidURL(url: video.url) {
            realmManager.saveVideo(video: video)
            getVideos()
        } else {
            alertHandler?()
        }
    }
    
    func getVideos() {
        videos = realmManager.getVideos()
        dataChangedHandler?()
    }
    
    func getChanges(index: Int) {
        videos = realmManager.getVideos()
        itemChangedHandler?(index)
    }
    
    func editVideo(video: VideoModel, name: String) {
        let index = videos.firstIndex { $0.id == video.id }!
        if videos[index].name != name {
            realmManager.editVideoName(video: video, name: name)
            getChanges(index: index)
        }
    }
    
    func updateVideos(videos: [VideoModel], _ index: Int, _ index2: Int) {
        realmManager.updateVideos(videos: videos, index, index2)
        getVideos()
    }
    
    func deleteVideo(video: VideoModel) {
        realmManager.deleteVideo(video: video)
        getVideos()
    }
    
    func getCurrentDate()-> String {
        let date = dateManager.getCurrentDate()
        return date
    }
    
    func isValidURL(url: String)-> Bool {
        return UIApplication.shared.isValidURL(url: url)
    }
    
    func createAddAlertMessage()-> (String, String) {
        let style = settingsManager.getSavedCommunicationStyle()
        let name = UserDefaults.standard.string(forKey: "name") ?? ""
        switch style {
        case .formal:
            return ("Добавить видео", "\(!name.isEmpty ? "\(name) введите" : "Введите") URL для видео")
        case .informal:
            return ("Добавить видео", "\(!name.isEmpty ? "\(name) введи" : "Введи") URL для видео")
        }
    }
    
    func createAlertMessage()-> (String, String) {
        let style = settingsManager.getSavedCommunicationStyle()
        let name = UserDefaults.standard.string(forKey: "name") ?? ""
        switch style {
        case .formal:
            return ("Данные не введены!", "\(!name.isEmpty ? "\(name) введите" : "Введите") URL для видео")
        case .informal:
            return ("Данные не введены!", "\(!name.isEmpty ? "\(name) введи" : "Введи") данные в текстовом поле")
        }
    }
    
    
    func createEditAlertMessage()-> (String, String) {
        let style = settingsManager.getSavedCommunicationStyle()
        let name = UserDefaults.standard.string(forKey: "name") ?? ""
        switch style {
        case .formal:
            return ("Изменить видео", "\(!name.isEmpty ? "\(name) вы точно хотите изменить" : "Вы точно хотите изменить") название видео?")
        case .informal:
            return ("Изменить видео", "\(!name.isEmpty ? "\(name) ты точно хочешь изменить" : "Ты точно хочешь изменить") название видео?")
        }
    }
    
    func registerAlertHandler(block: @escaping()->Void) {
        self.alertHandler = block
    }
    
    func registerDataChangedHandler(block: @escaping() -> Void) {
        self.dataChangedHandler = block
    }
    
    func registerItemChangedHandler(block: @escaping(Int) -> Void) {
        self.itemChangedHandler = block
    }
}
