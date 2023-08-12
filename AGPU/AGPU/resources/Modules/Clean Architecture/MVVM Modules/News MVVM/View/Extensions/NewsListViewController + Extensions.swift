//
//  NewsListViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 12.08.2023.
//

import UIKit

// MARK: - UICollectionViewDataSource
extension NewsListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.newsResponse.articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCollectionViewCell.identifier, for: indexPath) as? NewsCollectionViewCell else {return UICollectionViewCell()}
        cell.configure(with: viewModel.articleItem(index: indexPath.row))
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension NewsListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                                 contextMenuConfigurationForItemAt indexPath: IndexPath,
                                 point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            
            let infoAction = UIAction(title: "узнать больше", image: UIImage(named: "info")) { _ in
               
            }
            
            let shareAction = UIAction(title: "поделиться", image: UIImage(named: "share")) { _ in
                
            }
            
            return UIMenu(title: self.viewModel.articleItem(index: indexPath.row).title ?? "", children: [
                infoAction,
                shareAction
            ])
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension NewsListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)-> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width - 30) / 2
        return CGSize(width: width, height: width * 1.5)
    }
}
