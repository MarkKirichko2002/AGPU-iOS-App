//
//  AGPUWallpapersListViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 13.07.2023.
//

import UIKit

final class AGPUWallpapersListViewController: UIViewController {
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(AGPUWallpaperCollectionViewCell.self, forCellWithReuseIdentifier: AGPUWallpaperCollectionViewCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpCollectionView()
    }
    
    private func setUpNavigation() {
        
        let titleView = CustomTitleView(image: "новый год", title: "АГПУ Обои", frame: .zero)
        
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        let backButton = UIBarButtonItem(customView: button)
        
        navigationItem.titleView = titleView
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func back() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            NotificationCenter.default.post(name: Notification.Name("screen was closed"), object: nil)
        }
        navigationController?.popViewController(animated: true)
    }
    
    private func setUpCollectionView() {
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}
