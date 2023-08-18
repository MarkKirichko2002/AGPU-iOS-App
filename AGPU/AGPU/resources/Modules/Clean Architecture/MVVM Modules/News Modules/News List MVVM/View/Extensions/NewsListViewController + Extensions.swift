//
//  NewsListViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 12.08.2023.
//

import UIKit

// MARK: - UICollectionViewDelegate
extension NewsListViewController: UICollectionViewDelegate {
        
    func collectionView(_ collectionView: UICollectionView,
                                 contextMenuConfigurationForItemAt indexPath: IndexPath,
                                 point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            
            let infoAction = UIAction(title: "узнать больше", image: UIImage(named: "info")) { _ in
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                    if let cell = collectionView.cellForItem(at: indexPath) as? NewsCollectionViewCell {
                        cell.didTapCell(indexPath: indexPath)
                    }
                }
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
                    self.GoToWeb(url: "\(self.viewModel.makeUrlForCurrentArticle(index: indexPath.row))", title: "\(self.viewModel.articleItem(index: indexPath.row).date ?? "")", isSheet: false)
                }
            }
            
            let shareAction = UIAction(title: "поделиться", image: UIImage(named: "share")) { _ in
                self.shareInfo(image: UIImage(named: self.viewModel.faculty?.icon ?? "АГПУ")!, title: "\(self.viewModel.articleItem(index: indexPath.row).title ?? "")", text: "\(self.viewModel.makeUrlForCurrentArticle(index: indexPath.row))")
            }
            
            return UIMenu(title: self.viewModel.articleItem(index: indexPath.row).title ?? "", children: [
                infoAction,
                shareAction
            ])
        }
    }
}

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

// MARK: - UICollectionViewDelegateFlowLayout
extension NewsListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)-> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width - 30) / 2
        return CGSize(width: width, height: width * 1.5)
    }
}