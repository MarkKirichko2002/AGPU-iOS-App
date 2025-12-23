//
//  DifferentWaysScreenListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 30.12.2024.
//

import UIKit

final class DifferentWaysScreenListTableViewController: UITableViewController {

    // MARK: - сервисы
    var viewModel: DifferentWaysScreenListViewModel
    
    init(way: differentWays) {
        self.viewModel = DifferentWaysScreenListViewModel(way: way)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTableView()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        let titleView = CustomTitleView(image: viewModel.way.icon, title: viewModel.way.rawValue, frame: .zero)
        navigationItem.titleView = titleView
        setUpBackButton()
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
    
    private func setUpTableView() {
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func bindViewModel() {
        viewModel.registerDataChangedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        viewModel.setUpScreens()
        viewModel.getScreens()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectScreen(index: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.screensCount()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let screen = viewModel.screenItem(index: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.tintColor = .systemGreen
        cell.textLabel?.text = screen.rawValue
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        cell.textLabel?.textColor = viewModel.isScreenSelected(index: indexPath.row) ? UIColor.systemGreen : UIColor.label
        cell.accessoryType = viewModel.isScreenSelected(index: indexPath.row) ? .checkmark : .none
        return cell
    }
}
