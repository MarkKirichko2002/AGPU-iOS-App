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
        
        let message = style == .formal ? "\(name.isEmpty ? "Вы" : "\(name) вы") еще не открывали не одной веб-страницы" : "\(name.isEmpty ? "У тебя нет" : "\(name) у тебя нет") недавно просмотренной веб-страницы"
        
        if let page = UserDefaults.loadData(type: RecentWebPageModel.self, key: "last page") {
            completion(page)
        } else {
            alertHandler?("Нет недавней веб-страницы", message)
        }
    }
    
    func getLastWebArticle(completion: @escaping(RecentWebPageModel)->Void) {
        
        let message = style == .formal ? "\(name.isEmpty ? "Вы" : "\(name) вы") еще не открывали не одной новости" : "\(name.isEmpty ? "У тебя нет" : "\(name) у тебя нет") недавно просмотренной новости"
        
        if let article = UserDefaults.loadData(type: RecentWebPageModel.self, key: "last article") {
            completion(article)
        } else {
            alertHandler?("Нет недавней новости", message)
        }
    }
    
    func getLastWordDocument(completion: @escaping(RecentWordDocumentModel)->Void) {
        
        let message = style == .formal ? "\(name.isEmpty ? "Вы" : "\(name) вы") еще не открывали не одного Word-документа" : "\(name.isEmpty ? "У тебя нет" : "\(name) у тебя нет") недавно просмотренного Word-документа"
        
        if let document = UserDefaults.loadData(type: RecentWordDocumentModel.self, key: "last word document") {
            completion(document)
        } else {
            alertHandler?("Нет недавнего Word-документа", message)
        }
    }
    
    func getLastPDFDocument(completion: @escaping(RecentPDFModel)->Void) {
        
        let message = style == .formal ? "\(name.isEmpty ? "Вы" : "\(name) вы") еще не открывали не одного PDF-документа" : "\(name.isEmpty ? "У тебя нет" : "\(name) у тебя нет") недавно просмотренного PDF-документа"
        
        if let pdf = UserDefaults.loadData(type: RecentPDFModel.self, key: "last pdf") {
            completion(pdf)
        } else {
            alertHandler?("Нет недавнего PDF-документа.", message)
        }
    }
    
    func getLastTimetable(completion: @escaping(String, String, String)->Void) {
        
        let message = style == .formal ? "\(name.isEmpty ? "Вы" : "\(name) вы") еше не смотрели расписание" : "\(name.isEmpty ? "У тебя нет" : "\(name) у тебя нет") недавно просмотренного расписания"
        
        if let recentGroup = UserDefaults.standard.string(forKey: "recentGroup"),
           let recentDate = UserDefaults.standard.string(forKey: "recentDate"),
           let recentOwner = UserDefaults.standard.string(forKey: "recentOwner") {
            completion(recentGroup, recentDate, recentOwner)
        } else {
            alertHandler?("У вас нет недавнего расписания", message)
        }
    }
    
    func getLastVideo(completion: @escaping(String)->Void) {
        
        let message = style == .formal ? "\(name.isEmpty ? "Вы" : "\(name) вы") еще не смотрели не одного видео" : "\(name.isEmpty ? "У тебя нет" : "\(name) у тебя нет") недавно просмотренного видео"
        
        if let videoUrl = UserDefaults.standard.string(forKey: "last video") {
            completion(videoUrl)
        } else {
            alertHandler?("Нет недавнего видео", message)
        }
    }
    
    func registerAlertHandler(block: @escaping(String, String)->Void) {
        self.alertHandler = block
    }
}
