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
    
    // MARK: - UI
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(NewsCollectionViewCell.self, forCellWithReuseIdentifier: NewsCollectionViewCell.identifier)
        return collectionView
    }()
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }()
    
    private let noNewsLabel = UILabel()
    
    private let spinner = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpCollectionView()
        setUpIndicatorView()
        setUpLabel()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        navigationItem.title = "Новости АГПУ"
        let refreshButton = UIBarButtonItem(image: UIImage(named: "refresh"), style: .plain, target: self, action: #selector(refreshNews))
        refreshButton.tintColor = .label
        navigationItem.leftBarButtonItem = refreshButton
    }
    
    @objc private func refreshNews() {
        viewModel.newsResponse.articles = []
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.noNewsLabel.isHidden = true
            self.spinner.startAnimating()
        }
        viewModel.refreshNews()
    }
    
    private func setUpCollectionView() {
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setUpWebView() {
        view.addSubview(webView)
        view = webView
        webView.load(viewModel.makeUrlForCurrentWebPage())
    }
    
    private func setUpIndicatorView() {
        view.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        spinner.startAnimating()
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
        var pagesAction = UIAction(title: "Страницы") { _ in}
        let displayModes = UIAction(title: "Отображение") { _ in
            let vc = DisplayModeOptionsListTableViewController(option: self.viewModel.displayMode)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        let recentNews = UIAction(title: "Недавние") { _ in
            let vc = RecentNewsListViewController()
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        let filterOptions = UIAction(title: "Фильтрация") { _ in
            print(self.viewModel.option)
            let vc = NewsOptionsFilterListTableViewController(option: self.viewModel.option)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        let randomAction = UIAction(title: "Рандомайзер") { _ in
            let vc = NewsCategoriesRandomizerViewController(category: self.viewModel.abbreviation)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
        
        var titleView = CustomTitleView(image: "АГПУ", title: "Новости АГПУ", frame: .zero)
        
        DispatchQueue.main.async {
            self.navigationItem.title = "Загрузка новостей..."
        }
        
        viewModel.checkSettings()
        
        viewModel.registerCategoryChangedHandler { [weak self] abbreviation in
            
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if abbreviation != "-" {
                    if let newsCategory = NewsCategories.categories.first(where: { $0.newsAbbreviation == abbreviation }) {
                        titleView = CustomTitleView(image: "\(newsCategory.icon)", title: "\(newsCategory.name) новости", frame: .zero)
                        self.spinner.stopAnimating()
                    }
                } else {
                    titleView = CustomTitleView(image: "АГПУ", title: "АГПУ новости", frame: .zero)
                    self.spinner.stopAnimating()
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
            
            menu = UIMenu(title: "Новости", children: [
                categoriesAction,
                pagesAction,
                displayModes,
                recentNews,
                filterOptions,
                randomAction
            ])
            options = UIBarButtonItem(image: UIImage(named: "sections"), menu: menu)
            options.tintColor = .label
            
            DispatchQueue.main.async {
                self.navigationItem.titleView = titleView
                self.navigationItem.rightBarButtonItem = options
                self.collectionView.reloadData()
            }
            
            DispatchQueue.main.async {
                if !(self.viewModel.newsResponse.articles?.isEmpty ?? false) {
                    self.noNewsLabel.isHidden = true
                } else {
                    self.noNewsLabel.isHidden = false
                }
            }
        }
        
        viewModel.registerDislayModeHandler { mode in
            switch mode {
            case .grid:
                self.webView.removeFromSuperview()
                self.setUpCollectionView()
            case .webpage:
                self.collectionView.removeFromSuperview()
                self.view = nil
                self.setUpWebView()
            }
        }
        
        viewModel.registerWebModeHandler {
            self.webView.load(self.viewModel.makeUrlForCurrentWebPage())
        }
        
        viewModel.observeCategoryChanges()
        viewModel.observePageChanges()
        viewModel.observeDisplayMode()
        viewModel.observeStrokeOption()
        viewModel.observeFilterOption()
    }
}
