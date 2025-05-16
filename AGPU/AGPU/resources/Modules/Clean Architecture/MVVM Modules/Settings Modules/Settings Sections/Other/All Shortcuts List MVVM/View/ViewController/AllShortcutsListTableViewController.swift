//
//  AllShortcutsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 07.12.2024.
//

import UIKit

protocol AllShortcutsListTableViewControllerDelegate: AnyObject {
    func shortcutWasAdded()
}

final class AllShortcutsListTableViewController: UITableViewController {

    // MARK: - сервисы
    private let viewModel = AllShortcutsListViewModel()
    var selectedShortcuts = [ShortcutModel]()
    
    weak var delegate: AllShortcutsListTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        let titleView = CustomTitleView(image: "sections icon", title: "Шорткаты", frame: .zero)
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
        for i in 0..<viewModel.shortcutsCount() {
            tableView.deselectRow(at: IndexPath(row: i, section: 0), animated: true)
        }
        selectedShortcuts = []
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
            self.delegate?.shortcutWasAdded()
        }
        viewModel.registerAlertHandler { title, message in
            self.showAlert(title: title, message: message, actions: [UIAlertAction(title: "ОК", style: .default)])
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let id = selectedShortcuts.firstIndex { $0.title == viewModel.shortcutItem(index: indexPath.row).title } ?? 0
        selectedShortcuts.remove(at: id)
        checkSelection()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !tableView.isEditing {
            viewModel.selectShortcut(index: indexPath.row)
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            selectedShortcuts.append(viewModel.shortcutItem(index: indexPath.row))
            checkSelection()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.shortcutsCount()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let shortcut = viewModel.shortcutItem(index: indexPath.row)
        cell.textLabel?.text = shortcut.title
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        return cell
    }
    
    func checkSelection() {
        if selectedShortcuts.isEmpty {
            setUpEditButton(title: "Отмена")
        } else {
            setUpChooseButton()
            setUpCancelButton(title: "Отмена")
        }
    }
    
    func setUpChooseButton() {
        let moveButton = UIBarButtonItem(title: "Выбрать", style: .done, target: self, action: #selector(addShortcuts))
        moveButton.tintColor = .label
        navigationItem.rightBarButtonItem = moveButton
    }
    
    @objc private func addShortcuts() {
        viewModel.saveShortcuts(shortcuts: selectedShortcuts)
        delegate?.shortcutWasAdded()
    }
}
