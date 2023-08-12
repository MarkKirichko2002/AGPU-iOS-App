//
//  RecentMomentsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 10.08.2023.
//

import Foundation

// MARK: - RecentMomentsViewModelProtocol
extension RecentMomentsListViewModel: RecentMomentsListViewModelProtocol {
    
    func GetLastWebPage(completion: @escaping(RecentWebPageModel)->Void) {
        if let page = UserDefaults.loadData(type: RecentWebPageModel.self, key: "last page") {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                completion(page)
            }
        } else {
            alertHandler?("Нет недавней веб-страницы", "Вы еще не открывали не одной веб-страницы")
        }
    }
    
    func GetLastPDFDocument(completion: @escaping(RecentPDFModel)->Void) {
        if let pdf = UserDefaults.loadData(type: RecentPDFModel.self, key: "last pdf") {
            completion(pdf)
        } else {
            alertHandler?("Нет недавнего документа", "Вы еще не открывали не одного документа")
        }
    }
    
    func GetLastVideo(completion: @escaping(String)->Void) {
        if let videoUrl = UserDefaults.standard.string(forKey: "last video") {
            completion(videoUrl)
        } else {
            alertHandler?("Нет недавнего видео", "Вы еще не смотрели не одного видео")
        }
    }
}
