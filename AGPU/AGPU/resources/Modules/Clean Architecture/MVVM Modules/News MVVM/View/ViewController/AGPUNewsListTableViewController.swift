//
//  AGPUNewsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 08.08.2023.
//

import UIKit

class AGPUNewsListTableViewController: UITableViewController {

    // MARK: - сервисы
    private let viewModel = AGPUNewsListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUpNavigation()
        SetUpTable()
        BindViewModel()
    }
    
    private func SetUpNavigation() {
        navigationItem.title = "Новости"
    }
    
    private func SetUpTable() {
        tableView.register(UINib(nibName: NewsTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: NewsTableViewCell.identifier)
    }
    
    private func BindViewModel() {
        viewModel.GetNews()
        viewModel.registerDataChangedHandler { faculty in
            if faculty != nil {
                DispatchQueue.main.async {
                    self.navigationItem.title = "Новости \(faculty?.abbreviation ?? "")"
                    self.tableView.reloadData()
                }
            } else {
                DispatchQueue.main.async {
                    self.navigationItem.title = "Новости АГПУ"
                    self.tableView.reloadData()
                }
            }
        }
        viewModel.ObserveFacultyChanges()
    }
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil,
                                          actionProvider: {
            _ in
            
            let infoAction = UIAction(title: "узнать больше", image: UIImage(named: "info")) { _ in
                self.GoToWeb(url: self.viewModel.urlForCurrentArticle(index: indexPath.row), title: "\(self.viewModel.articleItem(index: indexPath.row).date ?? "")", isSheet: false)
            }
            
            let shareAction = UIAction(title: "поделиться", image: UIImage(named: "share")) { _ in
                self.shareInfo(image: UIImage(named: "АГПУ")!, title: self.viewModel.articleItem(index: indexPath.row).title ?? "", text: self.viewModel.urlForCurrentArticle(index: indexPath.row))
            }
            
            return UIMenu(title: self.viewModel.articleItem(index: indexPath.row).title ?? "", children: [
                infoAction,
                shareAction
            ])
        })
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.newsResponse.articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell else {return UITableViewCell()}
        cell.configure(news: viewModel.articleItem(index: indexPath.row))
        return cell
    }
}
