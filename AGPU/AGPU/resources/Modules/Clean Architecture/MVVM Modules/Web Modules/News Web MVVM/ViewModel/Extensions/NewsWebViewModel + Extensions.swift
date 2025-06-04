//
//  NewsWebViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 06.03.2024.
//

import Foundation

// MARK: - INewsWebViewModel
extension NewsWebViewModel: INewsWebViewModel {
    
    func saveArticlePosition(position: Double) {
        if let article = realmManager.getArticle(id: article.id) {
            realmManager.editArticle(news: article, position: position)
        } else {
            let model = NewsModel()
            model.id = article.id
            model.title = article.title
            model.articleDescription = article.description
            model.url = url
            model.offsetY = 0
            model.previewImage = article.previewImage
            model.date = article.date
            realmManager.saveArticle(model: model)
        }
    }
    
    func getPosition() {
        if let news = realmManager.getArticle(id: article.id) {
            scrollPositionHandler?(news.offsetY)
        } else {
            scrollPositionHandler?(0)
            print("нет такой новости")
        }
    }
    
    func saveCurrentWebArticle(url: String, position: CGPoint) {
        let dateManager = DateManager()
        let date = dateManager.getCurrentDate()
        let time = dateManager.getCurrentTime(isFullFormat: true)
        let article = RecentWebPageModel(date: date, time: time, url: url, position: position)
        UserDefaults.saveData(object: article, key: "last article") {
            print("сохранено: \(article)")
        }
    }
    
    func getCategoryIcon(url: String)-> String {
        let items = url.components(separatedBy: "/")
        for item in items {
            if let newsCategory = NewsCategories.categories.first(where: { $0.newsAbbreviation == item }) {
                return newsCategory.icon
            }
        }
        return "АГПУ"
    }
    
    func saveWebPage() {
        let model = WebPageModel()
        model.id = UUID()
        model.name = dateManager.getCurrentDate()
        model.url = url
        realmManager.saveWebPage(page: model)
    }
    
    func isRecording()-> Bool {
        let screens = settingsManager.loadScreens()
        return screens.contains(SpeechScreens.newsWeb)
    }
    
    func checkVoiceCommandsOption() {
        if isRecording() {
            startRecognize()
        }
    }
    
    func resetSpeechRecognition() {
        if isRecording() {
            cancelRecognition()
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                self.startRecognize()
            }
        }
    }
    
    func cancelRecognition() {
        if isRecording() {
            speechRecognitionManager.cancelSpeechRecognition()
        }
    }
    
    private func startRecognize() {
        speechRecognitionManager.requestSpeechAndMicrophonePermission()
        speechRecognitionManager.registerSpeechAuthorizationHandler { auth in
            switch auth {
            case .notDetermined:
                print("Разрешение на распознавание речи еще не было получено.")
            case .denied:
                self.alertHandler?(true, self.createMicAlertMessage().0, self.createMicAlertMessage().1)
                print("Доступ к распознаванию речи был отклонен.")
            case .restricted:
                print("Функциональность распознавания речи ограничена.")
            case .authorized:
                print("Разрешение на распознавание речи получено.")
                self.speechRecognitionManager.startRecognize()
            @unknown default:
                print("неизвестно")
            }
        }
        speechRecognitionManager.registerSpeechRecognitionHandler { text in
            self.voiceCommands(text: text)
        }
    }
    
    private func voiceCommands(text: String) {
        voiceScroll(text: text.lastWord())
    }
    
    func createMicAlertMessage()-> (String, String) {
        let style = settingsManager.getSavedCommunicationStyle()
        let name = UserDefaults.standard.string(forKey: "name") ?? ""
        switch style {
        case .formal:
            return ("Микрофон выключен", "\(!name.isEmpty ? "\(name) хотите" : "Хотите") включить в настройках?")
        case .informal:
            return ("Микрофон выключен", "\(!name.isEmpty ? "\(name) хочешь" : "Хочешь") врубить в настройках?")
        }
    }
    
    func voiceScroll(text: String) {
        
        var positionY = self.scrollView.contentOffset.y
        
        if text.lowercased().contains("вверх") || text.lowercased().contains("верх") {
            positionY -= 60
        } else if text.lowercased().contains("низ") || text.lowercased().contains("вниз")  {
            positionY += 60
        }
        
        scrollPositionHandler?(positionY)
    }
    
    func registerScrollPositionHandler(block: @escaping(Double)->Void) {
        self.scrollPositionHandler = block
    }
}
