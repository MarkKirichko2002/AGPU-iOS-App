//
//  RecentMomentsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 10.08.2023.
//

import UIKit
import MapKit

// MARK: - RecentMomentsViewModelProtocol
extension RecentMomentsListViewModel: RecentMomentsListViewModelProtocol {
    
    func momentItem(index: Int)-> RecentMomentModel {
        return RecentMomentsList.moments[index]
    }
    
    func momentsCount()-> Int {
        return RecentMomentsList.moments.count
    }
    
    func getLastWebPage(completion: @escaping(RecentWebPageModel)->Void) {
        
        let message = style == .formal ? "\(name.isEmpty ? "Вы" : "\(name) вы") еще не открывали не одной веб-страницы" : "\(name.isEmpty ? "У тебя нет" : "\(name) у тебя нет") недавно просмотренной веб-страницы"
        
        if let page = UserDefaults.loadData(type: RecentWebPageModel.self, key: "last page") {
            if !page.url.isEmpty {
                completion(page)
            } else {
                alertHandler?("Нет недавней веб-страницы", message)
            }
        } else {
            alertHandler?("Нет недавней веб-страницы", message)
        }
    }
    
    func getLastWebArticle(completion: @escaping(RecentWebPageModel)->Void) {
        
        let message = style == .formal ? "\(name.isEmpty ? "Вы" : "\(name) вы") еще не открывали не одной новости" : "\(name.isEmpty ? "У тебя нет" : "\(name) у тебя нет") недавно просмотренной новости"
        
        if let article = UserDefaults.loadData(type: RecentWebPageModel.self, key: "last article") {
            if !article.url.isEmpty {
                completion(article)
            } else {
                alertHandler?("Нет недавней новости", message)
            }
        } else {
            alertHandler?("Нет недавней новости", message)
        }
    }
    
    func getLastPDFDocument(completion: @escaping(RecentPDFModel)->Void) {
        
        let message = style == .formal ? "\(name.isEmpty ? "Вы" : "\(name) вы") еще не открывали не одного PDF-документа" : "\(name.isEmpty ? "У тебя нет" : "\(name) у тебя нет") недавно просмотренного PDF-документа"
        
        if let pdf = UserDefaults.loadData(type: RecentPDFModel.self, key: "last pdf") {
            if !pdf.url.isEmpty {
                completion(pdf)
            } else {
                alertHandler?("Нет недавнего PDF-документа.", message)
            }
        } else {
            alertHandler?("Нет недавнего PDF-документа.", message)
        }
    }
    
    func getLastWordDocument(completion: @escaping(RecentWordDocumentModel)->Void) {
        
        let message = style == .formal ? "\(name.isEmpty ? "Вы" : "\(name) вы") еще не открывали не одного Word-документа" : "\(name.isEmpty ? "У тебя нет" : "\(name) у тебя нет") недавно просмотренного Word-документа"
        
        if let document = UserDefaults.loadData(type: RecentWordDocumentModel.self, key: "last word document") {
            if !document.url.isEmpty {
                completion(document)
            } else {
                alertHandler?("Нет недавнего Word-документа", message)
            }
        } else {
            alertHandler?("Нет недавнего Word-документа", message)
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
            if !videoUrl.isEmpty {
                completion(videoUrl)
            } else {
                alertHandler?("Нет недавнего видео", message)
            }
        } else {
            alertHandler?("Нет недавнего видео", message)
        }
    }
    
    func getLastLocation(completion: @escaping(MKPointAnnotation)->Void) {
        
        let message = style == .formal ? "\(name.isEmpty ? "Вы" : "\(name) вы") еще не открывали не одной локации" : "\(name.isEmpty ? "У тебя нет" : "\(name) у тебя нет") недавно просмотренной локации"
        
        if let model = UserDefaults.loadData(type: RecentBuildingModel.self, key: "last location") {
            if !model.coordinates.isEmpty {
                let location = MKPointAnnotation()
                location.title = model.name
                location.coordinate = CLLocationCoordinate2D(latitude: model.coordinates[0], longitude: model.coordinates[1])
                completion(location)
            } else {
                alertHandler?("Нет недавней локации", message)
            }
        } else {
            alertHandler?("Нет недавней локации", message)
        }
    }
    
    func contentForShare(index: Int, completion: @escaping(Any)->Void) {
        switch momentItem(index: index).id {
        case 1:
            getLastWebPage { page in
                completion(page.url)
            }
        case 2:
            getLastWebArticle { article in
                completion(article.url)
            }
        case 3:
            getLastPDFDocument { document in
                completion(document.url)
            }
        case 4:
            getLastWordDocument { document in
                completion(document.url)
            }
        case 5:
            getTimeTableForDay { image in
                completion(image)
            }
        case 6:
            getLastVideo { video in
                completion(video)
            }
        case 7:
            getLastLocation { location in
                completion(location)
            }
        default:
            break
        }
    }
    
    func getTimeTableForDay(completion: @escaping(UIImage)->Void) {
        
        let recentGroup = UserDefaults.standard.string(forKey: "recentGroup") ?? "ВМ-ИВТ-3-1"
        let recentDate = UserDefaults.standard.string(forKey: "recentDate") ?? dateManager.getCurrentDate()
        let recentOwner = UserDefaults.standard.string(forKey: "recentOwner") ?? "GROUP"
        
        service.getTimeTableDay(id: recentGroup, date: recentDate, owner: recentOwner) { [weak self] result in
            switch result {
            case .success(let data):
                self?.timetable = TimeTable(id: data.id, date: data.date, disciplines: data.disciplines)
                self?.createImage { image in
                    completion(image)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func createImage(completion: @escaping(UIImage)->Void) {
        
        let recentGroup = UserDefaults.standard.string(forKey: "recentGroup") ?? "ВМ-ИВТ-3-1"
        let recentDate = UserDefaults.standard.string(forKey: "recentDate") ?? dateManager.getCurrentDate()
        
        let emptyTimetable = TimeTable(id: recentGroup, date: recentDate, disciplines: [])
        
        if !self.timetable.disciplines.isEmpty {
            do {
                let json = try JSONEncoder().encode(timetable)
                self.service.getTimeTableDayImage(json: json) { image in
                    completion(image)
                }
            } catch {
                print(error.localizedDescription)
            }
        } else {
            do {
                let json = try JSONEncoder().encode(emptyTimetable)
                self.service.getTimeTableDayImage(json: json) { image in
                    completion(image)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func getRecentTimetableInfo()-> (String, String) {
        let recentID = UserDefaults.standard.string(forKey: "recentGroup") ?? "ВМ-ИВТ-3-1"
        let recentDate = UserDefaults.standard.string(forKey: "recentDate") ?? dateManager.getCurrentDate()
        return (recentID, recentDate)
    }
    
    func resetData(index: Int) {
        switch momentItem(index: index).id {
        case 1:
            UserDefaults.saveData(object: RecentWebPageModel(date: "", time: "", url: "", position: CGPoint(x: 0, y: 0)), key: "last page") {}
        case 2:
            UserDefaults.saveData(object: RecentWebPageModel(date: "", time: "", url: "", position: CGPoint(x: 0, y: 0)), key: "last article") {}
        case 3:
            UserDefaults.saveData(object: RecentPDFModel(url: "", pageNumber: 0), key: "last pdf") {}
        case 4:
            UserDefaults.saveData(object: RecentWordDocumentModel(date: "", time: "", url: "", position: CGPoint(x: 0, y: 0)), key: "last word document") {}
        case 5:
            UserDefaults.standard.setValue("ВМ-ИВТ-3-1", forKey: "recentGroup")
            UserDefaults.standard.setValue(dateManager.getCurrentDate(), forKey: "recentDate")
            UserDefaults.standard.setValue("GROUP", forKey: "recentOwner")
        case 6:
            UserDefaults.standard.setValue("", forKey: "last video")
        case 7:
            UserDefaults.saveData(object: RecentBuildingModel(name: "", info: "", coordinates: []), key: "last location") {}
        default:
            break
        }
    }
    
    func registerAlertHandler(block: @escaping(String, String)->Void) {
        self.alertHandler = block
    }
}
