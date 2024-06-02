//
//  ISavedVideosListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 02.06.2024.
//

import Foundation

protocol ISavedVideosListViewModel {
    func videosCount()-> Int
    func videoItem(index: Int)-> VideoModel
    func saveVideo(video: VideoModel) 
    func getVideos()
    func editVideo(video: VideoModel, name: String)
    func deleteVideo(video: VideoModel)
    func getCurrentDate()-> String 
    func registerDataChangedHandler(block: @escaping()->Void)
}
