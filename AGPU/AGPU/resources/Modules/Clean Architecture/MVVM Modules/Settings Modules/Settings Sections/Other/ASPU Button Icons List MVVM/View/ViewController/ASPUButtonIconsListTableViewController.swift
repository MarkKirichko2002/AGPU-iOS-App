//
//  ASPUButtonIconsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 30.03.2024.
//

import UIKit

class ASPUButtonIconsListTableViewController: UITableViewController {

    // MARK: - сервисы
    private let viewModel = ASPUButtonIconsListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        
        let titleView = CustomTitleView(image: "photo icon", title: "Выберите иконку", frame: .zero)
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
        tableView.register(UINib(nibName: ASPUButtonIconTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ASPUButtonIconTableViewCell.identifier)
    }
    
    private func bindViewModel() {
        
        viewModel.getSelectedFacultyData()
        
        viewModel.registerDataChangedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        viewModel.registerIconSelectedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        viewModel.registerAlertHandler { title, message in
            let ok = UIAlertAction(title: "OK", style: .default)
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertVC.addAction(ok)
            self.present(alertVC, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectASPUButtonIcon(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfASPUButtonIcons()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let icon = viewModel.ASPUButtonIconItem(index: indexPath.row)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ASPUButtonIconTableViewCell.identifier, for: indexPath) as? ASPUButtonIconTableViewCell else {return UITableViewCell()}
        cell.ASPUButtonIconName.textColor = viewModel.isASPUButtonIconSelected(index: indexPath.row) ? .systemGreen : .label
        cell.accessoryType = viewModel.isASPUButtonIconSelected(index: indexPath.row) ? .checkmark : .none
        cell.configure(icon: icon)
        return cell
    }
}
