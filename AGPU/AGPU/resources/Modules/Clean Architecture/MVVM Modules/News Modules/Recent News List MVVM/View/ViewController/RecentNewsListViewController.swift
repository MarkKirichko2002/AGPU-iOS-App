//
//  RecentNewsListViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 12.03.2024.
//

import UIKit

final class RecentNewsListViewController: UIViewController {
    
    // MARK: - сервисы
    let viewModel = RecentNewsListViewModel()
    
    // MARK: - UI
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        return tableView
    }()
    
    private let noNewsLabel = UILabel()
    
    private let spinner = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTableView()
        setUpIndicatorView()
        setUpLabel()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        let titleView = CustomTitleView(image: "time", title: "Недавние новости", frame: .zero)
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .plain, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .label
        navigationItem.titleView = titleView
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
    }
    
    private func setUpTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        spinner.color = .label
    }
    
    private func setUpIndicatorView() {
        view.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        spinner.startAnimating()
    }
    
    private func setUpLabel() {
        view.addSubview(noNewsLabel)
        noNewsLabel.text = "Нет новостей"
        noNewsLabel.font = .systemFont(ofSize: 18, weight: .medium)
        noNewsLabel.isHidden = true
        noNewsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noNewsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noNewsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.registerDataChangedHandler {
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                self.tableView.reloadData()
            }
            if !self.viewModel.news.isEmpty {
                self.noNewsLabel.isHidden = true
            } else {
                self.noNewsLabel.isHidden = false
            }
        }
        viewModel.getNews()
    }
}
