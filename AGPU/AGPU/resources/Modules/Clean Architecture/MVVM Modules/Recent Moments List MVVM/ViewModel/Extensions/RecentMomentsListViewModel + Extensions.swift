//
//  RecentMomentsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 10.08.2023.
//

import Foundation

// MARK: - RecentMomentsViewModelProtocol
extension RecentMomentsListViewModel: RecentMomentsListViewModelProtocol {
    
    func getLastWebPage(completion: @escaping(RecentWebPageModel)->Void) {
        if let page = UserDefaults.loadData(type: RecentWebPageModel.self, key: "last page") {
            HapticsManager.shared.hapticFeedback()
            completion(page)
        } else {
            alertHandler?("Нет недавней веб-страницы.", "Вы еще не открывали не одной веб-страницы.")
        }
    }
    
    func getLastWordDocument(completion: @escaping(RecentWordDocumentModel)->Void) {
        if let document = UserDefaults.loadData(type: RecentWordDocumentModel.self, key: "last word document") {
            HapticsManager.shared.hapticFeedback()
            completion(document)
        } else {
            alertHandler?("Нет недавнего Word-документа.", "Вы еще не открывали не одного Word-документа.")
        }
    }
    
    func getLastPDFDocument(completion: @escaping(RecentPDFModel)->Void) {
        if let pdf = UserDefaults.loadData(type: RecentPDFModel.self, key: "last pdf") {
            HapticsManager.shared.hapticFeedback()
            completion(pdf)
        } else {
            alertHandler?("Нет недавнего PDF-документа.", "Вы еще не открывали не одного PDF-документа.")
        }
    }
    
    func getLastTimetable(completion: @escaping(String, String)->Void) {
        if let recentGroup = UserDefaults.standard.string(forKey: "recentGroup"),
           let recentDate = UserDefaults.standard.string(forKey: "recentDate") {
            completion(recentGroup, recentDate)
        } else {
            alertHandler?("У вас нет недавнего расписания.", "Вы еше не смотрели расписание.")
        }
    }
    
    func getLastVideo(completion: @escaping(String)->Void) {
        if let videoUrl = UserDefaults.standard.string(forKey: "last video") {
            HapticsManager.shared.hapticFeedback()
            completion(videoUrl)
        } else {
            alertHandler?("Нет недавнего видео.", "Вы еще не смотрели не одного видео.")
        }
    }
}
