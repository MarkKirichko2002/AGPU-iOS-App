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
            UINib(nibName: ForEveryStatusTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: ForEveryStatusTableViewCell.identifier
        )
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
            
        case 0:
            NotificationCenter.default.post(name: Notification.Name("for student selected"), object:  ForStudentSections.sections[indexPath.row].icon)
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                self.GoToWeb(url: "http://plany.agpu.net/WebApp/#/", title: "Личный кабинет ЭИОС", isSheet: false)
            }
            
        case 1:
            NotificationCenter.default.post(name: Notification.Name("for student selected"), object:  ForStudentSections.sections[indexPath.row].icon)
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                let vc = AGPUBuildingsMapViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        case 2:
            NotificationCenter.default.post(name: Notification.Name("for student selected"), object:  ForStudentSections.sections[indexPath.row].icon)
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                let vc = AGPUFacultiesListTableViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        case 3:
            if let cathedra = UserDefaults.loadData(type: FacultyCathedraModel.self, key: "cathedra") {
                NotificationCenter.default.post(name: Notification.Name("for student selected"), object:  ForStudentSections.sections[indexPath.row].icon)
                Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                    let vc = DocumentsListTableViewController(url: cathedra.manualUrl)
                    let navVC = UINavigationController(rootViewController: vc)
                    navVC.modalPresentationStyle = .fullScreen
                    self.present(navVC, animated: true)
                }
            } else {
                let ok = UIAlertAction(title: "ОК", style: .default)
                self.ShowAlert(title: "Вы не выбрали кафедру", message: "чтобы посмотреть методические материалы для вашей кафедры выберите ее в настройках", actions: [ok])
            }
            
        case 4:
            if let cathedra = UserDefaults.loadData(type: FacultyCathedraModel.self, key: "cathedra") {
                NotificationCenter.default.post(name: Notification.Name("for student selected"), object:  ForStudentSections.sections[indexPath.row].icon)
                Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                    self.GoToWeb(url: cathedra.additionalEducationUrl, title: "Дополнительное образование", isSheet: false)
                }
            } else {
                let ok = UIAlertAction(title: "ОК", style: .default)
                self.ShowAlert(title: "Вы не выбрали кафедру", message: "чтобы посмотреть соответствующие материалы для вашей кафедры выберите ее в настройках", actions: [ok])
            }
            
        case 5:
            NotificationCenter.default.post(name: Notification.Name("for student selected"), object:  ForStudentSections.sections[indexPath.row].icon)
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                self.GoToWeb(url: "http://test.agpu.net/studentu/obshchezhitiya/index.php", title: "Кампус и общежития", isSheet: false)
            }
            
        case 6:
            NotificationCenter.default.post(name: Notification.Name("for student selected"), object:  ForStudentSections.sections[indexPath.row].icon)
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                let vc = AGPUSectionsListViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        case 7:
            NotificationCenter.default.post(name: Notification.Name("for student selected"), object:  ForStudentSections.sections[indexPath.row].icon)
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                let vc = AGPUWallpapersListViewController()
                vc.hidesBottomBarWhenPushed = true
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ForEveryStatusTableViewCell.identifier, for: indexPath) as? ForEveryStatusTableViewCell else {return UITableViewCell()}
        cell.configure(for: ForStudentSections.sections[indexPath.row])
        return cell
    }
}
