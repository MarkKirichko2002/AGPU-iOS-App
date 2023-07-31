//
//  AGPUSectionsListViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 08.06.2023.
//

import UIKit

final class AGPUSectionsListViewController: UIViewController {

    // MARK: - UI
    private let tableView = UITableView()

    // MARK: - сервисы
    private let viewModel = AGPUSectionsListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUpNavigation()
        SetUpTable()
        BindViewModel()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.post(name: Notification.Name("for student appear"), object: nil)
    }
    
    private func SetUpNavigation() {
        let titleView = CustomTitleView(
            image: "АГПУ",
            title: "Разделы",
            frame: .zero
        )
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .black
        navigationItem.titleView = titleView
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func closeScreen() {
         dismiss(animated: true)
    }
    
    private func SetUpTable() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            AGPUSubSectionTableViewCell.self,
            forCellReuseIdentifier: AGPUSubSectionTableViewCell.identifier
        )
    }
    
    private func BindViewModel() {
        viewModel.ObserveScroll { section in
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: section), at: .top, animated: true)
        }
        viewModel.ObserveActions {
            self.dismiss(animated: true)
        }
    }
}
