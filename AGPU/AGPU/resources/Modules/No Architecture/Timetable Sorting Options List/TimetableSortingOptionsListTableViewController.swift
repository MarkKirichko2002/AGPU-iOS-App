//
//  TimetableSortingOptionsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 21.01.2026.
//

import UIKit

class SortingOptionSection {
    let title: String
    let options: [sortingOptions]
    var isOpened = false
    
    init(title: String,
         options: [sortingOptions],
         isOpened: Bool = false
    ) {
        self.title = title
        self.options = options
        self.isOpened = isOpened
    }
}

enum sortingOptions: String {
    case timeAscending = "По возрастанию"
    case timeDescending = "По убыванию"
}

protocol TimetableSortingOptionsListTableViewControllerDelegate: AnyObject {
    func sortingOptionWasSelected(option: sortingOptions)
}

final class TimetableSortingOptionsListTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    weak var delegate: TimetableSortingOptionsListTableViewControllerDelegate?
    var selectedSortingOption = sortingOptions.timeAscending
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self,
        forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var sections = [SortingOptionSection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        sections = [
            SortingOptionSection(title: "По времени", options: [.timeAscending, .timeDescending]),
        ]
        setUpNavigation()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
    }
    
    private func setUpNavigation() {
        navigationItem.title = "Сортировка"
        setUpCloseButton()
    }
    
    private func setUpCloseButton() {
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .done, target: self, action: #selector(close))
        closeButton.tintColor = .label
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func close() {
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        if section.isOpened {
            return section.options.count + 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath
        )
        if indexPath.row == 0 {
            cell.textLabel?.text = sections[indexPath.section].title
        } else {
            cell.textLabel?.text = sections[indexPath.section].options[indexPath.row - 1].rawValue
            cell.tintColor = .systemGreen
            cell.accessoryType = sections[indexPath.section].options[indexPath.row - 1] == selectedSortingOption ? .checkmark : .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            sections[indexPath.section].isOpened = !sections[indexPath.section].isOpened
            tableView.reloadSections([indexPath.section], with: .none)
        } else {
            selectedSortingOption = sections[indexPath.section].options[indexPath.row - 1]
            delegate?.sortingOptionWasSelected(option: sections[indexPath.section].options[indexPath.row - 1])
            tableView.reloadSections([indexPath.section], with: .none)
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                self.dismiss(animated: true)
            }
        }
    }
}
