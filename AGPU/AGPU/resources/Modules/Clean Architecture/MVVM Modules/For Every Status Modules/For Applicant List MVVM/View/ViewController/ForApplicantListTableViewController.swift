//
//  ForApplicantListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 26.07.2023.
//

import UIKit

final class ForApplicantListTableViewController: UITableViewController {
    
    // MARK: - сервисы
    private let viewModel = ForApplicantListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        let titleView = CustomTitleView(image: "profile icon", title: "Абитуриенту", frame: .zero)
        navigationItem.titleView = titleView
        setUpRestartButton()
        setUpEditButton(title: "Править")
    }
    
    func setUpRestartButton() {
        let restartButton = UIBarButtonItem(image: UIImage(named: "refresh"), style: .done, target: self, action: #selector(restart))
        restartButton.tintColor = .label
        navigationItem.leftBarButtonItem = restartButton
    }
    
    @objc private func restart() {
        viewModel.restartPosition()
    }
    
    func setUpEditButton(title: String) {
        let moveButton = UIBarButtonItem(title: title, style: .done, target: self, action: #selector(moveTabs))
        moveButton.tintColor = .label
        navigationItem.rightBarButtonItem = moveButton
    }
    
    @objc private func moveTabs() {
        if tableView.isEditing {
            setUpEditButton(title: "Править")
            tableView.isEditing = false
        } else {
            setUpEditButton(title: "Готово")
            tableView.isEditing = true
        }
    }
    
    private func setUpTable() {
        tableView.register(ForEveryStatusTableViewCell.self, forCellReuseIdentifier: ForEveryStatusTableViewCell.identifier)
    }
    
    private func bindViewModel() {
        viewModel.getData()
        viewModel.registerDataChangedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = viewModel.sectionItem(index: indexPath.row)
        
        if let cell = tableView.cellForRow(at: indexPath) as? ForEveryStatusTableViewCell {
            cell.didTapCell(indexPath: indexPath)
        }
        
        switch item.id {
            
        case 1:
            
            Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false) { _ in
                NotificationCenter.default.post(name: Notification.Name("for every status selected"), object:  ForApplicantSections.sections[indexPath.row].icon)
            }
            
            Timer.scheduledTimer(withTimeInterval: 1.2, repeats: false) { _ in
                let vc = AGPUBuildingsMapViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        case 2:
            
            Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false) { _ in
                NotificationCenter.default.post(name: Notification.Name("for every status selected"), object:  ForApplicantSections.sections[indexPath.row].icon)
            }
            
            Timer.scheduledTimer(withTimeInterval: 1.2, repeats: false) { _ in
                let vc = AGPUFacultiesListTableViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        case 3:
            
            Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false) { _ in
                NotificationCenter.default.post(name: Notification.Name("for every status selected"), object:  ForApplicantSections.sections[indexPath.row].icon)
            }
            
            Timer.scheduledTimer(withTimeInterval: 1.2, repeats: false) { _ in
                self.goToWeb(url: "http://priem.agpu.net/", image: ForApplicantSections.sections[indexPath.row].icon, title: "Информация для поступающих", isSheet: false, isNotify: false)
            }
            
        case 4:
            
            Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false) { _ in
                NotificationCenter.default.post(name: Notification.Name("for every status selected"), object:  ForApplicantSections.sections[indexPath.row].icon)
            }
            
            Timer.scheduledTimer(withTimeInterval: 1.2, repeats: false) { _ in
                self.goToWeb(url: "http://www.agpu.net/abitur/contact-form/Quest.php", image: ForApplicantSections.sections[indexPath.row].icon, title: "Вопросы и ответы", isSheet: false, isNotify: false)
            }
            
        case 5:
            
            Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false) { _ in
                NotificationCenter.default.post(name: Notification.Name("for every status selected"), object:  ForApplicantSections.sections[indexPath.row].icon)
            }
            
            Timer.scheduledTimer(withTimeInterval: 1.2, repeats: false) { _ in
                self.goToWeb(url: "https://niiro-agpu.ru/", image: ForApplicantSections.sections[indexPath.row].icon, title: "Доп. образование", isSheet: false, isNotify: false)
            }
            
        case 6:
            
            Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false) { _ in
                NotificationCenter.default.post(name: Notification.Name("for every status selected"), object:  ForApplicantSections.sections[indexPath.row].icon)
            }
            
            Timer.scheduledTimer(withTimeInterval: 1.2, repeats: false) { _ in
                let vc = ASPUWebsiteSectionsListViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if tableView.isEditing {
            viewModel.saveSectionsPosition(sourceIndexPath.row, destinationIndexPath.row)
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.sectionItem(index: indexPath.row)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ForEveryStatusTableViewCell.identifier, for: indexPath) as? ForEveryStatusTableViewCell else {return UITableViewCell()}
        cell.configure(for: item)
        return cell
    }
}
