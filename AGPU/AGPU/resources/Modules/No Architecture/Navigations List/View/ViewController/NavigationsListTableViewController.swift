//
//  NavigationsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 30.01.2025.
//

import UIKit

final class NavigationsListTableViewController: UITableViewController {

    var screen: NavigationScreen
    
    init(screen: NavigationScreen) {
        self.screen = screen
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
    }
    
    private func setUpNavigation() {
        let titleView = CustomTitleView(image: "right icon", title: "Навигация/управление", frame: .zero)
        setUpCloseButton()
        navigationItem.titleView = titleView
    }
    
    func setUpCloseButton() {
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .done, target: self, action: #selector(close))
        closeButton.tintColor = .label
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func close() {
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
    }
    
    private func setUpTable() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleNavigation(index: indexPath.row)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return screen.ways.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let command = screen.ways[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let view = UIView()
        view.backgroundColor = .clear
        cell.selectedBackgroundView = view
        cell.textLabel?.text = command.name
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        cell.detailTextLabel?.text = command.description
        cell.detailTextLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        cell.detailTextLabel?.numberOfLines = 0
        return cell
    }
    
    private func handleNavigation(index: Int) {
        if index == 1 && screen == .timetableDay {
            let vc = VoiceCommandsListTableViewController(type: .timetableDay)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
            HapticsManager.shared.hapticFeedback()
        } else if index == 1 && screen == .timetableWeek {
            let vc = VoiceCommandsListTableViewController(type: .timetableWeek)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
            HapticsManager.shared.hapticFeedback()
        } else if index == 1 && screen == .timetableAR {
            let vc = VoiceCommandsListTableViewController(type: .timetableAR)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
            HapticsManager.shared.hapticFeedback()
        }
    }
}
