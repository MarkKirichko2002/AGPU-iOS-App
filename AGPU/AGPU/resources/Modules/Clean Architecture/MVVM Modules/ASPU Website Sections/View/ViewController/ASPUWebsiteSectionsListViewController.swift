//
//  ASPUWebsiteSectionsListViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 08.06.2023.
//

import UIKit

final class ASPUWebsiteSectionsListViewController: UIViewController {

    var isAction = false
    var isMain = false
    weak var delegate: ScreenClosedDelegate?
    var selectedSection = AGPUSections.sections[0]
    
    // MARK: - UI
    let tableView = UITableView()

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
        
        let titleView = CustomTitleView(image: "online", title: "Разделы сайта", frame: .zero)
        
        if isAction {
            let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .plain, target: self, action: #selector(closeScreen))
            closeButton.tintColor = .label
            
            let sections = UIBarButtonItem(image: UIImage(named: "sections"), menu: setUpMenu())
            sections.tintColor = .label
            navigationItem.titleView = titleView
            navigationItem.leftBarButtonItem = closeButton
            navigationItem.rightBarButtonItem = sections
        } else if isMain {
            let sections = UIBarButtonItem(image: UIImage(named: "sections"), menu: setUpMenu())
            sections.tintColor = .label
            navigationItem.titleView = titleView
            navigationItem.rightBarButtonItem = sections
        } else {
            let button = UIButton()
            button.tintColor = .label
            button.setImage(UIImage(named: "back"), for: .normal)
            button.addTarget(self, action: #selector(back), for: .touchUpInside)
            
            let backButton = UIBarButtonItem(customView: button)
            backButton.tintColor = .label
            
            let sections = UIBarButtonItem(image: UIImage(named: "sections"), menu: setUpMenu())
            sections.accessibilityIdentifier =  "sections"
            sections.tintColor = .label
            navigationItem.titleView = titleView
            navigationItem.leftBarButtonItem = nil
            navigationItem.hidesBackButton = true
            navigationItem.leftBarButtonItem = backButton
            navigationItem.rightBarButtonItem = sections
        }
    }
    
    func setUpMenu()-> UIMenu {
        let items = AGPUSections.sections.map { section in
            return UIAction(title: "\(section.id + 1)) \(section.name)", state: section.id == selectedSection.id ? .on : .off) { _ in
                let indexPath = IndexPath(row: 0, section: section.id)
                self.selectedSection = section
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                self.tableView.isUserInteractionEnabled = false
            }
        }
        let menu = UIMenu(title: "Разделы сайта", options: .singleSelection, children: items)
        return menu
    }
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func closeScreen() {
        delegate?.screenWasClosed()
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
    }
    
    private func setUpTable() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AGPUSubSectionTableViewCell.self, forCellReuseIdentifier: AGPUSubSectionTableViewCell.identifier)
    }
}
