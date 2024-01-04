//
//  SavedPairTypeTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 19.11.2023.
//

import UIKit

class SavedPairTypeTableViewController: UITableViewController {

    private var type: PairType
    private var viewModel: SavedPairTypeViewModel
    
    // MARK: - Init
    init(type: PairType) {
        self.type = type
        self.viewModel = SavedPairTypeViewModel(type: type)
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
        
        navigationItem.title = "Типы пары"
        
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
        
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        let backButton = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setUpTable() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func bindViewModel() {
        viewModel.registerPairTypeSelectedHandler {
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.choosePairType(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfTypesInSection()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let type = viewModel.typeItem(index: indexPath.row)
        cell.tintColor = .systemGreen
        cell.textLabel?.text = type.name
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        cell.accessoryType = viewModel.isCurrentType(index: indexPath.row) ? .checkmark : .none
        cell.textLabel?.textColor = viewModel.isCurrentType(index: indexPath.row) ? .systemGreen : .label
        return cell
    }
}
