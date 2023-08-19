//
//  NewsListViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 12.08.2023.
//

import UIKit

final class NewsListViewController: UIViewController {
    
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
    
    // MARK: - сервисы
    let viewModel = AGPUNewsListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUpNavigation()
        SetUpSwipeGesture()
        SetUpCollectionView()
        BindViewModel()
    }
    
    private func SetUpNavigation() {
        
        navigationItem.title = "Новости АГПУ"
    }
    
    private func SetUpCollectionView() {
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func BindViewModel() {
        
        var options = UIBarButtonItem(image: UIImage(named: "sections"), menu: UIMenu())
        
        var menu = UIMenu()
        
        var categoriesAction = UIAction(title: "категории") { _ in}
        var pagesAction = UIAction(title: "страницы") { _ in}
        
        var titleView = CustomTitleView(image: "АГПУ", title: "Новости АГПУ", frame: .zero)
        
        DispatchQueue.main.async {
            self.navigationItem.title = "загрузка новостей..."
            self.collectionView.reloadData()
            options = UIBarButtonItem(image: UIImage(named: "sections"), menu: UIMenu())
            options.tintColor = .black
            self.navigationItem.rightBarButtonItem = options
        }
        
        viewModel.GetNewsByCurrentType()
        
        viewModel.registerDataChangedHandler { [weak self] faculty in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                
                if let faculty = faculty {
                    titleView = CustomTitleView(image: "\(faculty.icon)", title: "\(faculty.abbreviation) новости", frame: .zero)
                    self.collectionView.reloadData()
                } else {
                    titleView = CustomTitleView(image: "АГПУ", title: "АГПУ новости", frame: .zero)
                    self.collectionView.reloadData()
                }
                
                categoriesAction = UIAction(title: "категории") { _ in
                    let vc = NewsCategoriesListTableViewController(currentCategory: faculty?.abbreviation ?? "АГПУ")
                    let navVC = UINavigationController(rootViewController: vc)
                    navVC.modalPresentationStyle = .fullScreen
                    self.present(navVC, animated: true)
                }
                
                 pagesAction = UIAction(title: "страницы") { _ in
                     if let currentPage = self.viewModel.newsResponse.currentPage, let countPages = self.viewModel.newsResponse.countPages {
                         let vc = NewsPagesListTableViewController(currentPage: currentPage, countPages: countPages)
                        let navVC = UINavigationController(rootViewController: vc)
                        navVC.modalPresentationStyle = .fullScreen
                        self.present(navVC, animated: true)
                     }
                }
                
                menu = UIMenu(title: "новости", children: [categoriesAction, pagesAction])
                options = UIBarButtonItem(image: UIImage(named: "sections"), menu: menu)
                options.tintColor = .black
                self.navigationItem.titleView = titleView
                self.navigationItem.rightBarButtonItem = options
            }
        }
        
        viewModel.ObserveFacultyChanges()
        viewModel.ObservedPageChanges()
    }
}
