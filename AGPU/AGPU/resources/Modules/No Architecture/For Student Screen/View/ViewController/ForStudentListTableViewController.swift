//
//  ForStudentListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 11.07.2023.
//

import UIKit

final class ForStudentListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        SetUpNavigation()
        SetUpTable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func SetUpNavigation() {
        let titleView = CustomTitleView(
            image: "student",
            title: "Студенту",
            frame: .zero
        )
        navigationItem.titleView = titleView
    }
    
    private func SetUpTable() {
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "cell"
        )
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        NotificationCenter.default.post(name: Notification.Name("for student selected"), object:  ForStudentSections.sections[indexPath.row].icon)
        switch indexPath.row {
        case 0:
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                let vc = TimeTableListTableViewController()
                self.tabBarController?.tabBar.isHidden = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case 1:
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                let vc = AGPUBuildingsMapViewController()
                self.tabBarController?.tabBar.isHidden = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case 2:
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                let vc = AGPUFacultiesListTableViewController()
                self.tabBarController?.tabBar.isHidden = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case 3:
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                self.GoToWeb(url: "http://test.agpu.net/studentu/obshchezhitiya/index.php", title: "Кампус и общежития", isSheet: true)
            }
        case 4:
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                let vc = AGPUSectionsListViewController()
                self.tabBarController?.tabBar.isHidden = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case 5:
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                let vc = AppFeaturesListTableViewController()
                self.tabBarController?.tabBar.isHidden = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ForStudentSections.sections.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = ForStudentSections.sections[indexPath.row].name
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        cell.backgroundColor = .clear
        return cell
    }
}
