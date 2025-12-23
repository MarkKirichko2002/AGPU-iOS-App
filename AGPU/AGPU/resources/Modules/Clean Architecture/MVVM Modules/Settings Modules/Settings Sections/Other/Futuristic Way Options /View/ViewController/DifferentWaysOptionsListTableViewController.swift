//
//  DifferentWaysOptionsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 05.12.2025.
//

import UIKit

final class DifferentWaysOptionsListTableViewController: UITableViewController {
    
    var ways = differentWays.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
    }
    
    private func setUpNavigation() {
        let titleView = CustomTitleView(image: "box", title: "Способы управления", frame: .zero)
        navigationItem.titleView = titleView
        setUpCloseButton()
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
        tableView.register(WayTableViewCell.self, forCellReuseIdentifier: WayTableViewCell.identifier)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DifferentWaysScreenListTableViewController(way: ways[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
        HapticsManager.shared.hapticFeedback()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ways.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WayTableViewCell.identifier, for: indexPath) as? WayTableViewCell else {return UITableViewCell()}
        cell.configure(way: ways[indexPath.row])
        return cell
    }
}
