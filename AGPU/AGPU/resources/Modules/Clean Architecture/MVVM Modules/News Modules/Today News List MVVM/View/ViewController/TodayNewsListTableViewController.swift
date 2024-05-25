//
//  TodayNewsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 25.05.2024.
//

import UIKit

class TodayNewsListTableViewController: UIViewController {

    // MARK: - сервисы
    let viewModel = TodayNewsListViewModel()
    
    // MARK: - UI
    let tableView = UITableView()
    private let noNewsLabel = UILabel()
    private let spinner = UIActivityIndicatorView(style: .large)
    
    var isNotify = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpNavigation()
        setUpTable()
        setUpIndicatorView()
        setUpLabel()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        navigationItem.title = "Что нового?"
        let refreshButton = UIBarButtonItem(image: UIImage(named: "refresh"), style: .plain, target: self, action: #selector(refreshNews))
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .plain, target: self, action: #selector(closeScreen))
        refreshButton.tintColor = .label
        closeButton.tintColor = .label
        navigationItem.leftBarButtonItem = refreshButton
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func refreshNews() {
        viewModel.sections = []
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.noNewsLabel.isHidden = true
            self.spinner.startAnimating()
        }
        viewModel.getNews()
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        if isNotify {
            sendScreenWasClosedNotification()
        }
        dismiss(animated: true)
    }
    
    private func setUpTable() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
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
            if !self.viewModel.sections.isEmpty {
                self.noNewsLabel.isHidden = true
            } else {
                self.noNewsLabel.isHidden = false
            }
        }
        viewModel.getNews()
    }
}
