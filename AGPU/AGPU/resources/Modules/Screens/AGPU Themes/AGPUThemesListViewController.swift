//
//  AGPUThemesListViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 13.07.2023.
//

import UIKit

class AGPUThemesListViewController: UIViewController {

    var themes = [
        "agpu1",
        "agpu2",
        "agpu3",
        "agpu4"
    ]
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(AGPUThemeCollectionViewCell.self, forCellWithReuseIdentifier: AGPUThemeCollectionViewCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "АГПУ темы"
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}
