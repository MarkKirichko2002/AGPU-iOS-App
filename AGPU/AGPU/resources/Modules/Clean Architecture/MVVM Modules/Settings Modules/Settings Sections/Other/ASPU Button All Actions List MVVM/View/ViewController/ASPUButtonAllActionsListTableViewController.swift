//
//  ASPUButtonAllActionsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 27.04.2024.
//

import UIKit

protocol ASPUButtonAllActionsListTableViewControllerDelegate: AnyObject {
    func actionWasAdded()
}

class ASPUButtonAllActionsListTableViewController: UITableViewController {

    // MARK: - сервисы
    private let viewModel = ASPUButtonAllActionsListViewModel()
    
    weak var delegate: ASPUButtonAllActionsListTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        
        let titleView = CustomTitleView(image: "plus", title: "Добавить действие", frame: .zero)
        
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        let backButton = UIBarButtonItem(customView: button)
        
        navigationItem.titleView = titleView
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
        viewModel.registerItemSelectedHandler {
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectAction(index: indexPath.row)
        delegate?.actionWasAdded()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.actionsCount()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let action = viewModel.actionItem(index: indexPath.row)
        cell.textLabel?.text = action.rawValue
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        return cell
    }
}
