//
//  SelectedFacultyListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 12.10.2023.
//

import UIKit

class SelectedFacultyListTableViewController: UITableViewController {

    @objc private let viewModel = SelectedFacultyListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        let titleView = CustomTitleView(image: "АГПУ", title: "Выберите факультет", frame: .zero)
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .plain, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .label
        navigationItem.titleView = titleView
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func closeScreen() {
        sendScreenWasClosedNotification()
        dismiss(animated: true)
    }
    
    private func setUpTable() {
        tableView.register(UINib(nibName: AGPUFacultyTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: AGPUFacultyTableViewCell.identifier)
    }
    
    private func bindViewModel() {
        viewModel.observation = observe(\.viewModel.isChanged) { _, _ in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil,
                                          actionProvider: {
            _ in
            
            let chooseFacultyAction = UIAction(title: self.viewModel.isFacultySelected(index: indexPath.row) ? "Выбран факультет" : "Выбрать факультет", image: self.viewModel.isFacultySelected(index: indexPath.row) ? UIImage(named: "check") : nil) { action in
                self.viewModel.chooseFaculty(index: indexPath.row)
            }
            
            let chooseIconAction = UIAction(title: self.viewModel.isFacultyIconSelected(index: indexPath.row) ? "Выбрана иконка" : "Выбрать иконку", image: self.viewModel.isFacultyIconSelected(index: indexPath.row) ? UIImage(named: "check") : nil) { action in
                if self.viewModel.isFacultySelected(index: indexPath.row) {
                    self.viewModel.chooseFacultyIcon(index: indexPath.row)
                } else {
                    NotificationCenter.default.post(name: Notification.Name("group"), object: nil)
                    let ok = UIAlertAction(title: "ОК", style: .default)
                    self.showAlert(title: "\(self.viewModel.facultyItem(index: indexPath.row).abbreviation) не ваш факультет!", message: "Вы не можете выбрать иконку факультета \(self.viewModel.facultyItem(index: indexPath.row).abbreviation) поскольку не относитесь к нему.", actions: [ok])
                }
            }
            
            let cathedraAction = UIAction(title: self.viewModel.isCathedraSelected(index: indexPath.row) ? "Выбрана кафедра" : "\(!self.viewModel.facultyItem(index: indexPath.row).cathedra.isEmpty ? "Выбрать кафедру" : "кафедры отсутствуют")", image: self.viewModel.isCathedraSelected(index: indexPath.row) ? UIImage(named: "check") : nil) { action in
                if self.viewModel.isFacultySelected(index: indexPath.row) && !self.viewModel.facultyItem(index: indexPath.row).cathedra.isEmpty {
                    let vc = FacultyCathedraListTableViewController(faculty: self.viewModel.facultyItem(index: indexPath.row), isSettings: true)
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                } else if self.viewModel.isFacultySelected(index: indexPath.row) &&  self.viewModel.facultyItem(index: indexPath.row).cathedra.isEmpty {
                    let ok = UIAlertAction(title: "ОК", style: .default)
                    self.showAlert(title: "У \(self.viewModel.facultyItem(index: indexPath.row).abbreviation) отсутствуют кафедры", message: "", actions: [ok])
                } else {
                    NotificationCenter.default.post(name: Notification.Name("group"), object: nil)
                    let ok = UIAlertAction(title: "ОК", style: .default)
                    self.showAlert(title: "\(self.viewModel.facultyItem(index: indexPath.row).abbreviation) не ваш факультет!", message: "Вы не можете выбрать кафедру факультета \(self.viewModel.facultyItem(index: indexPath.row).abbreviation) поскольку не относитесь к нему.", actions: [ok])
                }
            }
            
            let checkGroupAction = UIAction(title: self.viewModel.isGroupSelected(index: indexPath.row) ? "Выбрана группа" : "Выбрать группу", image: self.viewModel.isGroupSelected(index: indexPath.row) ? UIImage(named: "check") : nil) { _ in
                if self.viewModel.isFacultySelected(index: indexPath.row) {
                    let vc = FacultyGroupsListTableViewController(faculty: self.viewModel.facultyItem(index: indexPath.row))
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    NotificationCenter.default.post(name: Notification.Name("group"), object: nil)
                    let ok = UIAlertAction(title: "ОК", style: .default)
                    self.showAlert(title: "\(self.viewModel.facultyItem(index: indexPath.row).abbreviation) не ваш факультет!", message: "Вы не можете выбрать группу факультета \(self.viewModel.facultyItem(index: indexPath.row).abbreviation) поскольку не относитесь к нему.", actions: [ok])
                }
            }
            
            let checkSubGroupAction = UIAction(title: self.viewModel.isSubGroupSelected(index: indexPath.row) ? "Выбрана подгруппа" : "Выбрать подгруппу", image: self.viewModel.isSubGroupSelected(index: indexPath.row) ? UIImage(named: "check") : nil) { _ in
                if self.viewModel.isFacultySelected(index: indexPath.row) {
                    let vc = SavedSubGroupTableViewController()
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    NotificationCenter.default.post(name: Notification.Name("group"), object: nil)
                    let ok = UIAlertAction(title: "ОК", style: .default)
                    self.showAlert(title: "\(self.viewModel.facultyItem(index: indexPath.row).abbreviation) не ваш факультет!", message: "Вы не можете выбрать подгруппу факультета \(self.viewModel.facultyItem(index: indexPath.row).abbreviation) поскольку не относитесь к нему.", actions: [ok])
                }
            }
            
            let cancelIconAction = UIAction(title: "Отменить иконку", image: self.viewModel.isFacultySelected(index: indexPath.row) ? UIImage(named: "cancel") : nil) { action in
                self.viewModel.cancelFacultyIcon(index: indexPath.row)
            }
            
            let cancelFacultyAction = UIAction(title: "Отменить факультет", image: self.viewModel.isFacultySelected(index: indexPath.row) ? UIImage(named: "cancel") : nil) { _ in
                self.viewModel.cancelFaculty(index: indexPath.row)
            }
            
            return UIMenu(title: self.viewModel.facultyItem(index: indexPath.row).name, children: [
                chooseFacultyAction,
                chooseIconAction,
                cathedraAction,
                checkGroupAction,
                checkSubGroupAction,
                cancelIconAction,
                cancelFacultyAction
            ])
        })
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showHintAlert(type: .faculty)
        HapticsManager.shared.hapticFeedback()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.facultiesListCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AGPUFacultyTableViewCell.identifier, for: indexPath) as? AGPUFacultyTableViewCell else {return UITableViewCell()}
        let faculty = viewModel.facultyItem(index: indexPath.row)
        cell.delegate = self
        cell.AGPUFacultyName.textColor = viewModel.isFacultySelected(index: indexPath.row) ? .systemGreen : .label
        cell.accessoryType = viewModel.isFacultySelected(index: indexPath.row) ? .checkmark : .none
        cell.configure(faculty: faculty)
        return cell
    }
}

extension SelectedFacultyListTableViewController: AGPUFacultyTableViewCellDelegate {
    
    func openFacultyInfo(faculty: AGPUFacultyModel) {
        self.goToWeb(url: faculty.url, image: faculty.icon, title: faculty.abbreviation, isSheet: false, isNotify: false)
        HapticsManager.shared.hapticFeedback()
    }
}
