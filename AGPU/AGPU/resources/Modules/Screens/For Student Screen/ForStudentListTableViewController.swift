//
//  ForStudentListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 11.07.2023.
//

import UIKit

class ForStudentListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Студенту"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            let vc = TimeTableListTableViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = AGPUMapViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = AGPUFacultiesListTableViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 3:
            self.GoToWeb(url: "http://test.agpu.net/studentu/obshchezhitiya/index.php", title: "Кампус и общежития")
        case 4:
            let vc = AGPUSectionsListViewController()
            navigationController?.pushViewController(vc, animated: true)
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
        return cell
    }
}
