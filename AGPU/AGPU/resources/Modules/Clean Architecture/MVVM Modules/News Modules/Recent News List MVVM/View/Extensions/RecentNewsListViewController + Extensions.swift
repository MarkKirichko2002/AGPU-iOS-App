//
//  RecentNewsListViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 12.03.2024.
//

import UIKit

// MARK: - UITableViewDelegate
extension RecentNewsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteArticle(id: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            
            let shareAction = UIAction(title: "Поделиться", image: UIImage(named: "share")) { _ in
                self.shareInfo(image: UIImage(named: "АГПУ")!, title: "\(self.viewModel.articleItem(index: indexPath.row).title)", text: "\(self.viewModel.makeUrlForCurrentArticle(index: indexPath.row))")
            }
            
            return UIMenu(title: self.viewModel.articleItem(index: indexPath.row).title, children: [
                shareAction
            ])
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) as? NewsTableViewCell {
            cell.didTapCell(indexPath: indexPath)
        }
        
        Timer.scheduledTimer(withTimeInterval: 1.1, repeats: false) { _ in
            let vc = NewsWebViewController(article: self.viewModel.articleItem(index: indexPath.row), url: self.viewModel.makeUrlForCurrentArticle(index: indexPath.row), isNotify: false)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension RecentNewsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell else {fatalError()}
        cell.configure(article: viewModel.articleItem(index: indexPath.row))
        return cell
    }
}
