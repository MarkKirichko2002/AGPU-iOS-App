//
//  ForApplicantListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 26.07.2023.
//

import UIKit

class ForApplicantListTableViewController: UITableViewController {
    
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
        let titleView = CustomTitleView(image: "profile icon", title: "Абитуриенту", frame: .zero)
        navigationItem.titleView = titleView
    }
    
    private func setUpTable() {
        tableView.register(UINib(nibName: ForEveryStatusTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ForEveryStatusTableViewCell.identifier)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
            
        case 0:
            NotificationCenter.default.post(name: Notification.Name("for every status selected"), object:  ForApplicantSections.sections[indexPath.row].icon)
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                let vc = AGPUBuildingsMapViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        case 1:
            NotificationCenter.default.post(name: Notification.Name("for every status selected"), object:  ForApplicantSections.sections[indexPath.row].icon)
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                let vc = AGPUFacultiesListTableViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        case 2:
            NotificationCenter.default.post(name: Notification.Name("for every status selected"), object:  ForApplicantSections.sections[indexPath.row].icon)
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                self.goToWeb(url: "http://priem.agpu.net/", image: ForApplicantSections.sections[indexPath.row].icon, title: "Информация для поступающих", isSheet: false)
            }
            
        case 3:
            NotificationCenter.default.post(name: Notification.Name("for every status selected"), object:  ForApplicantSections.sections[indexPath.row].icon)
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                self.goToWeb(url: "http://www.agpu.net/abitur/contact-form/Quest.php", image: ForApplicantSections.sections[indexPath.row].icon, title: "Вопросы и ответы", isSheet: false)
            }
            
        case 4:
            NotificationCenter.default.post(name: Notification.Name("for every status selected"), object:  ForApplicantSections.sections[indexPath.row].icon)
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                self.goToWeb(url: "https://niiro-agpu.ru/", image: ForApplicantSections.sections[indexPath.row].icon, title: "Доп. образование", isSheet: false)
            }
            
        case 5:
            NotificationCenter.default.post(name: Notification.Name("for every status selected"), object:  ForEmployeeSections.sections[indexPath.row].icon)
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                let vc = AGPUSectionsListViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        default:
            break
        }
        
        if let cell = tableView.cellForRow(at: indexPath) as? ForEveryStatusTableViewCell {
            cell.sectionSelected(indexPath: indexPath)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ForApplicantSections.sections.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ForEveryStatusTableViewCell.identifier, for: indexPath) as? ForEveryStatusTableViewCell else {return UITableViewCell()}
        cell.configure(for: ForApplicantSections.sections[indexPath.row])
        return cell
    }
}
