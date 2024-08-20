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
    
    var articles = [Article]()
    
    // MARK: - UI
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(NewsCollectionViewCell.self, forCellWithReuseIdentifier: NewsCollectionViewCell.identifier)
        return collectionView
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        return tableView
    }()
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }()
    
    private let noNewsLabel = UILabel()
    
    var spinner: UIView = {
        let imageView = UIView()
        imageView.tintColor = .label
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpLabel()
        setUpIndicatorView()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        setUpRefreshButton()
    }
    
    private func setUpRefreshButton() {
        let refreshButton = UIBarButtonItem(image: UIImage(named: "refresh"), style: .plain, target: self, action: #selector(refreshNews))
        refreshButton.tintColor = .label
        navigationItem.leftBarButtonItem = refreshButton
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
    
    private func setUpCollectionView() {
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        collectionView.delegate = self
        collectionView.dataSource = self
        spinner.tintColor = .label
    }
    
    private func setUpTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        spinner.tintColor = .label
    }
    
    private func setUpWebView() {
        view.addSubview(webView)
        webView.frame = view.bounds
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
        spinner.tintColor = .black
        webView.load(viewModel.makeUrlForCurrentWebPage())
    }
    
    private func setUpIndicatorView() {
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
        
        var options = UIBarButtonItem(image: UIImage(named: "sections"), menu: UIMenu())
        
        var menu = UIMenu()
        
        var categoriesAction = UIAction(title: "Категории") { _ in}
        
        let whatsNewAction = UIAction(title: "Что нового?") { _ in
            self.showWhatsNewVC()
        }
        
        let gesturesAction = UIAction(title: "Жесты") { _ in
            let vc = HandDrawingGesturesViewController(category: self.viewModel.abbreviation, page: self.viewModel.newsResponse.currentPage ?? 0)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
        
        var pagesAction = UIAction(title: "Страницы") { _ in}
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
            print(self.viewModel.option)
            let vc = NewsOptionsFilterListTableViewController(option: self.viewModel.option, news: self.viewModel.allNews)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        let randomAction = UIAction(title: "Рандомайзер") { _ in
            let vc = NewsCategoriesRandomizerViewController(category: self.viewModel.abbreviation)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
        
        let selectAction = UIAction(title: "Выбрать") { _ in
            let vc = NewsMultipleSelectionListTableViewController(articles: self.viewModel.allNews, abbreviation: self.viewModel.abbreviation)
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
        
        var titleView = CustomTitleView(image: "АГПУ", title: "Новости АГПУ", frame: .zero)
        
        DispatchQueue.main.async {
            self.navigationItem.title = "Загрузка новостей..."
        }
        
        viewModel.checkSettings()
        
        viewModel.registerDataChangedHandler { [weak self] abbreviation in
            
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if abbreviation != "-" {
                    if let newsCategory = NewsCategories.categories.first(where: { $0.newsAbbreviation == abbreviation }) {
                        titleView = CustomTitleView(image: "\(newsCategory.icon)", title: "\(newsCategory.name) новости", frame: .zero)
                    }
                    self.stopLoading()
                } else {
                    titleView = CustomTitleView(image: "АГПУ", title: "АГПУ новости", frame: .zero)
                    self.stopLoading()
                }
            }
            
            categoriesAction = UIAction(title: "Категории") { _ in
                let vc = NewsCategoriesListTableViewController(currentCategory: abbreviation)
                let navVC = UINavigationController(rootViewController: vc)
                navVC.modalPresentationStyle = .fullScreen
                self.present(navVC, animated: true)
            }
            
            pagesAction = UIAction(title: "Страницы") { _ in
                if let currentPage = self.viewModel.newsResponse.currentPage, let countPages = self.viewModel.newsResponse.countPages {
                    let vc = NewsPagesListTableViewController(currentPage: currentPage, countPages: countPages, abbreviation: abbreviation)
                    let navVC = UINavigationController(rootViewController: vc)
                    navVC.modalPresentationStyle = .fullScreen
                    self.present(navVC, animated: true)
                }
            }
            
            var opt: [UIMenuElement] = [
                categoriesAction,
                whatsNewAction,
                gesturesAction,
                pagesAction,
                recentNews,
                displayModes,
                filterOptions,
                randomAction,
                selectAction,
                settingsAction
            ]
            
            let position = UserDefaults.standard.object(forKey: "news options position") as? [Int] ?? [0,1,2,3,4,5,6,7,8,9]
            
            for option in opt {
                for number in position {
                    let index = opt.firstIndex(of: option)!
                    print("индекс: \(index) позиция: \(number)")
                    opt.swapAt(index, number)
                }
            }
            
            menu = UIMenu(title: "Новости", children: opt)
            options = UIBarButtonItem(image: UIImage(named: "sections"), menu: menu)
            options.tintColor = .label
            
            switch viewModel.displayMode {
                
            case .grid:
                DispatchQueue.main.async {
                    self.navigationItem.titleView = titleView
                    self.navigationItem.rightBarButtonItem = options
                    self.collectionView.reloadData()
                }
                
            case .table:
                DispatchQueue.main.async {
                    self.navigationItem.titleView = titleView
                    self.navigationItem.rightBarButtonItem = options
                    self.tableView.reloadData()
                }
                
            case .webpage:
                DispatchQueue.main.async {
                    self.navigationItem.titleView = titleView
                    self.navigationItem.rightBarButtonItem = options
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
        
        viewModel.registerArticleInfoChangedHandler { info in
            let vc = NewsARViewController()
            vc.urls = info.images
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self.present(navVC, animated: true)
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
                    self.spinner.isHidden = true
                    self.animation.stopRotateAnimation(view: self.spinner)
                }
            case .table:
                DispatchQueue.main.async {
                    self.view.subviews.forEach {
                        if $0 != self.noNewsLabel {$0.removeFromSuperview()}
                    }
                    self.setUpTableView()
                    self.setUpIndicatorView()
                    self.spinner.isHidden = true
                    self.animation.stopRotateAnimation(view: self.spinner)
                }
                
            case .webpage:
                DispatchQueue.main.async {
                    self.view.subviews.forEach {
                        if $0 != self.noNewsLabel {$0.removeFromSuperview()}
                    }
                    self.setUpWebView()
                    self.setUpIndicatorView()
                }
            }
        }
        
        viewModel.registerWebModeHandler {
            self.webView.load(self.viewModel.makeUrlForCurrentWebPage())
        }
        
        viewModel.registerWhatsNewHandler {
            DispatchQueue.main.async {
                self.showWhatsNewVC()
            }
        }
        
        viewModel.observeCategoryChanges()
        viewModel.observePageChanges()
        viewModel.observeDisplayMode()
        viewModel.observeStrokeOption()
        viewModel.observeFilterOption()
        viewModel.observeVisualChangesOption()
        viewModel.observePositionOption()
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
        case .status:
            self.spinner.isHidden = false
            self.animation.startRotateAnimation(view: self.spinner)
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
        case .status:
            self.spinner.isHidden = true
            self.animation.stopRotateAnimation(view: self.spinner)
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
}
