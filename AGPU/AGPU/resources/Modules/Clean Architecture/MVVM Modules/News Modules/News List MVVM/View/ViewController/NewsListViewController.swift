//
//  NewsListViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 12.08.2023.
//

import UIKit

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
    
    private let spinner = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpCollectionView()
        setUpIndicatorView()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        navigationItem.title = "Новости АГПУ"
        let refreshButton = UIBarButtonItem(image: UIImage(named: "refresh"), style: .plain, target: self, action: #selector(refreshNews))
        refreshButton.tintColor = .label
        navigationItem.leftBarButtonItem = refreshButton
    }
    
    @objc private func refreshNews() {
        viewModel.refreshNews()
    }
    
    private func setUpCollectionView() {
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        collectionView.delegate = self
        collectionView.dataSource = self
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
    
    private func bindViewModel() {
        
        var options = UIBarButtonItem(image: UIImage(named: "sections"), menu: UIMenu())
        
        var menu = UIMenu()
        
        var categoriesAction = UIAction(title: "Категории") { _ in}
        var pagesAction = UIAction(title: "Страницы") { _ in}
        
        var titleView = CustomTitleView(image: "АГПУ", title: "Новости АГПУ", frame: .zero)
        
        DispatchQueue.main.async {
            self.navigationItem.title = "Загрузка новостей..."
            options = UIBarButtonItem(image: UIImage(named: "sections"), menu: UIMenu())
            options.tintColor = .label
            self.navigationItem.rightBarButtonItem = options
        }
        
        viewModel.getNewsByCurrentType()
        
        viewModel.registerCategoryChangedHandler { [weak self] abbreviation in
            
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                
                if abbreviation != "" {
                    if let faculty = AGPUFaculties.faculties.first(where: { $0.newsAbbreviation == abbreviation }) {
                        titleView = CustomTitleView(image: "\(faculty.icon)", title: "\(faculty.abbreviation) новости", frame: .zero)
                        self.spinner.stopAnimating()
                    }
                } else {
                    titleView = CustomTitleView(image: "АГПУ", title: "АГПУ новости", frame: .zero)
                    self.spinner.stopAnimating()
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
                
                menu = UIMenu(title: "Новости", children: [categoriesAction, pagesAction])
                options = UIBarButtonItem(image: UIImage(named: "sections"), menu: menu)
                options.tintColor = .label
                self.navigationItem.titleView = titleView
                self.navigationItem.rightBarButtonItem = options
                self.collectionView.reloadData()
            }
        }
        
        viewModel.observeCategoryChanges()
        viewModel.observePageChanges()
    }
}
