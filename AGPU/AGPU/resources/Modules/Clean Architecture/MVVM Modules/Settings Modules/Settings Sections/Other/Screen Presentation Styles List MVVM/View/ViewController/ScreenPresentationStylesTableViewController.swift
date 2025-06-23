//
//  ScreenPresentationStylesTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 27.05.2024.
//

import UIKit

class ScreenPresentationStylesTableViewController: UITableViewController {

    // MARK: - сервисы
    private let viewModel = ScreenPresentationStylesListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        let titleView = CustomTitleView(image: "eye", title: viewModel.titleForNavigation(), frame: .zero)
        navigationItem.titleView = titleView
        setUpBackButton()
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
    
    private func setUpTable() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func bindViewModel() {
        viewModel.registerDataChangedHandler {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectPresentationStyle(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.presentationStyleItemsCount()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let style = viewModel.presentationStyleItem(index: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.tintColor = .systemGreen
        cell.textLabel?.text = style.rawValue
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        cell.textLabel?.textColor = viewModel.isPresentationStyleSelected(index: indexPath.row) ? .systemGreen : .label
        cell.accessoryType = viewModel.isPresentationStyleSelected(index: indexPath.row) ? .checkmark : .none
        return cell
    }
}
