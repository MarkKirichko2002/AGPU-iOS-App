//
//  AGPUFacultiesListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 11.07.2023.
//

import UIKit

final class AGPUFacultiesListTableViewController: UITableViewController {

    private let viewModel = AGPUFacultiesListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUpNavigation()
        tableView.register(UINib(nibName: AGPUFacultyTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: AGPUFacultyTableViewCell.identifier)
    }
    
    private func SetUpNavigation() {
        navigationItem.title = "Факультеты"
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .black
        navigationItem.leftBarButtonItem = closeButton
    }
    
    @objc private func closeScreen() {
         dismiss(animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.post(name: Notification.Name("for student appear"), object: nil)
    }
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil,
                                          actionProvider: {
            _ in
            
            let infoAction = UIAction(title: "узнать больше", image: UIImage(named: "info")) { _ in
                self.GoToWeb(url: self.viewModel.facultyItem(index: indexPath.row).url, title: self.viewModel.facultyItem(index: indexPath.row).abbreviation, isSheet: false)
            }
            
            let cathedraAction = UIAction(title: "кафедры", image: UIImage(named: "university")) { _ in
                let vc = FacultyCathedraListTableViewController(faculty: self.viewModel.facultyItem(index: indexPath.row))
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            let watchVideoAction = UIAction(title: "смотреть видео", image: UIImage(named: "video")) { _ in
                self.PlayVideo(url: self.viewModel.facultyItem(index: indexPath.row).videoURL)
            }
            
            let groupsAction = UIAction(title: "список групп", image: UIImage(named: "group")) { _ in
                let vc = FacultyGroupsListTableViewController(faculty: self.viewModel.facultyItem(index: indexPath.row))
                let navVC = UINavigationController(rootViewController: vc)
                self.present(navVC, animated: true)
            }
            
            let contactsAction = UIAction(title: "контакты", image: UIImage(named: "contacts")) { _ in
                let vc = FacultyContactsListTableViewController(faculty: self.viewModel.facultyItem(index: indexPath.row))
                let navVC = UINavigationController(rootViewController: vc)
                self.present(navVC, animated: true)
            }
            
            let emailAction = UIAction(title: "написать", image: UIImage(named: "mail")) { _ in
                self.showEmailComposer(email: self.viewModel.facultyItem(index: indexPath.row).email)
            }
            
            let enterAction = UIAction(title: "поступить", image: UIImage(named: "worksheet")) { _ in
                self.GoToWeb(url: "http://priem.agpu.net/anketa/index.php", title: "Анкета", isSheet: false)
            }
            
            let shareAction = UIAction(title: "поделиться", image: UIImage(named: "share")) { _ in
                self.shareInfo(image: UIImage(named: self.viewModel.facultyItem(index: indexPath.row).icon)!, title: self.viewModel.facultyItem(index: indexPath.row).abbreviation, text: self.viewModel.facultyItem(index: indexPath.row).url)
            }
            
            return UIMenu(title: self.viewModel.facultyItem(index: indexPath.row).name, children: [
                infoAction,
                cathedraAction,
                watchVideoAction,
                contactsAction,
                emailAction,
                groupsAction,
                enterAction,
                shareAction
            ])
        })
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.facultiesListCount()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AGPUFacultyTableViewCell.identifier, for: indexPath) as? AGPUFacultyTableViewCell else {return UITableViewCell()}
        cell.accessoryType = viewModel.isFacultySelected(index: indexPath.row) ? .checkmark : .none
        cell.tintColor = .systemGreen
        cell.AGPUFacultyName.textColor = viewModel.isFacultySelected(index: indexPath.row) ? .systemGreen : .black
        cell.configure(faculty: viewModel.facultyItem(index: indexPath.row))
        return cell
    }
}
