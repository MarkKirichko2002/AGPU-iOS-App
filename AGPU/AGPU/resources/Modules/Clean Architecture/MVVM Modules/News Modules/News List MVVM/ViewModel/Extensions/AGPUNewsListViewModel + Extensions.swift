//
//  AGPUNewsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 08.08.2023.
//

import UIKit

// MARK: - AGPUNewsListViewModelProtocol
extension AGPUNewsListViewModel: AGPUNewsListViewModelProtocol {
    
    func getSavedNewsOptions()-> [MenuOptionModel] {
        return settingsManager.loadMenuOptions(category: menuOptionCategories.newsList.rawValue)
    }
    
    func getCurrentCategory()-> NewsCategoryModel {
        let savedNewsCategory = UserDefaults.standard.object(forKey: "category") as? String ?? "-"
        let category = NewsCategories.categories.first(where: { $0.newsAbbreviation == savedNewsCategory }) ?? NewsCategories.categories[0]
        return category
    }
    
    func getCurrentCategoryIcon()-> String {
        let savedNewsCategory = UserDefaults.standard.object(forKey: "category") as? String ?? "-"
        let category = NewsCategories.categories.first(where: { $0.newsAbbreviation == savedNewsCategory }) ?? NewsCategories.categories[0]
        if category.id == 0 {
            return "aspu logo"
        } else {
            return category.icon
        }
    }
    
    // вернуть элемент новости
    func articleItem(index: Int)-> Article {
        if let news = newsResponse.articles {
            if !news.isEmpty {
                if let article = newsResponse.articles?[index] {
                    return article
                }
            }
        }
        return Article(id: 0, title: "", description: "", date: "", previewImage: "")
    }
    
    func stopSaying() {
        SpeechSynthesizerManager.shared.stopComment()
    }
    
    func checkSettings() {
        let style = UserDefaults.loadData(type: ScreenPresentationStyles.self, key: "screen presentation style") ?? .notShow
        let savedDate = settingsManager.getSavedDate(screen: "news list")
        if savedDate != dateManager.getCurrentDate() {
            UserDefaults.standard.set(dateManager.getCurrentDate(), forKey: "saved date news list")
            if style != .notShow {
                checkWhatsNew()
            }
        }
        abbreviation = UserDefaults.standard.value(forKey: "category") as? String ?? "-"
        date = dateManager.getCurrentDate()
        option = UserDefaults.loadData(type: NewsOptionsFilters.self, key: "news filter") ?? .all
        displayMode = UserDefaults.loadData(type: DisplayModes.self, key: "display mode") ?? .grid
        getNewsByCurrentType()
    }
    
    func checkWhatsNew() {
        
        for category in NewsCategories.categories {
            
            if category.newsAbbreviation != "-" {
                Task {
                    let result = try await newsService.getNews(abbreviation: category.newsAbbreviation)
                    switch result {
                    case .success(let data):
                        if checkTodayNews(news: data.articles ?? []) {
                            self.whatsNewHandler?()
                        }
                    case .failure(let error):
                        self.errorHandler?()
                        print(error)
                    }
                }
            } else {
                Task {
                    let result = try await newsService.getAGPUNews()
                    switch result {
                    case .success(let data):
                        if checkTodayNews(news: data.articles ?? []) {
                            self.whatsNewHandler?()
                        }
                    case .failure(let error):
                        self.errorHandler?()
                        print(error)
                    }
                }
            }
        }
    }
    
    func checkTodayNews(news: [Article])-> Bool {
        let currentDate = dateManager.getCurrentDate()
        for article in news {
            if article.date == currentDate {
                print("есть новости за сегодня!")
                return true
            }
        }
        return false
    }
    
    func getIndicator()-> LoadingIndicators {
        let indicator = UserDefaults.loadData(type: LoadingIndicators.self, key: "indicator") ?? .regular
        return indicator
    }
    
    func getCurrentIndicator()-> UIView {
        let savedNewsCategory = UserDefaults.standard.object(forKey: "category") as? String ?? "-"
        let indicator = getIndicator()
        switch indicator {
        case .regular:
            let indicator = UIActivityIndicatorView(style: .large)
            indicator.color = colorForIndicator()
            return indicator
        case .category:
            self.abbreviation = savedNewsCategory
            if let newsCategory = NewsCategories.categories.first(where: { $0.newsAbbreviation == savedNewsCategory }) {
                return SpringImageView(image: UIImage(named: newsCategory.icon)!)
            } else {
                return SpringImageView(image: UIImage(named: "АГПУ")!)
            }
        case .date:
            let label = UILabel()
            label.text = "\(dateManager.getCurrentDayOfWeek(date: dateManager.getCurrentDate())) \(dateManager.getCurrentDate())"
            label.font = .systemFont(ofSize: 18, weight: .medium)
            label.textAlignment = .center
            return label
        case .label:
            let label = UILabel()
            label.text = "Загрузка..."
            label.font = .systemFont(ofSize: 18, weight: .medium)
            label.textAlignment = .center
            return label
        case .timeOfDay:
            let imageView = SpringImageView(image: UIImage(named: getIconForDayTime())!)
            imageView.tintColor = .label
            return imageView
        case .season:
            let imageView = SpringImageView(image: UIImage(named: getIconForSeason())!)
            imageView.tintColor = .label
            return imageView
        }
    }
    
    func getIconForDayTime()-> String {
        let time = dateManager.getCurrentTime(isFullFormat: false)
        print(time)
        // утро, день
        if dateManager.timeRange(startTime: "4:00", endTime: "16:59", currentTime: time) {
            print("утро или день")
            return "sun"
        }
        // вечер, ночь
        if dateManager.timeRange(startTime: "17:00", endTime: "23:59", currentTime: time) {
            print("вечер или ночь")
            return "moon"
        }
        if dateManager.timeRange(startTime: "00:00", endTime: "3:59", currentTime: time) {
            print("вечер или ночь")
            return "moon"
        }
        return "sun"
    }
    
    func getIconForSeason()-> String {
        let month = dateManager.getCurrentMonth()
        switch month {
        case 12,1,2:
            return "winter"
        case 3,4,5:
            return "cloud"
        case 6,7,8:
            return "sun"
        case 9,10,11:
            return "umbrella"
        default:
            return ""
        }
    }
    
    func getIndicatorSize()-> CGSize {
        let indicator = getIndicator()
        switch indicator {
        case .regular:
            return CGSize(width: 100, height: 80)
        case .category:
            return CGSize(width: 75, height: 75)
        case .date:
            return CGSize(width: 150, height: 80)
        case .label:
            return CGSize(width: 150, height: 80)
        case .timeOfDay:
            return CGSize(width: 55, height: 55)
        case .season:
            return CGSize(width: 55, height: 55)
        }
    }
    
    // получить новости в зависимости от типа
    func getNewsByCurrentType() {
        let savedNewsCategory = UserDefaults.standard.object(forKey: "category") as? String ?? "-"
        if savedNewsCategory != "-" {
            getNews(abbreviation: savedNewsCategory)
        } else {
            getAGPUNews()
            abbreviation = "-"
        }
    }
    
    // получить новости АГПУ
    func getAGPUNews() {
        startLoadingHandler?()
        Task {
            let result = try await newsService.getAGPUNews()
            switch result {
            case .success(let response):
                self.newsResponse = response
                switch displayMode {
                case .grid:
                    date = dateManager.getCurrentDate()
                    allNews = response.articles ?? []
                    filterNews(option: option)
                case .table:
                    date = dateManager.getCurrentDate()
                    allNews = response.articles ?? []
                    filterNews(option: option)
                case .webpage:
                    date = dateManager.getCurrentDate()
                    dataChangedHandler?("-")
                    dislayModeHandler?(.webpage)
                    webModeHandler?()
                }
            case .failure(let error):
                self.errorHandler?()
                print(error)
            }
        }
    }
    
    // получить новости
    func getNews(abbreviation: String) {
        startLoadingHandler?()
        Task {
            let result = try await newsService.getNews(abbreviation: abbreviation)
            switch result {
            case .success(let response):
                self.newsResponse = response
                self.abbreviation = abbreviation
                switch displayMode {
                case .grid:
                    date = dateManager.getCurrentDate()
                    allNews = response.articles ?? []
                    filterNews(option: option)
                case .table:
                    date = dateManager.getCurrentDate()
                    allNews = response.articles ?? []
                    filterNews(option: option)
                case .webpage:
                    date = dateManager.getCurrentDate()
                    dataChangedHandler?(abbreviation)
                    dislayModeHandler?(.webpage)
                    webModeHandler?()
                }
            case .failure(let error):
                self.errorHandler?()
                print(error)
            }
        }
    }
    
    // получить новость по странице
    func getNews(by page: Int, completion: @escaping()->Void) {
        startLoadingHandler?()
        Task {
            let result = try await newsService.getNews(by: page, abbreviation: abbreviation)
            switch result {
            case .success(let response):
                switch displayMode {
                case .grid:
                    self.date = dateManager.getCurrentDate()
                    self.newsResponse = response
                    self.allNews = response.articles ?? []
                    self.option = .all
                    self.createAdditionalArticle()
                    self.dataChangedHandler?(self.abbreviation)
                    self.dislayModeHandler?(displayMode)
                case .table:
                    self.date = dateManager.getCurrentDate()
                    self.newsResponse = response
                    self.allNews = response.articles ?? []
                    self.option = .all
                    self.createAdditionalArticle()
                    self.dataChangedHandler?(self.abbreviation)
                    self.dislayModeHandler?(displayMode)
                case .webpage:
                    self.date = dateManager.getCurrentDate()
                    self.newsResponse = response
                    self.dataChangedHandler?(abbreviation)
                    self.dislayModeHandler?(displayMode)
                    self.webModeHandler?()
                }
                completion()
            case .failure(let error):
                self.errorHandler?()
                print(error)
                completion()
            }
        }
    }
    
    func getArticleInfo(id: Int, completion: @escaping(ArticleInfo)->Void) {
        let id = articleItem(index: id).id
        Task {
            let result = try await newsService.getArticleInfo(abbreviation: abbreviation, id: id)
            switch result {
            case .success(let data):
                print(data.description)
                DispatchQueue.main.async {
                    completion(data)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func refreshNews() {
        if let page = newsResponse.currentPage {
            date = dateManager.getCurrentDate()
            getNews(by: page) {}
        }
    }
    
    func createAdditionalArticle() {
        guard let page = newsResponse.currentPage else {return}
        if !(newsResponse.articles?.isEmpty ?? false) {
            if (newsResponse.articles?.count ?? 0) % 2 != 0 && page < newsResponse.countPages ?? 0 {
                newsResponse.articles?.append(Article(id: 0, title: "Чтобы перейти к странице \(page + 1) нужно нажать на ячейку.", description: "", date: "текущая страница: \(page)", previewImage: ""))
            } else if page >= newsResponse.countPages ?? 0  {
                newsResponse.articles?.append(Article(id: 1, title: "Это последняя страница.", description: "", date: "текущая страница: \(page)", previewImage: ""))
            }
        }
    }
    
    // следить за изменением категории
    func observeCategoryChanges() {
        NotificationCenter.default.addObserver(forName: Notification.Name("category"), object: nil, queue: .main) { notification in
            guard let category = notification.object as? String else {return}
            self.getNewsFromMenu(category: category)
        }
    }
    
    func getNewsFromMenu(category: String) {
        if category != self.abbreviation {
            if category != "-" {
                self.getNews(abbreviation: category)
                self.option = .all
            } else {
                self.getAGPUNews()
                self.option = .all
            }
        }
        updateCategory(category: category)
    }
    
    func updateCategory(category: String) {
        if category != "-" {
            self.abbreviation = category
            UserDefaults.standard.setValue(category, forKey: "category")
        } else {
            self.abbreviation = "-"
            UserDefaults.standard.setValue("-", forKey: "category")
        }
    }
    
    func observeDisplayMode() {
        NotificationCenter.default.addObserver(forName: Notification.Name("display mode option"), object: nil, queue: .main) { notification in
            if let displayMode = notification.object as? DisplayModes {
                self.displayMode = displayMode
                self.getNews(by: self.newsResponse.currentPage ?? 0) {}
            }
        }
    }
    
    func observeStrokeOption() {
        NotificationCenter.default.addObserver(forName: Notification.Name("daily news border option"), object: nil, queue: .main) { _ in
            self.dataChangedHandler?(self.abbreviation)
        }
    }
    
    func observeFilterOption() {
        NotificationCenter.default.addObserver(forName: Notification.Name("news filter option"), object: nil, queue: .main) { notification in
            if let option = notification.object as? NewsOptionsFilters {
                self.handleNewsFilter(option: option)
            }
        }
    }
    
    func observeVisualChangesOption() {
        NotificationCenter.default.addObserver(forName: Notification.Name("visual changes option"), object: nil, queue: .main) { _ in
            self.checkWhatsNew()
        }
    }
    
    func observeNewsOptionsChanges() {
        NotificationCenter.default.addObserver(forName: Notification.Name("news list options changed"), object: nil, queue: .main) { _ in
            self.dataChangedHandler?(self.abbreviation)
        }
    }
    
    func handleNewsFilter(option: NewsOptionsFilters) {
        switch self.displayMode {
        case .grid:
            self.option = option
            self.filterNews(option: option)
        case .table:
            self.option = option
            self.filterNews(option: option)
        case .webpage:
            break
        }
    }
    
    func filterNews(option: NewsOptionsFilters) {
        switch option {
        case .today:
            let date = dateManager.getCurrentDate()
            let filteredNews = allNews.filter({ $0.date == date})
            newsResponse.articles = filteredNews
            createAdditionalArticle()
            dataChangedHandler?(abbreviation)
            dislayModeHandler?(displayMode)
        case .yesterday:
            let date = dateManager.getCurrentDate()
            let yesterday = dateManager.previousDay(date: date)
            let filteredNews = allNews.filter({ $0.date == yesterday})
            newsResponse.articles = filteredNews
            createAdditionalArticle()
            dataChangedHandler?(abbreviation)
            dislayModeHandler?(displayMode)
        case .dayBeforeYesterday:
            let date = dateManager.getCurrentDate()
            let yesterday = dateManager.previousDay(date: date)
            let beforeYesterday = dateManager.previousDay(date: yesterday)
            let filteredNews = allNews.filter({ $0.date == beforeYesterday})
            newsResponse.articles = filteredNews
            createAdditionalArticle()
            dataChangedHandler?(abbreviation)
            dislayModeHandler?(displayMode)
        case .currentWeek:
            let dates = dateManager.datesOfCurrentWeek()
            newsResponse.articles = allNews.filter { dates.contains($0.date) }
            createAdditionalArticle()
            dataChangedHandler?(abbreviation)
            dislayModeHandler?(displayMode)
        case .all:
            newsResponse.articles = allNews
            createAdditionalArticle()
            dataChangedHandler?(abbreviation)
            dislayModeHandler?(displayMode)
        }
    }
    
    func filterNews(by date: String, arr: [Article]) {
        self.date = date
        let filteredNews = arr.filter({ $0.date == date})
        newsResponse.articles = filteredNews
        dataChangedHandler?(abbreviation)
        dislayModeHandler?(displayMode)
    }
    
    func filterNewsMonth(by month: String, arr: [Article]) {
        self.date = date.updateDateMonth(month: month)
        let filteredNews = arr.filter({ $0.date.components(separatedBy: ".")[1] == month})
        newsResponse.articles = filteredNews.sorted { dateManager.compareDates(date1: $0.date, date2: $1.date) == .orderedDescending }
        dataChangedHandler?(abbreviation)
        dislayModeHandler?(displayMode)
    }
    
    func getNews(date: String, completion: @escaping()->Void) {
        self.date = date
        newsDateHandler?()
        getNewsPagesInfo {
            completion()
        }
    }
    
    func getMonthNews(month: Month) {
        self.month = month
        self.date = date.updateDateMonth(month: String(month.number))
        newsDateHandler?()
        getNewsPagesInfo(month: month)
    }
    
    func getNewsPagesInfo(completion: @escaping()->Void) {
        
        let dispatchGroup = DispatchGroup()
        
        guard let pages = newsResponse.countPages else {return}
        
        var news: Set<Article> = Set()
        let newsQueue = DispatchQueue(label: "com.yourapp.newsQueue")
        
        startLoadingHandler?()
        
        for page in 1...pages {
            dispatchGroup.enter()
            Task {
                let result = try await newsService.getNews(by: page, abbreviation: abbreviation)
                defer { dispatchGroup.leave() }
                switch result {
                case .success(let data):
                    guard let articles = data.articles else {return}
                    newsQueue.sync {
                        for article in articles {
                            news.insert(article)
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.filterNews(by: self.date, arr: Array(news))
            completion()
        }
    }
    
    func getNewsPagesInfo(month: Month) {
        
        let dispatchGroup = DispatchGroup()
        
        guard let pages = newsResponse.countPages else {return}
        
        var news: Set<Article> = Set()
        let newsQueue = DispatchQueue(label: "com.yourapp.newsQueue")
        
        startLoadingHandler?()
        
        for page in 1...pages {
            dispatchGroup.enter()
            Task {
                let result = try await newsService.getNews(by: page, abbreviation: abbreviation)
                defer { dispatchGroup.leave() }
                switch result {
                case .success(let data):
                    guard let articles = data.articles else {return}
                    newsQueue.sync {
                        for article in articles {
                            news.insert(article)
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            print("Всего новостей: \(news.count)")
            self.filterNewsMonth(by: month.number, arr: Array(news))
        }
    }
    
    func refreshMonth(date: String) {
        if let item = Month.allCases.first(where: { $0.number == date.components(separatedBy: ".")[1] }) {
            self.month = item
        }
    }
    
    func makePagesList()-> [Int] {
        var arr = [Int]()
        if let countPages = newsResponse.countPages {
            for i in 1...countPages {
                arr.append(i)
            }
        }
        return arr
    }
    
    // получить URL для конкретной статьи
    func makeUrlForCurrentArticle(index: Int)-> String {
        let url = newsService.urlForCurrentArticle(abbreviation: abbreviation, index: articleItem(index: index).id)
        return url
    }
    
    // получить URL для конкретной веб-страницы
    func makeUrlForCurrentWebPage()-> String {
        let url = newsService.urlForCurrentWebPage(abbreviation: abbreviation, currentPage: newsResponse.currentPage ?? 0)
        return url
    }
    
    func colorForIndicator()-> UIColor {
        switch displayMode {
        case .grid:
            return .label
        case .table:
            return .label
        case .webpage:
            return .black
        }
    }
    
    func isRecording()-> Bool {
        let screens = settingsManager.loadSpeechScreens()
        return screens.contains(SpeechScreens.newsList)
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
        voiceActions(text: text)
        voiceNewsDisplay(text: text)
        voiceNewsFilter(text: text)
        voiceGetNewsFromDate(text: text)
        voiceCloseAlert(text: text)
    }
    
    private func voiceActions(text: String) {
        if text.lowercased().contains("обнови") {
            resetSpeechRecognition()
            newsRefreshHandler?()
            HapticsManager.shared.hapticFeedback()
        }
    }
    
    private func voiceNewsDisplay(text: String) {
        for mode in DisplayModes.allCases {
            if text.lowercased().contains(mode.voiceCommand) {
                print("выбрано: \(mode.rawValue)")
                cancelRecognition()
                displayMode = mode
                getNews(by: self.newsResponse.currentPage ?? 0) {
                    DispatchQueue.main.async {
                        self.startRecognize()
                    }
                }
                HapticsManager.shared.hapticFeedback()
                break
            }
        }
    }
    
    private func voiceNewsFilter(text: String) {
        for option in NewsOptionsFilters.allCases {
            if text.lowercased().contains(option.voiceCommand) {
                cancelRecognition()
                getNews(by: self.newsResponse.currentPage ?? 0) {
                    DispatchQueue.main.async {
                        self.handleNewsFilter(option: option)
                        self.startRecognize()
                    }
                }
                HapticsManager.shared.hapticFeedback()
                break
            }
        }
    }
    
    func voiceGetNewsFromDate(text: String) {
        if text.lowercased().contains(text.lowercased().getDateFromString()) {
            if dateManager.checkDateFromWords(text: text) {
                cancelRecognition()
                self.date = dateManager.getDateFromWords(date: text.getDateFromString())
                getNews(date: date) {
                    DispatchQueue.main.async {
                        self.startRecognize()
                    }
                }
            } else {
                noDateAlertHandler?()
            }
            HapticsManager.shared.hapticFeedback()
        }
    }
    
    func voiceCloseAlert(text: String) {
        if text.lowercased().contains("закр") {
            resetSpeechRecognition()
            closeAlertHandler?()
            HapticsManager.shared.hapticFeedback()
        }
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
    
    @objc func pastNewsPage() {
        guard let currentPage = newsResponse.currentPage else {return}
        if currentPage > 1 {
            getNews(by: currentPage - 1) {}
        }
    }
    
    @objc func nextNewsPage() {
        guard let currentPage = newsResponse.currentPage, let countPages = newsResponse.countPages else {return}
        if currentPage < countPages {
            getNews(by: currentPage + 1) {}
        }
    }
    
    func checkASPUButtonScreens()-> Bool {
        return settingsManager.loadASPUButtonScreens().contains(ASPUButtonScreens.newsList)
    }
    
    func registerNoDateAlertHandler(block: @escaping()->Void) {
        self.noDateAlertHandler = block
    }
    
    func registerCloseAlertHandler(block: @escaping()->Void) {
        self.closeAlertHandler = block
    }
    
    func registerStartLoadingHandler(block: @escaping()->Void) {
        self.startLoadingHandler = block
    }
    
    func registerDataChangedHandler(block: @escaping(String)->Void) {
        self.dataChangedHandler = block
    }
    
    func registerNewsDateHandler(block: @escaping()->Void) {
        self.newsDateHandler = block
    }
    
    func registerErrorHandler(block: @escaping()->Void) {
        self.errorHandler = block
    }
    
    func registerDislayModeHandler(block: @escaping(DisplayModes)->Void) {
        self.dislayModeHandler = block
    }
    
    func registerWebModeHandler(block: @escaping()->Void) {
        self.webModeHandler = block
    }
    
    func registerNewsRefreshHandler(block: @escaping()->Void) {
        self.newsRefreshHandler = block
    }
    
    func registerWhatsNewHandler(block: @escaping()->Void) {
        self.whatsNewHandler = block
    }
}
