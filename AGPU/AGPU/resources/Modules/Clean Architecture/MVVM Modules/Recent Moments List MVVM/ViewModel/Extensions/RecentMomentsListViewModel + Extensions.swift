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
            completion(page)
        } else {
            alertHandler?("Нет недавней веб-страницы.", "Вы еще не открывали не одной веб-страницы.")
        }
    }
    
    func GetLastWordDocument(completion: @escaping(RecentWordDocumentModel)->Void) {
        if let document = UserDefaults.loadData(type: RecentWordDocumentModel.self, key: "last word document") {
            completion(document)
        } else {
            alertHandler?("Нет недавнего Word-документа.", "Вы еще не открывали не одного Word-документа.")
        }
    }
    
    func GetLastPDFDocument(completion: @escaping(RecentPDFModel)->Void) {
        if let pdf = UserDefaults.loadData(type: RecentPDFModel.self, key: "last pdf") {
            completion(pdf)
        } else {
            alertHandler?("Нет недавнего PDF-документа.", "Вы еще не открывали не одного PDF-документа.")
        }
    }
    
    func GetLastVideo(completion: @escaping(String)->Void) {
        if let videoUrl = UserDefaults.standard.string(forKey: "last video") {
            completion(videoUrl)
        } else {
            alertHandler?("Нет недавнего видео.", "Вы еще не смотрели не одного видео.")
        }
    }
    
    func SendScreenClosedNotification() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            NotificationCenter.default.post(name: Notification.Name("screen was closed"), object: nil)
        }
    }
}
