//
//  ForEmployeeListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 27.07.2023.
//

import UIKit

class ForEmployeeListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Сотруднику"
        tableView.register(UINib(nibName: ForEveryStatusTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ForEveryStatusTableViewCell.identifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
            
        case 0:
            NotificationCenter.default.post(name: Notification.Name("for student selected"), object:  ForEmployeeSections.sections[indexPath.row].icon)
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                self.GoToWeb(url: "http://plany.agpu.net/WebApp/#/", title: "Личный кабинет ЭИОС", isSheet: true)
            }
            
        case 1:
            NotificationCenter.default.post(name: Notification.Name("for student selected"), object:  ForStudentSections.sections[indexPath.row].icon)
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                let vc = AGPUBuildingsMapViewController()
                self.navigationController?.pushViewController(vc, animated: true)
                self.tabBarController?.tabBar.isHidden = true
            }
            
        case 2:
            NotificationCenter.default.post(name: Notification.Name("for student selected"), object:  ForEmployeeSections.sections[indexPath.row].icon)
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                self.GoToWeb(url: "http://vedomosti.agpu.net/", title: "Ведомости ONLINE", isSheet: true)
            }
            
        case 3:
            if let cathedra = UserDefaults.loadData(type: FacultyCathedraModel.self, key: "cathedra") {
                NotificationCenter.default.post(name: Notification.Name("for student selected"), object:  ForEmployeeSections.sections[indexPath.row].icon)
                Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                    self.GoToWeb(url: cathedra.manualUrl, title: "Методические материалы", isSheet: true)
                }
            } else {
                let ok = UIAlertAction(title: "ОК", style: .default)
                self.ShowAlert(title: "Вы не выбрали кафедру", message: "чтобы посмотреть методические материалы для вашей кафедры выберите ее в настройках", actions: [ok])
            }
            
        case 4:
            NotificationCenter.default.post(name: Notification.Name("for student selected"), object:  ForEmployeeSections.sections[indexPath.row].icon)
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                self.GoToWeb(url: "http://test.agpu.net/struktura-vuza/index.php", title: "Подразделения", isSheet: true)
            }
            
        case 5:
            NotificationCenter.default.post(name: Notification.Name("for student selected"), object:  ForEmployeeSections.sections[indexPath.row].icon)
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                self.GoToWeb(url: "http://test.agpu.net/sveden/document/index.php", title: "Документы", isSheet: true)
            }
            
        case 6:
            NotificationCenter.default.post(name: Notification.Name("for student selected"), object:  ForEmployeeSections.sections[indexPath.row].icon)
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                let vc = AGPUSectionsListViewController()
                self.navigationController?.pushViewController(vc, animated: true)
                self.tabBarController?.tabBar.isHidden = true
            }
            
        case 7:
            NotificationCenter.default.post(name: Notification.Name("for student selected"), object:  ForEmployeeSections.sections[indexPath.row].icon)
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                let vc = AGPUWallpapersListViewController()
                self.navigationController?.pushViewController(vc, animated: true)
                self.tabBarController?.tabBar.isHidden = true
            }
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ForEmployeeSections.sections.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ForEveryStatusTableViewCell.identifier, for: indexPath) as? ForEveryStatusTableViewCell else {return UITableViewCell()}
        cell.configure(for: ForEmployeeSections.sections[indexPath.row])
        return cell
    }
}
