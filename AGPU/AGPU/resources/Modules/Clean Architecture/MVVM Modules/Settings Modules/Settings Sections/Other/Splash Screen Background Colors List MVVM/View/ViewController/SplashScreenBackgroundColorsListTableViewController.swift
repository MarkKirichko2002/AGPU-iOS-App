//
//  SplashScreenBackgroundColorsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 20.04.2024.
//

import UIKit

protocol SplashScreenBackgroundColorsListTableViewControllerDelegate: AnyObject {
    func colorWasSelected(color: Colors)
}

class SplashScreenBackgroundColorsListTableViewController: UITableViewController {
    
    // MARK: - сервисы
    private let viewModel = SplashScreenBackgroundColorsListViewModel()
    
    weak var delegate: SplashScreenBackgroundColorsListTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        navigationItem.title = "Выберите цвет"
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .plain, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .label
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
    }
    
    private func setUpTable() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func bindViewModel() {
        viewModel.registerColorSelectedHandler { colorItem in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            self.delegate?.colorWasSelected(color: colorItem)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectColor(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.colorsCount()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let colorOption = viewModel.colorOptionItem(index: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.tintColor = viewModel.isColorSelected(index: indexPath.row) ? colorOption.color : .label
        cell.textLabel?.text = colorOption.title
        cell.textLabel?.textColor = viewModel.isColorSelected(index: indexPath.row) ? colorOption.color : .label
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        cell.accessoryType = viewModel.isColorSelected(index: indexPath.row) ? .checkmark : .none
        return cell
    }
}
