//
//  RecentNewsListViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 12.03.2024.
//

import UIKit

// MARK: - UICollectionViewDelegate
extension RecentNewsListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? NewsCollectionViewCell {
            cell.didTapCell(indexPath: indexPath)
        }
        
        Timer.scheduledTimer(withTimeInterval: 1.1, repeats: false) { _ in
            let vc = NewsWebViewController(article: self.viewModel.articleItem(index: indexPath.row), url: self.viewModel.makeUrlForCurrentArticle(index: indexPath.row))
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        contextMenuConfigurationForItemAt indexPath: IndexPath,
                        point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            
            let resetAction = UIAction(title: "Сбросить позицию", image: UIImage(named: "refresh")) { _ in
                let alertVC = UIAlertController(title: "Сбросить позицию чтения", message: "Вы уверены что хотите сбросить позицию чтения?", preferredStyle: .alert)
                let ok = UIAlertAction(title: "ОК", style: .default) { _ in
                    self.viewModel.resetProgress(id: indexPath.row)
                }
                let cancel = UIAlertAction(title: "Отмена", style: .destructive)
                alertVC.addAction(ok)
                alertVC.addAction(cancel)
                self.present(alertVC, animated: true)
            }
            
            let deleteAction = UIAction(title: "Удалить", image: UIImage(named: "delete")) { _ in
                self.viewModel.deleteArticle(id: indexPath.row)
            }
            
            let shareAction = UIAction(title: "Поделиться", image: UIImage(named: "share")) { _ in
                self.shareInfo(image: UIImage(named: "АГПУ")!, title: "\(self.viewModel.articleItem(index: indexPath.row).title)", text: "\(self.viewModel.makeUrlForCurrentArticle(index: indexPath.row))")
            }
            
            return UIMenu(title: self.viewModel.articleItem(index: indexPath.row).title, children: [
                resetAction,
                deleteAction,
                shareAction
            ])
        }
    }
}

// MARK: - UICollectionViewDataSource
extension RecentNewsListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.news.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCollectionViewCell.identifier, for: indexPath) as? NewsCollectionViewCell else {return UICollectionViewCell()}
        cell.configure(with: viewModel.articleItem(index: indexPath.row))
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension RecentNewsListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)-> CGSize {
        let bounds = collectionView.bounds
        let width: CGFloat
        if UIDevice.isiPhone {
            width = (bounds.width - 30)/2
        } else {
            width = (bounds.width - 50)/4
        }
        return CGSize(
            width: width,
            height: width * 1.5
        )
    }
}
