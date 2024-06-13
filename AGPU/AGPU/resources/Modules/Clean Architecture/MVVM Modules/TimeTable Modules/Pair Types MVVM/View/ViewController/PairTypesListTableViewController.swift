//
//  PairTypesListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 31.08.2023.
//

import UIKit

protocol PairTypesListTableViewControllerDelegate: AnyObject {
    func pairTypeWasSelected(type: PairType)
}

class PairTypesListTableViewController: UITableViewController {
    
    private var viewModel: PairTypesListViewModel
    weak var delegate: PairTypesListTableViewControllerDelegate?
    private var type: PairType
    
    // MARK: - Init
    init(date: String, type: PairType, disciplines: [Discipline]) {
        self.type = type
        self.viewModel = PairTypesListViewModel(date: date, type: type, disciplines: disciplines)
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
        let titleView = CustomTitleView(image: "filter", title: "Фильтрация", frame: .zero)
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .done, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .label
        navigationItem.titleView = titleView
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        self.dismiss(animated: true)
    }
    
    private func setUpTable() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func bindViewModel() {
        viewModel.registerPairTypeSelectedHandler {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                self.dismiss(animated: true)
            }
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.choosePairType(index: indexPath.row)
        delegate?.pairTypeWasSelected(type: viewModel.typeItem(index: indexPath.row))
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfTypesInSection()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let type = viewModel.typeItem(index: indexPath.row)
        cell.tintColor = .systemGreen
        cell.textLabel?.text = "\(type.title) (\(viewModel.countForPairType(index: indexPath.row)))"
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        cell.accessoryType = viewModel.isCurrentType(index: indexPath.row) ? .checkmark : .none
        cell.textLabel?.textColor = viewModel.isCurrentType(index: indexPath.row) ? .systemGreen : .label
        return cell
    }
}
