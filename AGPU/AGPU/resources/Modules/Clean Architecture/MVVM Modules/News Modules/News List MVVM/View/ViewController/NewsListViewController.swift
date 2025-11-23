//
//  NewsListViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 12.08.2023.
//

import UIKit
import WebKit

final class NewsListViewController: UIViewController {
    
    // MARK: - сервисы
    let viewModel = AGPUNewsListViewModel()
    let animation = AnimationClass()
    var buttonSettingsManager: ButtonSettingsManager?
    
    var articles = [Article]()
    
    // MARK: - UI
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(NewsCollectionViewCell.self, forCellWithReuseIdentifier: NewsCollectionViewCell.identifier)
        return collectionView
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        return tableView
    }()
    
    let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }()
    
    let noNewsLabel = UILabel()
    
    var spinner: UIView = {
        let imageView = UIView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpLabel()
        setUpIndicatorView()
        setUpRefreshControl()
        bindViewModel()
        observeFloatingButton()
        setUpButtonSettings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.checkVoiceCommandsOption()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.cancelRecognition()
        buttonSettingsManager?.stopTimer()
    }
    
    private func setUpNavigation() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        setUpRefreshButton()
        setUpMenuButton()
        updateNavigationTitle()
        navigationItem.toggleMenuButton(on: false)
        navigationItem.toggleRefreshButtonFromLeft(on: false)
        setUpNavigationBarGestures()
    }
    
    private func setUpNavigationBarGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(openMenuSettings))
        let swipeLeft = UISwipeGestureRecognizer(target: viewModel, action: #selector(viewModel.pastNewsPage))
        swipeLeft.direction = .left
        let swipeRight = UISwipeGestureRecognizer(target: viewModel, action: #selector(viewModel.nextNewsPage))
        swipeRight.direction = .right
        self.navigationController?.navigationBar.addGestureRecognizer(tap)
        self.navigationController?.navigationBar.addGestureRecognizer(swipeLeft)
        self.navigationController?.navigationBar.addGestureRecognizer(swipeRight)
    }
    
    @objc private func openMenuSettings(gesture: UIGestureRecognizer) {
        let vc = MenuOptionsListTableViewController(category: .newsList)
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
        HapticsManager.shared.hapticFeedback()
    }
    
    private func setUpMenuButton() {
        let options = UIBarButtonItem(image: UIImage(named: "sections"), menu: UIMenu())
        options.accessibilityIdentifier = "menu"
        options.tintColor = .label
        navigationItem.rightBarButtonItem = options
    }
    
    private func setUpRefreshButton() {
        let refreshButton = UIBarButtonItem(image: UIImage(named: "refresh"), style: .plain, target: self, action: #selector(refreshNews))
        refreshButton.accessibilityIdentifier = "refresh button"
        refreshButton.tintColor = .label
        navigationItem.leftBarButtonItem = refreshButton
    }
    
    private func updateMenuButton(menu: UIMenu) {
        guard let options = navigationItem.rightBarButtonItems?.first(where: { $0.accessibilityIdentifier == "menu" }) else {return}
        navigationItem.toggleMenuButton(on: true)
        options.menu = menu
    }
    
    @objc private func refreshNews() {
        setUpIndicatorView()
        switch viewModel.displayMode {
        case .grid:
            viewModel.newsResponse.articles = []
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.noNewsLabel.isHidden = true
            }
            viewModel.refreshNews()
        case .table:
            viewModel.newsResponse.articles = []
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.noNewsLabel.isHidden = true
            }
            viewModel.refreshNews()
        case .webpage:
            viewModel.refreshNews()
        }
    }
    
    func getNews(for page: Int) {
        setUpIndicatorView()
        switch viewModel.displayMode {
        case .grid:
            viewModel.newsResponse.articles = []
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.noNewsLabel.isHidden = true
            }
            viewModel.getNews(by: page) {}
        case .table:
            viewModel.newsResponse.articles = []
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.noNewsLabel.isHidden = true
            }
            viewModel.getNews(by: page) {}
        case .webpage:
            viewModel.getNews(by: page) {}
        }
    }
    
    private func setUpCollectionView() {
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setUpTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setUpWebView() {
        view.addSubview(webView)
        webView.frame = view.bounds
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
        webView.load(viewModel.makeUrlForCurrentWebPage())
    }
    
    func setUpIndicatorView() {
        if view.contains(spinner) {
            spinner.removeFromSuperview()
        }
        spinner = viewModel.getCurrentIndicator()
        view.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            spinner.widthAnchor.constraint(equalToConstant: viewModel.getIndicatorSize().width),
            spinner.heightAnchor.constraint(equalToConstant: viewModel.getIndicatorSize().height)
        ])
        startLoading()
    }
    
    private func setUpRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = viewModel.colorForIndicator()
        refreshControl.accessibilityIdentifier = "refresh control"
        switch viewModel.displayMode {
        case .grid:
            self.collectionView.subviews.first { $0.accessibilityIdentifier == "refresh control"}?.removeFromSuperview()
            collectionView.addSubview(refreshControl)
        case .table:
            self.tableView.subviews.first { $0.accessibilityIdentifier == "refresh control"}?.removeFromSuperview()
            tableView.addSubview(refreshControl)
        case .webpage:
            webView.scrollView.subviews.first { $0.accessibilityIdentifier == "refresh control"}?.removeFromSuperview()
            webView.scrollView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
    }
    
    private func stopRefreshControl() {
        switch viewModel.displayMode {
        case .grid:
            let control = collectionView.subviews.first { $0.accessibilityIdentifier == "refresh control" }
            (control as? UIRefreshControl)?.endRefreshing()
        case .table:
            let control = tableView.subviews.first { $0.accessibilityIdentifier == "refresh control" }
            (control as? UIRefreshControl)?.endRefreshing()
        case .webpage:
            let control = webView.scrollView.subviews.first { $0.accessibilityIdentifier == "refresh control" }
            (control as? UIRefreshControl)?.endRefreshing()
        }
    }
    
    private func setUpLabel() {
        view.addSubview(noNewsLabel)
        noNewsLabel.text = "Нет новостей"
        noNewsLabel.font = .systemFont(ofSize: 18, weight: .medium)
        noNewsLabel.isHidden = true
        noNewsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noNewsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noNewsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func bindViewModel() {
        
        let options = UIBarButtonItem(image: UIImage(named: "sections"), menu: UIMenu())
        options.tintColor = .label
        options.accessibilityIdentifier = "menu"
        
        var titleView = CustomTitleView(image: viewModel.getCurrentCategory().icon, title: "Новости \(viewModel.getCurrentCategory().name)", frame: .zero)
        
        viewModel.checkSettings()
        
        viewModel.registerNoDateAlertHandler {
            let ok = UIAlertAction(title: "ОК", style: .default) { _ in
                self.viewModel.stopSaying()
            }
            self.showInfoAlert(title: "Неверная дата!", message: "не существует такой даты", actions: [ok])
            self.closeAlert()
            self.closeFloatingButtonMenu()
        }
        
        viewModel.registerCloseAlertHandler {
            self.closeAlert()
            self.closeFloatingButtonMenu()
        }
        
        viewModel.registerStartLoadingHandler {
            self.setUpIndicatorView()
            switch self.viewModel.displayMode {
            case .grid:
                self.viewModel.newsResponse.articles = []
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.noNewsLabel.isHidden = true
                }
            case .table:
                self.viewModel.newsResponse.articles = []
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.noNewsLabel.isHidden = true
                }
            case .webpage:
                break
            }
            self.blockUI()
        }
        
        viewModel.registerDataChangedHandler { [weak self] abbreviation in
            
            guard let self = self else { return }
            
            let menu = setUpNewsMenu()
            
            DispatchQueue.main.async {
                if abbreviation != "-" {
                    if let newsCategory = NewsCategories.categories.first(where: { $0.newsAbbreviation == abbreviation }) {
                        titleView = CustomTitleView(image: "\(newsCategory.icon)", title: "\(newsCategory.name) новости", frame: .zero)
                    }
                    self.navigationItem.toggleRefreshButtonFromLeft(on: true)
                    self.stopRefreshControl()
                    self.stopLoading()
                } else {
                    titleView = CustomTitleView(image: "АГПУ", title: "АГПУ новости", frame: .zero)
                    self.navigationItem.toggleRefreshButtonFromLeft(on: true)
                    self.stopRefreshControl()
                    self.stopLoading()
                }
            }
            
            switch viewModel.displayMode {
            
            case .grid:
                DispatchQueue.main.async {
                    self.navigationItem.titleView = titleView
                    self.updateMenuButton(menu: menu)
                    self.collectionView.reloadData()
                }
                
            case .table:
                DispatchQueue.main.async {
                    self.navigationItem.titleView = titleView
                    self.updateMenuButton(menu: menu)
                    self.tableView.reloadData()
                }
                
            case .webpage:
                DispatchQueue.main.async {
                    self.navigationItem.titleView = titleView
                    self.updateMenuButton(menu: menu)
                }
            }
            
            DispatchQueue.main.async {
                if !(self.viewModel.newsResponse.articles?.isEmpty ?? false) {
                    self.noNewsLabel.isHidden = true
                    self.tableView.isHidden = false
                    self.collectionView.isHidden = false
                } else {
                    self.noNewsLabel.isHidden = false
                    self.tableView.isHidden = true
                    self.collectionView.isHidden = true
                }
            }
        }
        
        viewModel.registerNewsDateHandler {
            self.setUpIndicatorView()
            switch self.viewModel.displayMode {
            case .grid:
                self.viewModel.newsResponse.articles = []
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.noNewsLabel.isHidden = true
                }
            case .table:
                self.viewModel.newsResponse.articles = []
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.noNewsLabel.isHidden = true
                }
            case .webpage:
                break
            }
        }
        
        viewModel.registerErrorHandler {
            DispatchQueue.main.async {
                self.noNewsLabel.text = "Нет новостей"
                self.noNewsLabel.isHidden = false
                self.spinner.isHidden = true
                self.animation.stopRotateAnimation(view: self.spinner)
            }
        }
        
        viewModel.registerDislayModeHandler { mode in
            switch mode {
            case .grid:
                DispatchQueue.main.async {
                    self.view.subviews.forEach {
                        if $0 != self.noNewsLabel {$0.removeFromSuperview()}
                    }
                    self.setUpCollectionView()
                    self.setUpIndicatorView()
                    self.setUpRefreshControl()
                    self.spinner.isHidden = true
                    self.animation.stopRotateAnimation(view: self.spinner)
                    self.resetFloatingButton()
                    self.buttonSettingsManager?.checkTimer()
                }
            case .table:
                DispatchQueue.main.async {
                    self.view.subviews.forEach {
                        if $0 != self.noNewsLabel {$0.removeFromSuperview()}
                    }
                    self.setUpTableView()
                    self.setUpIndicatorView()
                    self.setUpRefreshControl()
                    self.spinner.isHidden = true
                    self.animation.stopRotateAnimation(view: self.spinner)
                    self.resetFloatingButton()
                    self.buttonSettingsManager?.checkTimer()
                }
                
            case .webpage:
                DispatchQueue.main.async {
                    self.view.subviews.forEach {
                        if $0 != self.noNewsLabel {$0.removeFromSuperview()}
                    }
                    self.setUpWebView()
                    self.setUpIndicatorView()
                    self.setUpRefreshControl()
                    self.resetFloatingButton()
                    self.buttonSettingsManager?.checkTimer()
                }
            }
        }
        
        viewModel.registerNewsRefreshHandler {
            self.refreshNews()
        }
        
        viewModel.registerWebModeHandler {
            self.webView.load(self.viewModel.makeUrlForCurrentWebPage())
        }
        
        viewModel.registerWhatsNewHandler {
            DispatchQueue.main.async {
                self.showWhatsNewVC()
            }
        }
        
        viewModel.alertHandler = { isPresent, title, message in
            if isPresent {
                let goToSettings = UIAlertAction(title: "Перейти в настройки", style: .default) { _ in
                    self.openSettings()
                }
                let cancel = UIAlertAction(title: "Отмена", style: .cancel) { _ in}
                self.showAlert(title: title, message: message, actions: [goToSettings, cancel])
            }
        }
        
        viewModel.observeCategoryChanges()
        viewModel.observeDisplayMode()
        viewModel.observeStrokeOption()
        viewModel.observeFilterOption()
        viewModel.observeVisualChangesOption()
        viewModel.observeNewsOptionsChanges()
    }
    
    func startLoading() {
        switch viewModel.getIndicator() {
        case .regular:
            self.spinner.isHidden = false
            (self.spinner as? UIActivityIndicatorView)?.startAnimating()
        case .category:
            self.spinner.isHidden = false
            self.animation.startRotateAnimation(view: self.spinner)
        case .date:
            self.spinner.isHidden = false
        case .label:
            self.spinner.isHidden = false
        case .timeOfDay:
            self.spinner.isHidden = false
            self.animation.startRotateAnimation(view: self.spinner)
        case .season:
            self.spinner.isHidden = false
            self.animation.startRotateAnimation(view: self.spinner)
        }
    }
    
    func stopLoading() {
        switch viewModel.getIndicator() {
        case .regular:
            self.spinner.isHidden = true
            (self.spinner as? UIActivityIndicatorView)?.stopAnimating()
        case .category:
            self.spinner.isHidden = true
            self.animation.stopRotateAnimation(view: self.spinner)
        case .date:
            self.spinner.isHidden = true
        case .label:
            self.spinner.isHidden = true
        case .timeOfDay:
            self.spinner.isHidden = true
            self.animation.stopRotateAnimation(view: self.spinner)
        case .season:
            self.spinner.isHidden = true
            self.animation.stopRotateAnimation(view: self.spinner)
        }
    }
    
    private func observeFloatingButton() {
        NotificationCenter.default.addObserver(forName: Notification.Name("floating button news list"), object: nil, queue: .main) { _ in
            self.resetFloatingButton()
        }
    }
    
    private func resetFloatingButton() {
        if let button = view.subviews.first(where: { $0.accessibilityIdentifier == "floating button" }) {
            button.removeFromSuperview()
            createFloatingButton()
        } else {
            createFloatingButton()
        }
    }
    
    private func createFloatingButton() {
        if viewModel.checkASPUButtonScreens() {
            setUpFloatingButton()
            animateFloatingButton()
        }
    }
    
    func removeFloatingButton() {
        if let button = view.subviews.first(where: { $0.accessibilityIdentifier == "floating button" }) {
            button.removeFromSuperview()
        }
    }
    
    private func updateFloatingButton(icon: String) {
        if let button = view.subviews.first(where: { $0.accessibilityIdentifier == "floating button" }) {
            (button as? UIButton)?.setImage(UIImage(named: icon), for: .normal)
        }
    }
    
    private func animateFloatingButton() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            if let button = self.view.subviews.first(where: { $0.accessibilityIdentifier == "floating button" }) {
                self.animation.springAnimation(view: button)
                HapticsManager.shared.hapticFeedback()
            }
        }
    }
    
    func updateNavigationTitle() {
        navigationItem.titleView = CustomTitleView(image: "loading", title: "Загрузка...", frame: .zero)
    }
    
    private func setUpFloatingButton() {
        let navigationButton = UIButton()
        navigationButton.tintColor = .label
        navigationButton.setImage(UIImage(named: viewModel.getCurrentCategoryIcon()), for: .normal)
        navigationButton.showsMenuAsPrimaryAction = true
        navigationButton.accessibilityIdentifier = "floating button"
        navigationButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationButton)
        NSLayoutConstraint.activate([
            navigationButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -tabBarController!.tabBar.frame.height-17),
            navigationButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30.0),
            navigationButton.widthAnchor.constraint(equalToConstant: 70.0),
            navigationButton.heightAnchor.constraint(equalToConstant: 70.0)
        ])
        navigationButton.menu = setUpButtonNewsMenu()
    }
    
    func setUpButtonNewsMenu()-> UIMenu {
        
        let categories = UIMenu(title: "Категории", children: NewsCategories.categories.map({ category in
            UIAction(title: category.name, state: category.newsAbbreviation == self.viewModel.abbreviation ? .on : .off) { _ in
                if category.newsAbbreviation != self.viewModel.abbreviation {
                    switch self.viewModel.displayMode {
                    case .grid:
                        self.viewModel.newsResponse.articles = []
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                            self.noNewsLabel.isHidden = true
                        }
                        self.updateNavigationTitle()
                        self.viewModel.getNewsFromMenu(category: category.newsAbbreviation)
                        self.navigationItem.toggleRefreshButtonFromLeft(on: false)
                        self.navigationItem.toggleMenuButton(on: false)
                        self.setUpIndicatorView()
                        self.removeFloatingButton()
                    case .table:
                        self.viewModel.newsResponse.articles = []
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            self.noNewsLabel.isHidden = true
                        }
                        self.updateNavigationTitle()
                        self.viewModel.getNewsFromMenu(category: category.newsAbbreviation)
                        self.navigationItem.toggleRefreshButtonFromLeft(on: false)
                        self.navigationItem.toggleMenuButton(on: false)
                        self.setUpIndicatorView()
                        self.removeFloatingButton()
                    case .webpage:
                        self.updateNavigationTitle()
                        self.viewModel.getNewsFromMenu(category: category.newsAbbreviation)
                        self.navigationItem.toggleRefreshButtonFromLeft(on: false)
                        self.navigationItem.toggleMenuButton(on: false)
                        self.setUpIndicatorView()
                        self.removeFloatingButton()
                    }
                }
            }
        }).reversed())
        
        let pages = UIMenu(title: "Страницы", children: viewModel.makePagesList().map ({ page in
            UIAction(title: "Страница: \(page)", state: page == self.viewModel.newsResponse.currentPage ? .on : .off) { _ in
                if page != self.viewModel.newsResponse.currentPage {
                    switch self.viewModel.displayMode {
                    case .grid:
                        self.viewModel.newsResponse.articles = []
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                            self.noNewsLabel.isHidden = true
                        }
                        self.updateNavigationTitle()
                        self.viewModel.getNews(by: page) {}
                        self.navigationItem.toggleRefreshButtonFromLeft(on: false)
                        self.navigationItem.toggleMenuButton(on: false)
                        self.setUpIndicatorView()
                        self.removeFloatingButton()
                    case .table:
                        self.viewModel.newsResponse.articles = []
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            self.noNewsLabel.isHidden = true
                        }
                        self.updateNavigationTitle()
                        self.viewModel.getNews(by: page) {}
                        self.navigationItem.toggleRefreshButtonFromLeft(on: false)
                        self.navigationItem.toggleMenuButton(on: false)
                        self.setUpIndicatorView()
                        self.removeFloatingButton()
                    case .webpage:
                        self.updateNavigationTitle()
                        self.viewModel.getNews(by: page) {}
                        self.navigationItem.toggleRefreshButtonFromLeft(on: false)
                        self.navigationItem.toggleMenuButton(on: false)
                        self.setUpIndicatorView()
                        self.removeFloatingButton()
                    }
                }
            }
        }).reversed())
        
        return UIMenu(title: "Новости", children: [pages, categories])
    }
    
    func setUpNewsMenu()-> UIMenu {
        let savedOptions = viewModel.getSavedNewsOptions()
        let options = savedOptions.map { findOption(option: $0) }
        return UIMenu(title: "Новости", children: options)
    }
    
    func getAllOptions()-> [UIAction] {
        
        let calendarAction = UIAction(title: "Поиск") { _ in
            self.openMonthsList()
        }
        
        let categoriesAction = UIAction(title: "Категории") { _ in
            self.openNewsCategoriesList()
        }
        
        let whatsNewAction = UIAction(title: "Что нового?") { _ in
            self.showWhatsNewVC()
        }
        
        let pagesAction = UIAction(title: "Страницы") { _ in
            self.openNewsPagesList()
        }
        
        let recentNews = UIAction(title: "Недавние") { _ in
            let vc = RecentNewsListViewController()
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        let displayModes = UIAction(title: "Вид") { _ in
            let vc = DisplayModeOptionsListTableViewController(option: self.viewModel.displayMode)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        let filterOptions = UIAction(title: "Фильтрация") { _ in
            self.openFilterOptionsList()
        }
        
        let randomAction = UIAction(title: "Рандомайзер") { _ in
            self.openRandom()
        }
        
        let selectAction = UIAction(title: "Выбрать") { _ in
            let vc = NewsMultipleSelectionListTableViewController(articles: self.viewModel.allNews, abbreviation: self.viewModel.abbreviation)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        let voiceCommands = UIAction(title: "Голосовые команды") { _ in
            let vc = VoiceCommandsListTableViewController(type: .newsList)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        let settingsAction = UIAction(title: "Настройки") { _ in
            let vc = AdaptiveNewsOptionsListTableViewController()
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        return [
            calendarAction,
            categoriesAction,
            whatsNewAction,
            pagesAction,
            recentNews,
            displayModes,
            filterOptions,
            randomAction,
            selectAction,
            voiceCommands,
            settingsAction
        ]
    }
    
    func findOption(option: MenuOptionModel)-> UIAction  {
        let originalOptions = getAllOptions()
        let searchOption = NewsOptions.list.first(where: { $0.name == option.name })!
        let item = originalOptions.first { $0.title == searchOption.name }!
        return item
    }
    
    func openNewsCategoriesList() {
        let vc = NewsCategoriesListTableViewController(currentCategory: viewModel.abbreviation)
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true)
    }
    
    func openNewsPagesList() {
        if let currentPage = self.viewModel.newsResponse.currentPage, let countPages = self.viewModel.newsResponse.countPages {
            if countPages > 1 {
                let vc = NewsPagesListTableViewController(currentPage: currentPage, countPages: countPages, abbreviation: viewModel.abbreviation)
                vc.delegate = self
                let navVC = UINavigationController(rootViewController: vc)
                navVC.modalPresentationStyle = .fullScreen
                self.present(navVC, animated: true)
            } else {
                showAlert(title: "Нет страниц", message: "страницы еще не загрузились", actions: [UIAlertAction(title: "ОК", style: .default)])
            }
        }
    }
    
    func openMonthsList() {
        let vc = NewsFilterCategoriesListTableViewController(date: viewModel.date, month: viewModel.month)
        vc.delegate = self
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
    
    func openRandom() {
        let vc = NewsCategoriesRandomizerViewController(category: self.viewModel.abbreviation)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    func openFilterOptionsList() {
        let vc = NewsOptionsFilterListTableViewController(option: self.viewModel.option, news: self.viewModel.allNews)
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true)
    }
    
    private func setUpButtonSettings() {
        self.buttonSettingsManager = ButtonSettingsManager(screen: .newsList, view: self.view)
    }
}
