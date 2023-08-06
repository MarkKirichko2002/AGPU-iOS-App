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
        SetUpNavigation()
        SetUpSwipeGesture()
        SetUpTable()
    }
    
    private func SetUpNavigation() {
        
        navigationItem.title = "Разделы"
        
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
        
        let button = UIButton()
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        let backButton = UIBarButtonItem(customView: button)
        backButton.tintColor = .black
        
        let list = UIBarButtonItem(image: UIImage(named: "sections"), menu: SetUpMenu())
        list.tintColor = .black
        
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = list
    }
    
    private func SetUpMenu()-> UIMenu {
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
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            NotificationCenter.default.post(name: Notification.Name("for every status appear"), object: nil)
        }
        navigationController?.popViewController(animated: true)
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
}
