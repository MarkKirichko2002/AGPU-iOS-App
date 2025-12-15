//
//  OnlyMainVariantsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 07.05.2024.
//

import UIKit

protocol OnlyMainVariantsListTableViewControllerDelegate: AnyObject {
    func tabsWasChanged()
}

final class OnlyMainVariantsListTableViewController: UITableViewController {

    // MARK: - сервисы
    private let viewModel = OnlyMainVariantsListViewModel()
    
    weak var delegate: OnlyMainVariantsListTableViewControllerDelegate?
    
    var isChanged = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        bindViewModel()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isChanged {
            delegate?.tabsWasChanged()
        }
    }

    private func setUpNavigation() {
        let titleView = CustomTitleView(image: "choose", title: "Варианты вкладок", frame: .zero)
        navigationItem.titleView = titleView
        setUpCloseButton()
    }
    
    func setUpCloseButton() {
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .done, target: self, action: #selector(close))
        closeButton.tintColor = .label
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func close() {
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
    }
    
    private func setUpTable() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func bindViewModel() {
        viewModel.registerOnlyMainVariantSelectedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.chooseOnlyMainVariant(index: indexPath.row)
        if viewModel.onlyMainVariantItem(index: indexPath.row) == .custom {
            let vc = TabsOptionsListTableViewController()
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
        isChanged = true
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfVariantsInSection()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let variant = viewModel.onlyMainVariantItem(index: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.tintColor = .systemGreen
        cell.textLabel?.text = variant.rawValue
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        cell.textLabel?.textColor = viewModel.isCurrentOnlyMainVariant(index: indexPath.row) ? .systemGreen : .label
        cell.accessoryType = viewModel.isCurrentOnlyMainVariant(index: indexPath.row) ? .checkmark : .none
        return cell
    }
}

// MARK: - TabsOptionsListTableViewControllerDelegate
extension OnlyMainVariantsListTableViewController: TabsOptionsListTableViewControllerDelegate {
    func optionWasChanged() {
        isChanged = true
    }
}
