//
//  TimetablePseudonymCategoriesListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 22.10.2025.
//

import UIKit

protocol TimetablePseudonymCategoriesListTableViewControllerDelegate: AnyObject {
    func dataWasChanged()
}

final class TimetablePseudonymCategoriesListTableViewController: UITableViewController {

    let categories = PseudonymCategories.allCases
    
    weak var delegate: TimetablePseudonymCategoriesListTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
    }
    
    private func setUpNavigation() {
        let titleView = CustomTitleView(image: "clock", title: "Категории псевдонимов", frame: .zero)
        navigationItem.titleView = titleView
        setUpCloseButton()
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
        tableView.register(TimetablePseudonymTableViewCell.self, forCellReuseIdentifier: TimetablePseudonymTableViewCell.identifier)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openCategoryList(category: categories[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count - 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = categories[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier:  TimetablePseudonymTableViewCell.identifier, for: indexPath) as? TimetablePseudonymTableViewCell else {return UITableViewCell()}
        cell.configure(for: category)
        return cell
    }
    
    private func openCategoryList(category: PseudonymCategories) {
        let vc = PseudonymListViewController(category: category)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
        HapticsManager.shared.hapticFeedback()
    }
}

// MARK: - TimetablePseudonymListViewControllerDelegate
extension TimetablePseudonymCategoriesListTableViewController: TimetablePseudonymListViewControllerDelegate {
    
    func listWasChanged() {
        delegate?.dataWasChanged()
    }
}
