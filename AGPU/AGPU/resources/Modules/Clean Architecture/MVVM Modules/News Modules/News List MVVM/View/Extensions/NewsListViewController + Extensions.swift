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
            
            let item = self.viewModel.articleItem(index: indexPath.row)
            
            if item.id == 0 || item.id == 1 {
                return nil
            } else {
                return self.makeMenu(index: indexPath.row)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item = viewModel.articleItem(index: indexPath.row)
        
        if item.id == 0 || item.id == 1 {
            if let cell = collectionView.cellForItem(at: indexPath) as? NewsCollectionViewCell {
                cell.didTapCell(indexPath: indexPath) {
                    self.getNews(for: (self.viewModel.newsResponse.currentPage ?? 0) + 1)
                }
            }
        } else {
            if let cell = collectionView.cellForItem(at: indexPath) as? NewsCollectionViewCell {
                cell.didTapCell(indexPath: indexPath) {
                    let vc = NewsWebViewController(article: item, url: self.viewModel.makeUrlForCurrentArticle(index: indexPath.row), isNotify: false)
                    let navVC = UINavigationController(rootViewController: vc)
                    navVC.modalPresentationStyle = .fullScreen
                    self.present(navVC, animated: true)
                }
            }
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
            
            let item = self.viewModel.articleItem(index: indexPath.row)
            
            if item.id == 0 || item.id == 1 {
                return nil
            } else {
                return self.makeMenu(index: indexPath.row)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = viewModel.articleItem(index: indexPath.row)
        
        if item.id == 0 || item.id == 1 {
            if let cell = tableView.cellForRow(at: indexPath) as? NewsTableViewCell {
                cell.didTapCell(indexPath: indexPath) {
                    self.getNews(for: (self.viewModel.newsResponse.currentPage ?? 0) + 1)
                }
            }
        } else {
            if let cell = tableView.cellForRow(at: indexPath) as? NewsTableViewCell {
                cell.didTapCell(indexPath: indexPath) {
                    let vc = NewsWebViewController(article: item, url: self.viewModel.makeUrlForCurrentArticle(index: indexPath.row), isNotify: false)
                    let navVC = UINavigationController(rootViewController: vc)
                    navVC.modalPresentationStyle = .fullScreen
                    self.present(navVC, animated: true)
                }
            }
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

// MARK: - NewsFilterCategoriesListTableViewControllerDelegate
extension NewsListViewController: NewsFilterCategoriesListTableViewControllerDelegate {
    
    func dateFromCalendarWasSelected(date: String) {
        viewModel.getNews(date: date) {}
    }
    
    func monthWasSelected(month: Month) {
        viewModel.getMonthNews(month: month)
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
    
    func makeMenu(index: Int)-> UIMenu {
        if UserDefaults.standard.object(forKey: "onAdvancedModeNews") as? Bool ?? false {
            return makeAdvancedMenu(index: index)
        } else {
            return makeSimpleMenu(index: index)
        }
    }
    
    func makeAdvancedMenu(index: Int)-> UIMenu {
        
        let ARAction = UIAction(title: "AR режим", image: UIImage(named: "cube")) { _ in
            self.viewModel.getArticleInfo(id: index) { info in
                self.goToAR(images: info.images)
            }
        }
        
        let shareAction = UIAction(title: "Поделиться", image: UIImage(named: "share")) { _ in
            self.shareInfo(image: UIImage(named: "АГПУ")!, title: "\(self.viewModel.articleItem(index: index).title)", text: "\(self.viewModel.makeUrlForCurrentArticle(index: index))")
        }
        
        return UIMenu(title: self.viewModel.articleItem(index: index).title, children: [
            ARAction,
            shareAction
        ])
    }
    
    func blockUI() {
        updateNavigationTitle()
        removeFloatingButton()
        navigationItem.toggleRefreshButtonFromLeft(on: false)
        navigationItem.toggleMenuButton(on: false)
    }
    
    func makeSimpleMenu(index: Int)-> UIMenu {
        
        let shareAction = UIAction(title: "Поделиться", image: UIImage(named: "share")) { _ in
            self.shareInfo(image: UIImage(named: "АГПУ")!, title: "\(self.viewModel.articleItem(index: index).title)", text: "\(self.viewModel.makeUrlForCurrentArticle(index: index))")
        }
        
        return UIMenu(title: self.viewModel.articleItem(index: index).title, children: [
            shareAction
        ])
    }
    
    func showInfoAlert(title: String, message: String, actions: [UIAlertAction]) {
        let isSaying = UserDefaults.standard.object(forKey: "isSaying") as? Bool ?? false
        if isSaying {
            showAlert(title: title, message: message, actions: actions)
        } else {
            viewModel.resetSpeechRecognition()
            showAlert(title: title, message: message, actions: actions)
        }
    }
    
    func closeFloatingButtonMenu() {
        if let button = view.subviews.first(where: { $0.accessibilityIdentifier == "floating button" }) {
            if (button as? UIButton)!.isHeld {
                self.dismiss(animated: true)
            }
        }
    }
}
