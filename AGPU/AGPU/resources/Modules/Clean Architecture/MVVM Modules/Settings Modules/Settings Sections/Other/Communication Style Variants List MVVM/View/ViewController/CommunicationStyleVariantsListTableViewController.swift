//
//  CommunicationStyleVariantsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 12.07.2024.
//

import UIKit

protocol CommunicationStyleVariantsListTableViewControllerDelegate: AnyObject {
    func styleWasSelected()
}

final class CommunicationStyleVariantsListTableViewController: UITableViewController {

    // MARK: - сервисы
    private let viewModel = CommunicationStyleVariantsListViewModel()
    
    weak var delegate: CommunicationStyleVariantsListTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        let backButton = UIBarButtonItem(customView: button)
        
        let titleView = CustomTitleView(image: "message", title: "Стили общения", frame: .zero)
        
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
        viewModel.registerDataChangedHandler {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectStyle(index: indexPath.row)
        delegate?.styleWasSelected()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.stylesCount()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let style = viewModel.styleItem(index: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.tintColor = .systemGreen
        cell.textLabel?.text = style.rawValue
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        cell.textLabel?.textColor = viewModel.isStyleSelected(index: indexPath.row) ? .systemGreen : .label
        cell.accessoryType = viewModel.isStyleSelected(index: indexPath.row) ? .checkmark : .none
        return cell
    }
}
