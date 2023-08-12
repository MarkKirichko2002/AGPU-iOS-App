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
        
        var menu = UIMenu()
        
        DispatchQueue.main.async {
            self.navigationItem.title = "загрузка новостей..."
            self.collectionView.reloadData()
            let pages = UIBarButtonItem(image: UIImage(named: "sections"), menu: menu)
            pages.tintColor = .black
            self.navigationItem.rightBarButtonItem = pages
        }
        
        viewModel.GetNewsByCurrentType()
        
        viewModel.registerDataChangedHandler { [weak self] faculty in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let faculty = faculty {
                    self.navigationItem.title = "Новости \(faculty.abbreviation)"
                    self.collectionView.reloadData()
                } else {
                    self.navigationItem.title = "Новости АГПУ"
                    self.collectionView.reloadData()
                }
                
                menu = self.viewModel.pagesMenu()
                let pages = UIBarButtonItem(image: UIImage(named: "sections"), menu: menu)
                pages.tintColor = .black
                self.navigationItem.rightBarButtonItem = pages
            }
        }
        
        viewModel.ObserveFacultyChanges()
    }
}
