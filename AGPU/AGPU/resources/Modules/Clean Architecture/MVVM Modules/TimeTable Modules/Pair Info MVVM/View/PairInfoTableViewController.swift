//
//  PairInfoTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 23.10.2023.
//

import UIKit

class PairInfoTableViewController: UITableViewController {

    private var viewModel: PairInfoViewModel
    
    // MARK: - Init
    init(pair: Discipline, group: String, date: String) {
        self.viewModel = PairInfoViewModel(pair: pair, group: group, date: date)
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
        let titleView = CustomTitleView(image: "info", title: "Информация о паре", frame: .zero)
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .label
        navigationItem.titleView = titleView
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func closeScreen() {
        dismiss(animated: true)
    }
    
    private func setUpTable() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func bindViewModel() {
        viewModel.setUpData()
        viewModel.registerDataChangedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.pairInfo.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let info = viewModel.pairInfo
        cell.textLabel?.text = viewModel.checkIsCurrentGroup(index: indexPath.row) ? "\(info[indexPath.row]) (ваша группа)" : info[indexPath.row]
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.textColor = viewModel.checkIsCurrentGroup(index: indexPath.row) ? .systemGreen : .label
        return cell
    }
}
