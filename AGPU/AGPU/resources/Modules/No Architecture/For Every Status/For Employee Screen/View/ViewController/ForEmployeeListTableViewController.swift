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
        setUpNavigation()
        setUpTable()
    }
    
    private func setUpNavigation() {
        let titleView = CustomTitleView(image: "computer", title: "Сотруднику", frame: .zero)
        navigationItem.titleView = titleView
    }
    
    private func setUpTable() {
        tableView.register(UINib(nibName: ForEveryStatusTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ForEveryStatusTableViewCell.identifier)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
            
        case 0:
            NotificationCenter.default.post(name: Notification.Name("for every status selected"), object:  ForStudentSections.sections[indexPath.row].icon)
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                self.goToWeb(url: "http://plany.agpu.net/WebApp/#/", image: ForStudentSections.sections[indexPath.row].icon, title: "ЭИОС", isSheet: false)
            }
            
        case 1:
            NotificationCenter.default.post(name: Notification.Name("for every status selected"), object:  ForStudentSections.sections[indexPath.row].icon)
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                let vc = AGPUBuildingsMapViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        case 2:
            NotificationCenter.default.post(name: Notification.Name("for every status selected"), object:  ForEmployeeSections.sections[indexPath.row].icon)
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                self.goToWeb(url: "http://vedomosti.agpu.net/", image: ForEmployeeSections.sections[indexPath.row].icon, title: "Ведомости ONLINE", isSheet: false)
            }
            
        case 3:
            if let cathedra = UserDefaults.loadData(type: FacultyCathedraModel.self, key: "cathedra") {
                NotificationCenter.default.post(name: Notification.Name("for every status selected"), object:  ForEmployeeSections.sections[indexPath.row].icon)
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                    self.goToWeb(url: cathedra.manualUrl, image: ForEmployeeSections.sections[indexPath.row].icon, title: "Метод. материалы", isSheet: false)
                }
            } else {
                self.showHintAlert(type: .manuals)
                HapticsManager.shared.hapticFeedback()
            }
            
        case 4:
            NotificationCenter.default.post(name: Notification.Name("for every status selected"), object:  ForEmployeeSections.sections[indexPath.row].icon)
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                self.goToWeb(url: "http://plany.agpu.net/Plans/", image: ForEmployeeSections.sections[indexPath.row].icon, title: "Учебный план", isSheet: false)
            }
            
        case 5:
            NotificationCenter.default.post(name: Notification.Name("for every status selected"), object:  ForEmployeeSections.sections[indexPath.row].icon)
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                let vc = AGPUSectionsListViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        case 6:
            NotificationCenter.default.post(name: Notification.Name("for every status selected"), object:  ForEmployeeSections.sections[indexPath.row].icon)
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                let vc = AGPUWallpapersListViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
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
