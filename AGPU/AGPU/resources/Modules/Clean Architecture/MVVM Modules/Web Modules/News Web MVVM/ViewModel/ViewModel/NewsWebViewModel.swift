//
//  NewsWebViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 06.03.2024.
//

import UIKit

final class NewsWebViewModel {
    
    var article: Article
    var url: String = ""
    var scrollView: UIScrollView
    
    var alertHandler: ((Bool, String, String)->Void)?
    var scrollPositionHandler: ((Double)->Void)?
    var currentScrollPosition: scrollPositions?
    
    // MARK: - сервисы
    let settingsManager = SettingsManager()
    let realmManager = RealmManager()
    let dateManager = DateManager()
    let speechRecognitionManager = SpeechRecognitionManager()
    
    // MARK: - Init
    init(article: Article, url: String, scrollView: UIScrollView) {
        self.article = article
        self.url = url
        self.scrollView = scrollView
    }
}
