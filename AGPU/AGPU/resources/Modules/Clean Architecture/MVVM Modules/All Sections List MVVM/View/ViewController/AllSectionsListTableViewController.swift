//
//  AllSectionsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 23.09.2024.
//

import UIKit

protocol AllSectionsListTableViewControllerDelegate: AnyObject {
    func sectionWasAdded()
}

final class AllSectionsListTableViewController: UITableViewController {

    private let viewModel = AllSectionsListViewModel()
    var selectedSections = [ForEveryStatusModel]()
    
    weak var delegate: AllSectionsListTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
        setUpNavigation()
        bindViewModel()
    }
    
    private func setUpTable() {
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.register(ForEveryStatusTableViewCell.self, forCellReuseIdentifier: ForEveryStatusTableViewCell.identifier)
    }
    
    private func setUpNavigation() {
        let titleView = CustomTitleView(image: "sections icon", title: "Разделы", frame: .zero)
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
            setUpEditButton(title: "Выбрать")
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
        for i in 0..<viewModel.sectionsCount() {
            tableView.deselectRow(at: IndexPath(row: i, section: 0), animated: true)
        }
        selectedSections = []
        setUpBackButton()
        setUpEditButton(title: "Выбрать")
        tableView.isEditing = false
    }
    
    private func bindViewModel() {
        viewModel.registerItemSelectedHandler {
            DispatchQueue.main.async {
                self.back()
            }
        }
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let id = selectedSections.firstIndex { $0.id == viewModel.sectionItem(index: indexPath.row).id } ?? 0
        selectedSections.remove(at: id)
        checkSelection()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !tableView.isEditing {
            viewModel.selectSection(index: indexPath.row)
            delegate?.sectionWasAdded()
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            selectedSections.append(viewModel.sectionItem(index: indexPath.row))
            checkSelection()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sectionsCount()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.sectionItem(index: indexPath.row)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ForEveryStatusTableViewCell.identifier, for: indexPath) as? ForEveryStatusTableViewCell else {return UITableViewCell()}
        cell.configure(for: item)
        return cell
    }
    
    func checkSelection() {
        if selectedSections.isEmpty {
            setUpEditButton(title: "Отмена")
        } else {
            setUpChooseButton()
            setUpCancelButton(title: "Отмена")
        }
    }
    
    func setUpChooseButton() {
        let moveButton = UIBarButtonItem(title: "Выбрать", style: .done, target: self, action: #selector(addSections))
        moveButton.tintColor = .label
        navigationItem.rightBarButtonItem = moveButton
    }
    
    @objc private func addSections() {
        viewModel.saveSections(sections: selectedSections)
        delegate?.sectionWasAdded()
    }
}
