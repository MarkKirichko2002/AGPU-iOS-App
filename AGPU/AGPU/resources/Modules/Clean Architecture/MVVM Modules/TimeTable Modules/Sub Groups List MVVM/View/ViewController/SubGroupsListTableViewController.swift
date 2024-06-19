//
//  SubGroupsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 28.09.2023.
//

import UIKit

protocol SubGroupsListTableViewControllerDelegate: AnyObject {
    func subGroupWasSelected(subgroup: Int)
}

class SubGroupsListTableViewController: UITableViewController {

    var subgroup: Int
    var disciplines: [Discipline] = []
    
    // MARK: - сервисы
    private let viewModel: SubGroupsListViewModel
    
    weak var delegate: SubGroupsListTableViewControllerDelegate?
    
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
        let titleView = CustomTitleView(image: "group icon", title: "Подгруппы", frame: .zero)
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .done, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .label
        navigationItem.titleView = titleView
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        self.dismiss(animated: true)
    }
    
    private func bindViewModel() {
        
        viewModel.registerDataChangedHandler {
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        viewModel.getPairsCount(pairs: disciplines)
        
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
        viewModel.selectSubGroup(index: indexPath.row)
        delegate?.subGroupWasSelected(subgroup: viewModel.subGroupNumber(index: indexPath.row))
        tableView.deselectRow(at: indexPath, animated: true)
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
