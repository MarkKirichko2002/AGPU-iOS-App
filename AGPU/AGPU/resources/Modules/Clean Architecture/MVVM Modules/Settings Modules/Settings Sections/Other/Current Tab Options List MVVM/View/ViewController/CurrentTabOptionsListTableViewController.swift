//
//  CurrentTabOptionsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 13.12.2024.
//

import UIKit

protocol CurrentTabOptionsListTableViewControllerDelegate: AnyObject {
    func optionWasAdded()
}

final class CurrentTabOptionsListTableViewController: UITableViewController {

    // MARK: - сервисы
    private let viewModel: CurrentTabOptionsListViewModel
    var selectedOptions = [TabOptionModel]()
    
    weak var delegate: CurrentTabOptionsListTableViewControllerDelegate?
    
    var currentTitle: String
    
    init(title: String) {
        self.viewModel = CurrentTabOptionsListViewModel(title: title)
        self.currentTitle = title
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        navigationItem.title = currentTitle.getCurrentTabName()
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
        for i in 0..<viewModel.optionsCount() {
            tableView.deselectRow(at: IndexPath(row: i, section: 0), animated: true)
        }
        selectedOptions = []
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
            self.delegate?.optionWasAdded()
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let id = selectedOptions.firstIndex { $0.title == viewModel.optionItem(index: indexPath.row).title } ?? 0
        selectedOptions.remove(at: id)
        checkSelection()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !tableView.isEditing {
            viewModel.selectOption(index: indexPath.row)
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            selectedOptions.append(viewModel.optionItem(index: indexPath.row))
            checkSelection()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.optionsCount()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let shortcut = viewModel.optionItem(index: indexPath.row)
        cell.textLabel?.text = shortcut.title
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        return cell
    }
    
    func checkSelection() {
        if selectedOptions.isEmpty {
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
        viewModel.saveOptions(options: selectedOptions)
        delegate?.optionWasAdded()
    }
}
