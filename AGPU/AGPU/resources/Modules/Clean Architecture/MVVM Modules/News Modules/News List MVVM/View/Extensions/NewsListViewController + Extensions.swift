//
//  NewsListViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 12.08.2023.
//

import UIKit
import WebKit

// MARK: - UICollectionViewDelegate
extension NewsListViewController: UICollectionViewDelegate {
        
    func collectionView(_ collectionView: UICollectionView,
                                 contextMenuConfigurationForItemAt indexPath: IndexPath,
                                 point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            
            let ARAction = UIAction(title: "AR режим", image: UIImage(named: "cube")) { _ in
                self.viewModel.getArticleInfo(id: indexPath.row) { info in
                    self.goToAR(images: info.images)
                }
            }
            
            let infoAction = UIAction(title: "Подробнее", image: UIImage(named: "info")) { _ in
                self.viewModel.getArticleInfo(id: indexPath.row) { info in
                    self.showAlert(title: "Информация о новости", message: "всего предложений: \(info.description.countSentences()) \n всего слов: \(info.description.countWords())", actions: [UIAlertAction(title: "ОК", style: .default)])
                }
            }
            
            let searchAction = UIAction(title: "Поиск слова", image: UIImage(named: "search")) { _ in
                self.viewModel.getArticleInfo(id: indexPath.row) { info in
                    self.showSearchWordAlert(index: indexPath.row, desc: info.description)
                }
            }
            
            let shareAction = UIAction(title: "Поделиться", image: UIImage(named: "share")) { _ in
                self.shareInfo(image: UIImage(named: "АГПУ")!, title: "\(self.viewModel.articleItem(index: indexPath.row).title)", text: "\(self.viewModel.makeUrlForCurrentArticle(index: indexPath.row))")
            }
            
            return UIMenu(title: self.viewModel.articleItem(index: indexPath.row).title, children: [
                ARAction,
                infoAction,
                searchAction,
                shareAction
            ])
        }
    }
    
    @objc func showSearchWordAlert(index: Int, desc: String) {
        
        let alertVC = UIAlertController(title: "Поиск слова", message: "Введите слово для поиска", preferredStyle: .alert)
        
        alertVC.addTextField { (textField) in
            textField.placeholder = "Введите слово"
        }
        
        let saveAction = UIAlertAction(title: "Найти", style: .default) { _ in
            if let word = alertVC.textFields![0].text {
                if self.viewModel.searchWord(word: word, desc: desc) {
                    let openArticle = UIAlertAction(title: "Открыть", style: .default) { _ in
                        Timer.scheduledTimer(withTimeInterval: 1.2, repeats: false) { _ in
                            let vc = NewsWebViewController(article: self.viewModel.articleItem(index: index), url: self.viewModel.makeUrlForCurrentArticle(index: index), isNotify: true)
                            let navVC = UINavigationController(rootViewController: vc)
                            navVC.modalPresentationStyle = .fullScreen
                            self.present(navVC, animated: true)
                        }
                    }
                    self.showAlert(title: "Найдено слово!", message: "слово \(word) есть в новости", actions: [openArticle, UIAlertAction(title: "Отмена", style: .default)])
                } else {
                    self.showAlert(title: "Слово не найдено", message: "слова \(word) нет в новости", actions: [UIAlertAction(title: "ОК", style: .default)])
                }
            }
        }
        
        let cancel = UIAlertAction(title: "Отмена", style: .destructive)
        
        alertVC.addAction(saveAction)
        alertVC.addAction(cancel)
        
        SpeechSynthesizerManager.shared.checkIsSaying(text: "\(alertVC.title ?? "") \(alertVC.message ?? "")")
        present(alertVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? NewsCollectionViewCell {
            cell.didTapCell(indexPath: indexPath)
        }
        
        viewModel.sendNotificationArticleWasSelected()
        
        Timer.scheduledTimer(withTimeInterval: 1.2, repeats: false) { _ in
            let vc = NewsWebViewController(article: self.viewModel.articleItem(index: indexPath.row), url: self.viewModel.makeUrlForCurrentArticle(index: indexPath.row), isNotify: true)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension NewsListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.newsResponse.articles?.count ?? 0
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

// MARK: - UITableViewDelegate
extension NewsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            
            let ARAction = UIAction(title: "AR режим", image: UIImage(named: "cube")) { _ in
                self.viewModel.getArticleInfo(id: indexPath.row) { info in
                    self.goToAR(images: info.images)
                }
            }
            
            let infoAction = UIAction(title: "Подробнее", image: UIImage(named: "info")) { _ in
                self.viewModel.getArticleInfo(id: indexPath.row) { info in
                    self.showAlert(title: "Информация о новости", message: "всего предложений: \(info.description.countSentences()) \n всего слов: \(info.description.countWords())", actions: [UIAlertAction(title: "ОК", style: .default)])
                }
            }
            
            let searchAction = UIAction(title: "Поиск слова", image: UIImage(named: "search")) { _ in
                self.viewModel.getArticleInfo(id: indexPath.row) { info in
                    self.showSearchWordAlert(index: indexPath.row, desc: info.description)
                }
            }
            
            let shareAction = UIAction(title: "Поделиться", image: UIImage(named: "share")) { _ in
                self.shareInfo(image: UIImage(named: "АГПУ")!, title: "\(self.viewModel.articleItem(index: indexPath.row).title)", text: "\(self.viewModel.makeUrlForCurrentArticle(index: indexPath.row))")
            }
            
            return UIMenu(title: self.viewModel.articleItem(index: indexPath.row).title, children: [
                ARAction,
                infoAction,
                searchAction,
                shareAction
            ])
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) as? NewsTableViewCell {
            cell.didTapCell(indexPath: indexPath)
        }
        
        viewModel.sendNotificationArticleWasSelected()
        
        Timer.scheduledTimer(withTimeInterval: 1.2, repeats: false) { _ in
            let vc = NewsWebViewController(article: self.viewModel.articleItem(index: indexPath.row), url: self.viewModel.makeUrlForCurrentArticle(index: indexPath.row), isNotify: true)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension NewsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.newsResponse.articles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell else {fatalError()}
        cell.delegate = self
        cell.configure(article: viewModel.articleItem(index: indexPath.row))
        return cell
    }
}

// MARK: - WKNavigationDelegate
extension NewsListViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        DispatchQueue.main.async {
            self.startLoading()
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.async {
            self.stopLoading()
        }
    }
}

// MARK: - NewsTableViewCellDelegate
extension NewsListViewController: NewsTableViewCellDelegate {
    
    func imageWasSelected(url: String) {
        let vc = ZoomImageViewController(image: UIImage())
        vc.isURL = true
        vc.url = url
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true)
    }
}

extension NewsListViewController {
    
    func goToAR(images: [String]) {
        if !images.isEmpty {
            let vc = NewsARViewController()
            vc.urls = images
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self.present(navVC, animated: true)
            }
        } else {
            self.showAlert(title: "Нет изображений", message: "у данной новости нет изображений", actions: [UIAlertAction(title: "ОК", style: .default)])
        }
    }
}
