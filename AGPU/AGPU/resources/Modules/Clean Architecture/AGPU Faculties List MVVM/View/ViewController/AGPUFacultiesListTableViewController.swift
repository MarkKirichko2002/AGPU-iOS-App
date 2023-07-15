//
//  AGPUFacultiesListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 11.07.2023.
//

import UIKit

class AGPUFacultiesListTableViewController: UITableViewController {

    private let viewModel = AGPUFacultiesListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "АГПУ Факультеты"
        tableView.register(UINib(nibName: AGPUFacultyTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: AGPUFacultyTableViewCell.identifier)
    }
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil,
                                          actionProvider: {
            _ in
            
            let infoAction = UIAction(title: "узнать больше", image: UIImage(named: "info")) { _ in
                self.GoToWeb(url: self.viewModel.facultyItem(index: indexPath.row).url, title: self.viewModel.facultyItem(index: indexPath.row).abbreviation, isSheet: true)
            }
            
            let watchVideoAction =  UIAction(title: "смотреть видео", image: UIImage(named: "video")) { _ in
                self.PlayVideo(url: self.viewModel.facultyItem(index: indexPath.row).videoURL)
            }
            
            let phoneAction = self.viewModel.makePhoneNumbersMenu(index: indexPath.row)
            
            let groupsAction = UIAction(title: "список групп", image: UIImage(named: "group")) { _ in
                let vc = FacultyGroupsListTableViewController(faculty: self.viewModel.facultyItem(index: indexPath.row))
                let navVC = UINavigationController(rootViewController: vc)
                self.present(navVC, animated: true)
            }
            
            let emailAction = UIAction(title: "написать", image: UIImage(named: "mail")) { _ in
                self.showEmailComposer(email: self.viewModel.facultyItem(index: indexPath.row).email)
            }
            
            let enterAction = UIAction(title: "поступить", image: UIImage(named: "worksheet")) { _ in
                self.GoToWeb(url: "http://priem.agpu.net/anketa/index.php", title: "Анкета", isSheet: true)
            }
            
            return UIMenu(title: self.viewModel.facultyItem(index: indexPath.row).name, children: [
                infoAction,
                groupsAction,
                watchVideoAction,
                emailAction,
                phoneAction,
                enterAction
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
        cell.configure(faculty: viewModel.facultyItem(index: indexPath.row))
        return cell
    }
}
