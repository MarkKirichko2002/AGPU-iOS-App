//
//  VoiceCommandsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 18.12.2024.
//

import UIKit

final class VoiceCommandsListTableViewController: UITableViewController {

    var type: VoiceCommandsType
    weak var screenDelegate: ScreenClosedDelegate?
    
    init(type: VoiceCommandsType) {
        self.type = type
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
        let titleView = CustomTitleView(image: "microphone", title: "Голосовые команды", frame: .zero)
        setUpCloseButton()
        navigationItem.titleView = titleView
    }
    
    func setUpCloseButton() {
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .done, target: self, action: #selector(close))
        closeButton.tintColor = .label
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func close() {
        screenDelegate?.screenWasClosed()
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
    }
    
    private func setUpTable() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return type.commands.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let command = type.commands[indexPath.row]
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
}
