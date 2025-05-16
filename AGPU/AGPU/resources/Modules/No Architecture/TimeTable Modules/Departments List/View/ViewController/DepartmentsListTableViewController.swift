//
//  DepartmentsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 18.07.2024.
//

import UIKit

protocol DepartmentsListTableViewControllerDelegate: AnyObject {
    func teacherSelected(teacher: String)
}

final class DepartmentsListTableViewController: UITableViewController {

    var departments = Departments.departments
    
    weak var delegate: DepartmentsListTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
    }
    
    private func setUpNavigation() {
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .plain, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .label
        navigationItem.title = "Кафедры"
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        self.dismiss(animated: true)
    }
    
    private func setUpTable() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = TeachersListTableViewController(id: departments[indexPath.row].id)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
        HapticsManager.shared.hapticFeedback()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return departments.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = departments[indexPath.row].name
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        return cell
    }
}

// MARK: - TeachersListTableViewControllerDelegate
extension DepartmentsListTableViewController: TeachersListTableViewControllerDelegate {
    
    func teacherWasSelected(teacher: String) {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.delegate?.teacherSelected(teacher: teacher)
            self.dismiss(animated: true)
        }
    }
}
