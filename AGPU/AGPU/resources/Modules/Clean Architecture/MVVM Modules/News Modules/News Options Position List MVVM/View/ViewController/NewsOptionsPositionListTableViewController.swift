//
//  NewsOptionsPositionListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 16.06.2024.
//

import UIKit

class NewsOptionsPositionListTableViewController: UITableViewController {

    var isSettings = false
    
    // MARK: - сервисы
    private let viewModel = NewsOptionsPositionListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        setUpNavigationTitle()
        if isSettings {
            setUpBackButton()
        } else {
            setUpCloseButton()
        }
        setUpEditButton(title: "Править")
    }
    
    func setUpNavigationTitle() {
        navigationItem.title = "Порядок опций"
    }
    
    func setUpCloseButton() {
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .done, target: self, action: #selector(close))
        closeButton.tintColor = .label
        navigationItem.leftBarButtonItem = closeButton
    }
    
    func setUpBackButton() {
        
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        let backButton = UIBarButtonItem(customView: button)
        
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func close() {
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
    }
    
    func setUpEditButton(title: String) {
        let moveButton = UIBarButtonItem(title: title, style: .done, target: self, action: #selector(moveOptions))
        moveButton.tintColor = .label
        navigationItem.rightBarButtonItem = moveButton
    }
    
    @objc private func moveOptions() {
        if tableView.isEditing {
            setUpEditButton(title: "Править")
            tableView.isEditing = false
        } else {
            setUpEditButton(title: "Готово")
            tableView.isEditing = true
        }
    }
    
    private func setUpTable() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func bindViewModel() {
        viewModel.registerDataChangedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { _ in
            self.viewModel.getData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if tableView.isEditing {
            viewModel.saveNewsOptionsPosition(sourceIndexPath.row, destinationIndexPath.row)
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.options.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.options[indexPath.row].name
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        return cell
    }
}
