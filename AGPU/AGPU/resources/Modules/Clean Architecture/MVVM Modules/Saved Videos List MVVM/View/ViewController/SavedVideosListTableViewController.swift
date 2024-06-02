//
//  SavedVideosListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 02.06.2024.
//

import UIKit

protocol SavedVideosListTableViewControllerDelegate: AnyObject {
    func listUpdated()
}

class SavedVideosListTableViewController: UIViewController {

    // MARK: - сервисы
    let viewModel = SavedVideosListViewModel()
    
    // MARK: - UI
    let tableView = UITableView()
    private let noVideosLabel = UILabel()
    
    weak var delegate: SavedVideosListTableViewControllerDelegate?
    var video = VideoModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        setUpLabel()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        
        let titleView = CustomTitleView(image: "play icon", title: "Видео", frame: .zero)
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        let backButton = UIBarButtonItem(customView: button)
        
        let addButton = UIBarButtonItem(image: UIImage(named: "add"), style: .done, target: self, action: #selector(showAddVideoAlert))
        addButton.tintColor = .label
        
        navigationItem.titleView = titleView
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setUpTable() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SavedVideoTableViewCell.self, forCellReuseIdentifier: SavedVideoTableViewCell.identifier)
    }
    
    private func setUpLabel() {
        view.addSubview(noVideosLabel)
        noVideosLabel.text = "Нет видео"
        noVideosLabel.font = .systemFont(ofSize: 18, weight: .medium)
        noVideosLabel.isHidden = true
        noVideosLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noVideosLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noVideosLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.registerDataChangedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            if !self.viewModel.videos.isEmpty {
                self.noVideosLabel.isHidden = true
            } else {
                self.noVideosLabel.isHidden = false
            }
            self.delegate?.listUpdated()
        }
        viewModel.getVideos()
    }
}
