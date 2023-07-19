//
//  CustomMusicListViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 12.07.2023.
//

import UIKit

class CustomMusicListViewController: UITableViewController {

    // MARK: - сервисы
    @objc private let viewModel = CustomMusicListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUpNavigation()
        SetUpTable()
        BindViewModel()
    }

    private func SetUpNavigation() {
        let titleView = CustomTitleView(
            image: "music",
            title: "Своя Музыка",
            frame: .zero
        )
        let add = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(AddMusic))
        add.tintColor = .black
        self.navigationItem.titleView = titleView
        self.navigationItem.rightBarButtonItem = add
    }
    
    private func SetUpTable() {
        tableView.register(UINib(nibName: CustomMusicTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: CustomMusicTableViewCell.identifier)
    }
    
    private func BindViewModel() {
        viewModel.observation = observe(\.viewModel.isChanged) { _, _ in
            self.tableView.reloadData()
        }
    }
    
    @objc private func AddMusic() {
        let storyboard = UIStoryboard(name: "AddMusicViewController", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "AddMusicViewController") as? AddMusicViewController {
            present(vc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil,
                                          actionProvider: {
            _ in
           
            let playAction = UIAction(title: "воспроизвести", image: UIImage(named: "play")) { _ in
                self.viewModel.OnMusic(index: indexPath.row)
            }
            let pauseAction = UIAction(title: "пауза", image: UIImage(named: "pause")) { _ in
                self.viewModel.OffMusic(index: indexPath.row)
            }
            let restartAction = UIAction(title: "заново", image: UIImage(named: "restart")) { _ in
                self.viewModel.RestartMusic(index: indexPath.row)
            }
            let deleteAction = UIAction(title: "удалить", image: UIImage(named: "trash")) { _ in
                self.viewModel.DeleteMusic(index: indexPath.row)
            }
            return UIMenu(title: self.viewModel.musicItem(index: indexPath.row).name, children: [playAction, pauseAction, restartAction, deleteAction])
        })
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        switch indexPath.section {
        case 0:
            let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
                self.viewModel.DeleteMusic(index: indexPath.row)
            }
            deleteAction.image = UIImage(systemName: "trash")
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            return configuration
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.musicList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomMusicTableViewCell.identifier, for: indexPath) as? CustomMusicTableViewCell else {return UITableViewCell()}
        cell.accessoryType = viewModel.isMusicSelected(index: indexPath.row)
        cell.tintColor = .systemGreen
        cell.configure(music: viewModel.musicItem(index: indexPath.row))
        return cell
    }
}
