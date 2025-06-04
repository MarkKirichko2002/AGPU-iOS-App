//
//  AGPUNewsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 08.08.2023.
//

import Foundation

final class AGPUNewsListViewModel {
    
    var newsResponse = NewsResponse(currentPage: 1, countPages: 0, articles: [])
    
    var abbreviation: String = ""
    var date: String = "" {
        didSet {
            refreshMonth(date: date)
        }
    }
    var option = NewsOptionsFilters.all
    var displayMode = DisplayModes.grid
    var isLoaded = false
    var allNews = [Article]()
    var articleInfo = ArticleInfo(id: 0, title: "", description: "", date: "", images: [])
    var month: Month = .none
    
    var noDateAlertHandler: (()->Void)?
    var closeAlertHandler: (()->Void)?
    var alertHandler: ((Bool, String, String)->Void)?
    var startLoadingHandler: (()->Void)?
    var dataChangedHandler: ((String)->Void)?
    var pageHandler: ((Int)->Void)?
    var newsDateHandler: (()->Void)?
    var errorHandler: (()->Void)?
    var dislayModeHandler: ((DisplayModes)->Void)?
    var newsRefreshHandler: (()->Void)?
    var webModeHandler: (()->Void)?
    var whatsNewHandler: (()->Void)?
    
    // MARK: - сервисы
    let newsService = AGPUNewsService()
    let dateManager = DateManager()
    let settingsManager = SettingsManager()
    let realmManager = RealmManager()
    let networkManager = NetworkManager()
    let speechRecognitionManager = SpeechRecognitionManager()
    
}
