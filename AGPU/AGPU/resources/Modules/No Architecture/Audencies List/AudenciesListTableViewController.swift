//
//  AudenciesListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 15.07.2024.
//

import UIKit

class AudenciesListTableViewController: UITableViewController {

    var name: String = ""
    var audencies = [String]()
    
    // MARK: - Init
    init(name: String, audencies: [String]) {
        self.name = name
        self.audencies = audencies
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
        navigationItem.title = name
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .plain, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .label
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
    }
    
    private func setUpTable() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CurrentDateTimeTableDayListTableViewController(id: audencies[indexPath.row], date: DateManager().getCurrentDate(), owner: "CLASSROOM")
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
        HapticsManager.shared.hapticFeedback()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audencies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = audencies[indexPath.row]
        return cell
    }
}
