//
//  TimeTableFavouriteItemsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 26.04.2024.
//

import UIKit

protocol TimeTableFavouriteItemsListTableViewControllerDelegate: AnyObject {
    func WasSelected(result: SearchTimetableModel)
}

class TimeTableFavouriteItemsListTableViewController: UITableViewController {

    var isSettings = false
    weak var delegate: TimeTableFavouriteItemsListTableViewControllerDelegate?
    
    // MARK: - сервисы
    let viewModel = TimeTableFavouriteItemsListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        
        let titleView = CustomTitleView(image: "star", title: "Избранное", frame: .zero)
        
        if isSettings {
            let button = UIButton()
            button.tintColor = .label
            button.setImage(UIImage(named: "back"), for: .normal)
            button.addTarget(self, action: #selector(back), for: .touchUpInside)
            
            let backButton = UIBarButtonItem(customView: button)
            
            let addButton = UIBarButtonItem(image: UIImage(named: "add"), style: .done, target: self, action: #selector(addButtonTapped))
            addButton.tintColor = .label
            navigationItem.titleView = titleView
            navigationItem.leftBarButtonItem = nil
            navigationItem.hidesBackButton = true
            navigationItem.leftBarButtonItem = backButton
            navigationItem.rightBarButtonItem = addButton
        } else {
            let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .plain, target: self, action: #selector(closeScreen))
            closeButton.tintColor = .label
            let addButton = UIBarButtonItem(image: UIImage(named: "add"), style: .done, target: self, action: #selector(addButtonTapped))
            addButton.tintColor = .label
            navigationItem.titleView = titleView
            navigationItem.leftBarButtonItem = closeButton
            navigationItem.rightBarButtonItem = addButton
        }
    }
    
    @objc private func back() {
        sendScreenWasClosedNotification()
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
    }
    
    @objc private func addButtonTapped() {
        let vc = TimeTableSearchListTableViewController()
        vc.delegate = self
        vc.isFavourite = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setUpTable() {
        tableView.register(TimeTableFavouriteItemTableViewCell.self, forCellReuseIdentifier: TimeTableFavouriteItemTableViewCell.identifier)
    }
    
    private func bindViewModel() {
        viewModel.getItems()
        viewModel.registerDataChangedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = viewModel.favouriteItem(index: indexPath.row)
            viewModel.deleteItem(item: item)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isSettings {
            let item = viewModel.favouriteItem(index: indexPath.row)
            delegate?.WasSelected(result: item)
            self.dismiss(animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemsCount()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.favouriteItem(index: indexPath.row)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TimeTableFavouriteItemTableViewCell.identifier, for: indexPath) as? TimeTableFavouriteItemTableViewCell else {return UITableViewCell()}
        cell.delegate = self
        cell.configure(item: item)
        return cell
    }
}
