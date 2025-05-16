//
//  NewsFilterCategoriesListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 07.05.2025.
//

import UIKit

enum newsFilterCategories: String, CaseIterable {
    case calendar = "Календарь"
    case month = "Месяцы"
}

protocol NewsFilterCategoriesListTableViewControllerDelegate: AnyObject {
    func dateFromCalendarWasSelected(date: String)
    func monthWasSelected(month: Month)
}

final class NewsFilterCategoriesListTableViewController: UITableViewController {

    weak var delegate: NewsFilterCategoriesListTableViewControllerDelegate?
    
    var date: String
    var month: Month

    // MARK: - Init
    init(date: String, month: Month) {
        self.date = date
        self.month = month
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
    }
    
    private func setUpNavigation() {
        let titleView = CustomTitleView(image: "search", title: "Поиск", frame: .zero)
        setUpCloseButton()
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
    
    private func setUpTable() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsFilterCategories.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = SimpleCalendarViewController(date: date)
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = MonthsListTableViewController(month: month)
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
        HapticsManager.shared.hapticFeedback()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = newsFilterCategories.allCases[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if indexPath.row == 0 {
            cell.textLabel?.text = "\(category.rawValue) (\(date))"
        } else {
            cell.textLabel?.text = "\(category.rawValue) (\(month.rawValue))"
        }
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        return cell
    }
}

// MARK: - SimpleCalendarViewControllerDelegate
extension NewsFilterCategoriesListTableViewController: SimpleCalendarViewControllerDelegate {
    
    func dateFromCalendarWasSelected(date: String) {
        self.date = date
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.delegate?.dateFromCalendarWasSelected(date: date)
            self.dismiss(animated: true)
        }
    }
}

// MARK: - MonthsListTableViewControllerDelegate
extension NewsFilterCategoriesListTableViewController: MonthsListTableViewControllerDelegate {
    
    func monthWasSelected(month: Month) {
        self.month = month
        self.date = date.updateDateMonth(month: month.number)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.delegate?.monthWasSelected(month: month)
            self.dismiss(animated: true)
        }
    }
}
