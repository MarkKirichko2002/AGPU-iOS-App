//
//  ForStudentListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 11.07.2023.
//

import UIKit

final class ForStudentListTableViewController: UITableViewController {
    
    // MARK: - сервисы
    private let viewModel = ForStudentListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        let titleView = CustomTitleView(image: "student icon", title: "Студенту", frame: .zero)
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
        
        switch item.id {
            
        case 1:
            
            NotificationCenter.default.post(name: Notification.Name("for every status selected"), object:  ForStudentSections.sections[indexPath.row].icon)
        
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                self.goToWeb(url: "http://plany.agpu.net/WebApp/#/", image: ForStudentSections.sections[indexPath.row].icon, title: "ЭИОС", isSheet: false, isNotify: true)
            }
            
        case 2:
            
            NotificationCenter.default.post(name: Notification.Name("for every status selected"), object:  ForStudentSections.sections[indexPath.row].icon)
            
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                let vc = AGPUBuildingsMapViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        case 3:
            
            NotificationCenter.default.post(name: Notification.Name("for every status selected"), object:  ForStudentSections.sections[indexPath.row].icon)
            
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                let vc = AGPUFacultiesListTableViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        case 4:
            
            if let cathedra = UserDefaults.loadData(type: FacultyCathedraModel.self, key: "cathedra") {
                
                NotificationCenter.default.post(name: Notification.Name("for every status selected"), object:  ForStudentSections.sections[indexPath.row].icon)
                
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                    self.goToWeb(url: cathedra.manualUrl, image: ForStudentSections.sections[indexPath.row].icon, title: "Метод. материалы", isSheet: false, isNotify: true)
                }
            } else {
                self.showHintAlert(type: .manuals)
                HapticsManager.shared.hapticFeedback()
            }
            
        case 5:
            
            NotificationCenter.default.post(name: Notification.Name("for every status selected"), object:  ForStudentSections.sections[indexPath.row].icon)
            
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                let vc = ThingsCategoriesListTableViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        case 6:
            
            NotificationCenter.default.post(name: Notification.Name("for every status selected"), object:  ForStudentSections.sections[indexPath.row].icon)
            
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                self.goToWeb(url: "http://plany.agpu.net/Plans/", image: ForStudentSections.sections[indexPath.row].icon, title: "Учебный план", isSheet: false, isNotify: true)
            }
            
        case 7:
            
            NotificationCenter.default.post(name: Notification.Name("for every status selected"), object:  ForStudentSections.sections[indexPath.row].icon)
            
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                let vc = AGPUSectionsListViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        case 8:
            
            NotificationCenter.default.post(name: Notification.Name("for every status selected"), object:  ForStudentSections.sections[indexPath.row].icon)
            
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
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if tableView.isEditing {
            viewModel.saveSectionsPosition(sourceIndexPath.row, destinationIndexPath.row)
        }
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
