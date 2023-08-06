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
        navigationItem.title = "Абитуриенту"
        tableView.register(UINib(nibName: ForEveryStatusTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ForEveryStatusTableViewCell.identifier)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
            
        case 0:
            NotificationCenter.default.post(name: Notification.Name("for student selected"), object:  ForApplicantSections.sections[indexPath.row].icon)
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                self.GoToWeb(url: "http://abit.agpu.net/", title: "Личный кабинет абитуриента", isSheet: false)
            }
            
        case 1:
            NotificationCenter.default.post(name: Notification.Name("for student selected"), object:  ForApplicantSections.sections[indexPath.row].icon)
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                let vc = AGPUFacultiesListTableViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        case 2:
            NotificationCenter.default.post(name: Notification.Name("for student selected"), object:  ForApplicantSections.sections[indexPath.row].icon)
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                self.GoToWeb(url: "http://priem.agpu.net/", title: "Информация для поступающих", isSheet: false)
            }
            
        case 3:
            NotificationCenter.default.post(name: Notification.Name("for student selected"), object:  ForApplicantSections.sections[indexPath.row].icon)
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                self.GoToWeb(url: "http://priem.agpu.net/contact-form/Quest.php", title: "Вопросы и ответы", isSheet: false)
            }
            
        case 4:
            NotificationCenter.default.post(name: Notification.Name("for student selected"), object:  ForApplicantSections.sections[indexPath.row].icon)
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                self.GoToWeb(url: "https://niiro-agpu.ru/", title: "Дополнительное образование", isSheet: false)
            }
            
        default:
            break
        }
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
