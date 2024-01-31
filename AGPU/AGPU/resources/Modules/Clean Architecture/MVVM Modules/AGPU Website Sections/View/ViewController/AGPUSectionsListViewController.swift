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

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    private func setUpNavigation() {
        
        let titleView = CustomTitleView(image: "АГПУ", title: "Разделы сайта", frame: .zero)
        
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        let backButton = UIBarButtonItem(customView: button)
        
        let list = UIBarButtonItem(image: UIImage(named: "sections"), menu: setUpMenu())
        list.tintColor = .label
        
        navigationItem.titleView = titleView
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
        
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = list
    }
    
    private func setUpMenu()-> UIMenu {
        let items = AGPUSections.sections.map { section in
            return UIAction(title: "\(section.id + 1)) \(section.name)") { _ in
                let indexPath = IndexPath(row: 0, section: section.id)
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                self.tableView.isUserInteractionEnabled = false
            }
        }
        let menu = UIMenu(title: "Разделы сайта", options: .singleSelection, children: items)
        return menu
    }
    
    @objc private func back() {
        sendScreenWasClosedNotification()
        navigationController?.popViewController(animated: true)
    }
    
    private func setUpTable() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AGPUSubSectionTableViewCell.self, forCellReuseIdentifier: AGPUSubSectionTableViewCell.identifier)
    }
}
