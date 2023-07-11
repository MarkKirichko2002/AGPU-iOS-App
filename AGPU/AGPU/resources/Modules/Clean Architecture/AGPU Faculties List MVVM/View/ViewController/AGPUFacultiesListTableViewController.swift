//
//  AGPUFacultiesListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 11.07.2023.
//

import UIKit

class AGPUFacultiesListTableViewController: UITableViewController {

    @objc private let viewModel = AGPUFacultiesListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "АГПУ Факультеты"
        tableView.register(UINib(nibName: ElectedFacultyTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ElectedFacultyTableViewCell.identifier)
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.observation = observe(\.viewModel.isChanged) { _, _ in
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil,
                                          actionProvider: {
            _ in
            
            let infoAction = UIAction(title: "узнать больше", image: UIImage(named: "info")) { _ in
                self.GoToWeb(url: self.viewModel.electedFacultyItem(index: indexPath.row).url, title: self.viewModel.electedFacultyItem(index: indexPath.row).abbreviation)
            }
            
            let watchVideoAction =  UIAction(title: "смотреть видео", image: UIImage(named: "video")) { _ in
                self.PlayVideo(url: self.viewModel.electedFacultyItem(index: indexPath.row).videoURL)
            }
            
            let phoneAction = self.viewModel.makePhoneNumbersMenu(index: indexPath.row)
            
            let emailAction = UIAction(title: "написать", image: UIImage(named: "mail")) { _ in
                self.showEmailComposer(email: self.viewModel.electedFacultyItem(index: indexPath.row).email)
            }
            
            let iconAction = UIAction(title: "выбрать иконку", image: UIImage(named: "photo")) { _ in
                self.viewModel.ChangeIcon(index: indexPath.row)
            }
            
            let enterAction = UIAction(title: "поступить", image: UIImage(named: "worksheet")) { _ in
                self.GoToWeb(url: "http://priem.agpu.net/anketa/index.php", title: "Анкета")
            }
            
            return UIMenu(title: self.viewModel.electedFacultyItem(index: indexPath.row).name, children: [infoAction, watchVideoAction, emailAction, phoneAction, enterAction, iconAction])
            
        })
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.facultiesListCount()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ElectedFacultyTableViewCell.identifier, for: indexPath) as? ElectedFacultyTableViewCell else {return UITableViewCell()}
        cell.accessoryType = viewModel.isIconSelected(index: indexPath.row)
        cell.tintColor = .systemGreen
        cell.configure(faculty: viewModel.electedFacultyItem(index: indexPath.row))
        return cell
    }
}
