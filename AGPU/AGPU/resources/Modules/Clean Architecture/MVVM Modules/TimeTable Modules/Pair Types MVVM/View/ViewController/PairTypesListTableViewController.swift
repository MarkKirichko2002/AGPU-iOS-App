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
    var isWeekDay = false
    
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
        setUpNavigationTitle()
        if isWeekDay {
            setUpBackButton()
        } else {
            setUpCloseButton()
        }
    }
    
    func setUpNavigationTitle() {
        let titleView = CustomTitleView(image: "filter icon", title: "Фильтрация", frame: .zero)
        navigationItem.titleView = titleView
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
    
    private func setUpTable() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func bindViewModel() {
        viewModel.registerPairTypeSelectedHandler { type in
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                if self.isWeekDay {
                    self.delegate?.pairTypeWasSelected(type: type)
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.delegate?.pairTypeWasSelected(type: type)
                    self.dismiss(animated: true)
                }
            }
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
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.tintColor = .systemGreen
        cell.textLabel?.text = viewModel.textForCell(index: indexPath.row)
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        cell.detailTextLabel?.text = viewModel.textForDetailCell(index: indexPath.row)
        cell.detailTextLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        cell.detailTextLabel?.numberOfLines = 0
        cell.accessoryType = viewModel.isCurrentType(index: indexPath.row) ? .checkmark : .none
        cell.textLabel?.textColor = viewModel.isCurrentType(index: indexPath.row) ? .systemGreen : .label
        cell.detailTextLabel?.textColor = viewModel.isCurrentType(index: indexPath.row) ? .systemGreen : .label
        return cell
    }
}
