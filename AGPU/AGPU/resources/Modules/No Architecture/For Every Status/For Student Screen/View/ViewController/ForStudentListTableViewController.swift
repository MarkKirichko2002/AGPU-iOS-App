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
        let titleView = CustomTitleView(image: "student icon", title: "Студенту", frame: .zero)
        navigationItem.titleView = titleView
    }
    
    private func setUpTable() {
        tableView.register(UINib(nibName: ForEveryStatusTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ForEveryStatusTableViewCell.identifier)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        switch indexPath.row {
            
        case 0:
            NotificationCenter.default.post(name: Notification.Name("for every status selected"), object:  ForStudentSections.sections[indexPath.row].icon)
        
            if let cell = tableView.cellForRow(at: indexPath) as? ForEveryStatusTableViewCell {
                cell.sectionSelected(indexPath: indexPath)
            }
            
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                self.goToWeb(url: "http://plany.agpu.net/WebApp/#/", image: ForStudentSections.sections[indexPath.row].icon, title: "ЭИОС", isSheet: false, isNotify: true)
            }
            
        case 1:
            NotificationCenter.default.post(name: Notification.Name("for every status selected"), object:  ForStudentSections.sections[indexPath.row].icon)
            
            if let cell = tableView.cellForRow(at: indexPath) as? ForEveryStatusTableViewCell {
                cell.sectionSelected(indexPath: indexPath)
            }
            
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                let vc = AGPUBuildingsMapViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        case 2:
            NotificationCenter.default.post(name: Notification.Name("for every status selected"), object:  ForStudentSections.sections[indexPath.row].icon)
            
            if let cell = tableView.cellForRow(at: indexPath) as? ForEveryStatusTableViewCell {
                cell.sectionSelected(indexPath: indexPath)
            }
            
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                let vc = AGPUFacultiesListTableViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        case 3:
            if let cathedra = UserDefaults.loadData(type: FacultyCathedraModel.self, key: "cathedra") {
                
                NotificationCenter.default.post(name: Notification.Name("for every status selected"), object:  ForStudentSections.sections[indexPath.row].icon)
                
                if let cell = tableView.cellForRow(at: indexPath) as? ForEveryStatusTableViewCell {
                    cell.sectionSelected(indexPath: indexPath)
                }
                
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                    self.goToWeb(url: cathedra.manualUrl, image: ForStudentSections.sections[indexPath.row].icon, title: "Метод. материалы", isSheet: false, isNotify: true)
                }
            } else {
                self.showHintAlert(type: .manuals)
                HapticsManager.shared.hapticFeedback()
            }
            
        case 4:
            
            NotificationCenter.default.post(name: Notification.Name("for every status selected"), object:  ForStudentSections.sections[indexPath.row].icon)
            
            if let cell = tableView.cellForRow(at: indexPath) as? ForEveryStatusTableViewCell {
                cell.sectionSelected(indexPath: indexPath)
            }
            
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                let vc = DocumentsListTableViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        case 5:
            
            NotificationCenter.default.post(name: Notification.Name("for every status selected"), object:  ForStudentSections.sections[indexPath.row].icon)
            
            if let cell = tableView.cellForRow(at: indexPath) as? ForEveryStatusTableViewCell {
                cell.sectionSelected(indexPath: indexPath)
            }
            
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                self.goToWeb(url: "http://plany.agpu.net/Plans/", image: ForStudentSections.sections[indexPath.row].icon, title: "Учебный план", isSheet: false, isNotify: true)
            }
            
        case 6:
            
            NotificationCenter.default.post(name: Notification.Name("for every status selected"), object:  ForStudentSections.sections[indexPath.row].icon)
            
            if let cell = tableView.cellForRow(at: indexPath) as? ForEveryStatusTableViewCell {
                cell.sectionSelected(indexPath: indexPath)
            }
            
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                let vc = AGPUSectionsListViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        case 7:
            
            NotificationCenter.default.post(name: Notification.Name("for every status selected"), object:  ForStudentSections.sections[indexPath.row].icon)
            
            if let cell = tableView.cellForRow(at: indexPath) as? ForEveryStatusTableViewCell {
                cell.sectionSelected(indexPath: indexPath)
            }
            
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                let vc = AGPUWallpapersListViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
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
