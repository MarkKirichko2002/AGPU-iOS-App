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
    var selectedAudencie = ""
    
    var isSection = false
    var isInfo = false
    
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
    
    // MARK: - сервисы
    private let dateManager = DateManager()
    private let settingsManager = SettingsManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        setUpData()
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
    
    private func setUpData() {
        selectedAudencie = settingsManager.getSavedID()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let audencie = audencies[indexPath.row]
        if isSection {
            selectedAudencie = audencie
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                self.delegate?.audienceSelected(audience: audencie)
                self.navigationController?.popViewController(animated: true)
            }
            tableView.reloadData()
        } else if isInfo {
            delegate?.audienceSelected(audience: audencies[indexPath.row])
            dismiss(animated: true)
        } else {
            showTimetable(index: indexPath.row)
        }
        HapticsManager.shared.hapticFeedback()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audencies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.tintColor = .systemGreen
        cell.textLabel?.text = audencies[indexPath.row]
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        cell.textLabel?.textColor = audencies[indexPath.row] == selectedAudencie ? .systemGreen : .label
        cell.accessoryType =  audencies[indexPath.row] == selectedAudencie ? .checkmark : .none
        return cell
    }
    
    func showTimetable(index: Int) {
        let vc = CurrentDateTimeTableDayListTableViewController(id: audencies[index], date: dateManager.getCurrentDate(), owner: "CLASSROOM")
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
}
