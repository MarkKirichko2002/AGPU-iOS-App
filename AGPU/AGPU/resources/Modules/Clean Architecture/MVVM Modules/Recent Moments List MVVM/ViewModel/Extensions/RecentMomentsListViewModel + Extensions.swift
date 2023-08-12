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
    
    func GetLastWordDocument(completion: @escaping(String)->Void) {
        if let page = UserDefaults.loadData(type: RecentWebPageModel.self, key: "last page") {
            if page.url.contains(".doc") {
                print(page.url)
                completion(page.url)
            } else {
                print(page.url)
                alertHandler?("Нет недавнего Word-документа.", "Вы еще не открывали не одного Word-документа.")
            }
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
}
