//
//  RecentNewsListViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 12.03.2024.
//

import UIKit

final class RecentNewsListViewController: UIViewController {
    
    // MARK: - сервисы
    let viewModel = RecentNewsListViewModel()
    
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
        navigationItem.title = "Недавние новости"
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .plain, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .label
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
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
        viewModel.registerDataChangedHandler {
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                self.collectionView.reloadData()
            }
            if !self.viewModel.news.isEmpty {
                self.noNewsLabel.isHidden = true
            } else {
                self.noNewsLabel.isHidden = false
            }
        }
        viewModel.getNews()
    }
}
