//
//  SubGroupsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 28.09.2023.
//

import UIKit

class SubGroupsListTableViewController: UITableViewController {

    var subgroup: Int
    var disciplines: [Discipline] = []
    
    // MARK: - сервисы
    private let viewModel: SubGroupsListViewModel
    
    // MARK: - Init
    init(subgroup: Int, disciplines: [Discipline]) {
        self.subgroup = subgroup
        self.disciplines = disciplines
        self.viewModel = SubGroupsListViewModel(subgroup: subgroup, disciplines: disciplines)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        setUpNavigation()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        navigationItem.title = "Подгруппы"
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .done, target: self, action: #selector(close))
        closeButton.tintColor = .label
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func close() {
        self.dismiss(animated: true)
    }
    
    private func bindViewModel() {
        
        viewModel.getPairsCount(pairs: disciplines)
        
        viewModel.registerDataChangedHandler {
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                self.dismiss(animated: true)
            }
        }
        
        viewModel.registerSubGroupSelectedHandler {
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                self.dismiss(animated: true)
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.selectSubGroup(index: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfSubGroups()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.tintColor = .systemGreen
        cell.textLabel?.text = viewModel.subgroupItem(index: indexPath.row)
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        cell.textLabel?.textColor = viewModel.isSubGroupSelected(index: indexPath.row) ? .systemGreen : .label
        cell.accessoryType = viewModel.isSubGroupSelected(index: indexPath.row) ? .checkmark : .none
        return cell
    }
}
