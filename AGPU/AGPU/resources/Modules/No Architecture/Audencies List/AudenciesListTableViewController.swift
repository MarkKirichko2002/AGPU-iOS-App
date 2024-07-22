//
//  AudenciesListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 15.07.2024.
//

import UIKit

protocol AudenciesListTableViewControllerDelegate: AnyObject {
    func audienceSelected(audience: String)
}

final class AudenciesListTableViewController: UITableViewController {

    var name: String = ""
    var audencies = [String]()
    
    var isSection = false
    
    weak var delegate: AudenciesListTableViewControllerDelegate?
    
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
        if isSection {
            setUpBackButton()
        } else {
            setUpCloseButton()
        }
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
    
    func setUpBackButton() {
        
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        let backButton = UIBarButtonItem(customView: button)
        
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
    }
    
    private func setUpTable() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.audienceSelected(audience: audencies[indexPath.row])
        navigationController?.popViewController(animated: true)
        HapticsManager.shared.hapticFeedback()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audencies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = audencies[indexPath.row]
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        return cell
    }
}
