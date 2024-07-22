//
//  CorpsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 23.07.2024.
//

import UIKit

protocol CorpsListTableViewControllerDelegate: AnyObject {
    func audienceWasSelected(audience: String)
}

class CorpsListTableViewController: UITableViewController {

    var corps = AGPUBuildings.buildings
    
    weak var delegate: CorpsListTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
    }
    
    private func setUpNavigation() {
        navigationItem.title = "Корпуса"
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let corp = corps[indexPath.row]
        let vc = AudenciesListTableViewController(name: corp.name, audencies: corp.audiences)
        vc.isSection = true
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
        HapticsManager.shared.hapticFeedback()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return corps.count - 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let corp = corps[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = corp.name
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        return cell
    }
}

// MARK: - AudenciesListTableViewControllerDelegate
extension CorpsListTableViewController: AudenciesListTableViewControllerDelegate {
    
    func audienceSelected(audience: String) {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.delegate?.audienceWasSelected(audience: audience)
            self.dismiss(animated: true)
        }
    }
}
