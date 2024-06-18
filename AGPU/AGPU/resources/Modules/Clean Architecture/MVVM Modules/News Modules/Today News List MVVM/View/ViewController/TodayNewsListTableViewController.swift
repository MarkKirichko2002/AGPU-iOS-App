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
    let animation = AnimationClass()
    
    // MARK: - UI
    let tableView = UITableView()
    
    private let noNewsLabel = UILabel()
    
    private let spinner: SpringImageView = {
        let imageView = SpringImageView()
        imageView.image = UIImage(named: "mail icon")
        imageView.tintColor = .label
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
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
        let titleView = CustomTitleView(image: "question", title: "Что нового?", frame: .zero)
        let refreshButton = UIBarButtonItem(image: UIImage(named: "refresh"), style: .plain, target: self, action: #selector(refreshNews))
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .plain, target: self, action: #selector(closeScreen))
        refreshButton.tintColor = .label
        closeButton.tintColor = .label
        navigationItem.titleView = titleView
        navigationItem.leftBarButtonItem = refreshButton
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func refreshNews() {
        viewModel.sections = []
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.noNewsLabel.isHidden = true
            self.spinner.isHidden = false
            self.animation.startRotateAnimation(view: self.spinner)
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
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        self.spinner.isHidden = false
        self.animation.startRotateAnimation(view: self.spinner)
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
                self.spinner.isHidden = true
                self.animation.stopRotateAnimation(view: self.spinner)
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
