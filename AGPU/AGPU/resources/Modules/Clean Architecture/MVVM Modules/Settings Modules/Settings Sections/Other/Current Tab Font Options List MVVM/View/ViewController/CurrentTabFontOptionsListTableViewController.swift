//
//  CurrentTabFontOptionsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 16.12.2024.
//

import UIKit

final class CurrentTabFontOptionsListTableViewController: UITableViewController {

    // MARK: - сервисы
    private let viewModel: CurrentTabFontOptionsListViewModel
    
    init(title: String) {
        self.viewModel = CurrentTabFontOptionsListViewModel(title: title)
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
        let titleView = CustomTitleView(image: "font", title: viewModel.getCurrentTabName(), frame: .zero)
        navigationItem.titleView = titleView
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        let backButton = UIBarButtonItem(customView: button)
        backButton.tintColor = .label
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
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectFont(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.fontsCount()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fontOption = viewModel.fontOptionItem(index: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.tintColor = .systemGreen
        cell.textLabel?.text = fontOption.rawValue
        cell.textLabel?.textColor = viewModel.isFontSelected(index: indexPath.row) ? .systemGreen : .label
        cell.textLabel?.font = viewModel.isFontSelected(index: indexPath.row) ? fontOption.font : .systemFont(ofSize: 16, weight: .black)
        cell.accessoryType = viewModel.isFontSelected(index: indexPath.row) ? .checkmark : .none
        return cell
    }
}
