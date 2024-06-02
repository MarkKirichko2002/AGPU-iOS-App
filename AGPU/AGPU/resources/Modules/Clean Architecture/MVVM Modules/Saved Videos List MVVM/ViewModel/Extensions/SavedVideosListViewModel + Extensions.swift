//
//  SavedVideosListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 02.06.2024.
//

import Foundation

// MARK: - ISavedVideosListViewModel
extension SavedVideosListViewModel: ISavedVideosListViewModel {
    
    func videosCount() -> Int {
        return videos.count
    }
    
    func videoItem(index: Int)-> VideoModel {
        return videos[index]
    }
    
    func saveVideo(video: VideoModel) {
        realmManager.saveVideo(video: video)
        getVideos()
    }
    
    func getVideos() {
        videos = realmManager.getVideos()
        dataChangedHandler?()
    }
    
    func editVideo(video: VideoModel, name: String) {
        realmManager.editVideoName(video: video, name: name)
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
    
    func registerDataChangedHandler(block: @escaping() -> Void) {
        self.dataChangedHandler = block
    }
}
