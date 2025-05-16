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

final class ASPUButtonAllActionsListTableViewController: UITableViewController {

    // MARK: - сервисы
    private let viewModel = ASPUButtonAllActionsListViewModel()
    var selectedActions = [ASPUButtonActions]()
    
    weak var delegate: ASPUButtonAllActionsListTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        let titleView = CustomTitleView(image: "plus", title: "Действия", frame: .zero)
        navigationItem.titleView = titleView
        setUpBackButton()
        setUpEditButton(title: "Выбрать")
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
    
    func setUpEditButton(title: String) {
        let moveButton = UIBarButtonItem(title: title, style: .done, target: self, action: #selector(choose))
        moveButton.tintColor = .label
        navigationItem.rightBarButtonItem = moveButton
    }
    
    @objc private func choose() {
        if tableView.isEditing {
            setUpEditButton(title: "Править")
            tableView.isEditing = false
        } else {
            setUpEditButton(title: "Отмена")
            tableView.isEditing = true
        }
    }
    
    func setUpCancelButton(title: String) {
        let moveButton = UIBarButtonItem(title: title, style: .done, target: self, action: #selector(cancel))
        moveButton.tintColor = .label
        navigationItem.leftBarButtonItem = moveButton
    }
    
    @objc private func cancel() {
        for i in 0..<viewModel.actionsCount() {
            tableView.deselectRow(at: IndexPath(row: i, section: 0), animated: true)
        }
        selectedActions = []
        setUpBackButton()
        setUpEditButton(title: "Выбрать")
        tableView.isEditing = false
    }
    
    private func setUpTable() {
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func bindViewModel() {
        viewModel.registerItemSelectedHandler {
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let id = selectedActions.firstIndex { $0 == viewModel.actionItem(index: indexPath.row) } ?? 0
        selectedActions.remove(at: id)
        checkSelection()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !tableView.isEditing {
            viewModel.selectAction(index: indexPath.row)
            delegate?.actionWasAdded()
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            selectedActions.append(viewModel.actionItem(index: indexPath.row))
            delegate?.actionWasAdded()
            checkSelection()
        }
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
    
    func checkSelection() {
        if selectedActions.isEmpty {
            setUpEditButton(title: "Отмена")
        } else {
            setUpChooseButton()
            setUpCancelButton(title: "Отмена")
        }
    }
    
    func setUpChooseButton() {
        let moveButton = UIBarButtonItem(title: "Выбрать", style: .done, target: self, action: #selector(addActions))
        moveButton.tintColor = .label
        navigationItem.rightBarButtonItem = moveButton
    }
    
    @objc private func addActions() {
        viewModel.saveActions(actions: selectedActions)
        delegate?.actionWasAdded()
    }
}
