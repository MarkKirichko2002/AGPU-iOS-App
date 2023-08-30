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
        setUpSwipeGesture()
        setUpTable()
    }
    
    private func setUpNavigation() {
        
        let titleView = CustomTitleView(image: "АГПУ", title: "Разделы", frame: .zero)
        
        let button = UIButton()
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        let backButton = UIBarButtonItem(customView: button)
        backButton.tintColor = .black
        
        let list = UIBarButtonItem(image: UIImage(named: "sections"), menu: setUpMenu())
        list.tintColor = .black
        
        navigationItem.titleView = titleView
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
        
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = list
    }
    
    private func setUpMenu()-> UIMenu {
        let items = AGPUSections.sections.map { section in
            return UIAction(title: "\(section.id + 1)) \(section.name.lowercased())") { _ in
                let indexPath = IndexPath(row: 0, section: section.id)
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
        let menu = UIMenu(title: "разделы", options: .singleSelection, children: items)
        return menu
    }
    
    @objc private func back() {
        SendScreenWasClosedNotification()
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
