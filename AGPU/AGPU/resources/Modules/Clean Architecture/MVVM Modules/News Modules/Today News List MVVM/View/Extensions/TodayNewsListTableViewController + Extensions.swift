//
//  TodayNewsListTableViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 25.05.2024.
//

import UIKit

// MARK: - UITableViewDelegate
extension TodayNewsListTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 25))
        header.backgroundColor = .systemBackground
        header.layer.borderWidth = 3
        header.layer.borderColor = UIColor.label.cgColor
        header.layer.cornerRadius = 10
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        header.addSubview(label)
        label.text = viewModel.titleForHeaderInSection(section: section)
        label.textColor = .label
        label.font = .systemFont(ofSize: 17, weight: .black)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: header.topAnchor, constant: 10),
            label.leftAnchor.constraint(equalTo: header.leftAnchor, constant: 20),
            label.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -10),
        ])
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            
            let shareAction = UIAction(title: "Поделиться", image: UIImage(named: "share")) { _ in
                self.shareInfo(image: UIImage(named: "АГПУ")!, title: "\(self.viewModel.newsItemAtSection(section: indexPath.section, index: indexPath.row).title)", text: "\(self.viewModel.makeUrlForCurrentArticle(section: indexPath.section, index: indexPath.row))")
            }
            
            return UIMenu(title: self.viewModel.newsItemAtSection(section: indexPath.section, index: indexPath.row).title, children: [
                shareAction
            ])
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) as? NewsTableViewCell {
            cell.didTapCell(indexPath: indexPath) {
                let vc = NewsWebViewController(article: self.viewModel.newsItemAtSection(section: indexPath.section, index: indexPath.row), url: self.viewModel.makeUrlForCurrentArticle(section: indexPath.section, index: indexPath.row), isNotify: false)
                let navVC = UINavigationController(rootViewController: vc)
                navVC.modalPresentationStyle = .fullScreen
                self.present(navVC, animated: true)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension TodayNewsListTableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView)-> Int {
        return viewModel.numberOfNewsSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfNewsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell else {return UITableViewCell()}
        cell.delegate = self
        cell.configure(article: viewModel.newsItemAtSection(section: indexPath.section, index: indexPath.row))
        return cell
    }
}

// MARK: - NewsTableViewCellDelegate
extension TodayNewsListTableViewController: NewsTableViewCellDelegate {
    
    func imageWasSelected(url: String) {
        let vc = ZoomImageViewController(image: UIImage())
        vc.isURL = true
        vc.url = url
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true)
    }
}
