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

final class CorpsListTableViewController: UITableViewController {

    var corps = AGPUBuildings.buildings
    var selectedCorp: AGPUBuildingModel?
    var isSection = false
    var disciplines = [Discipline]()
    weak var delegate: CorpsListTableViewControllerDelegate?
    
    // MARK: - сервисы
    let settingsManager = SettingsManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
    }
    
    private func setUpNavigation() {
        let titleView = CustomTitleView(image: "building", title: "Корпуса", frame: .zero)
        navigationItem.titleView = titleView
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
    
    private func setUpTable() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectCorp(building: corps[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return corps.count - 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let corp = corps[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.tintColor = .systemGreen
        cell.textLabel?.text = corp.name
        cell.textLabel?.textColor = isCorpSelected(index: indexPath.row) ? .systemGreen : .label
        cell.detailTextLabel?.text = isSection ? "Количество пар: \(pairsCount(building: corp))" : nil
        cell.detailTextLabel?.textColor = isCorpSelected(index: indexPath.row) ? .systemGreen : .label
        cell.detailTextLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        cell.detailTextLabel?.numberOfLines = 0
        cell.accessoryType = isCorpSelected(index: indexPath.row) ? .checkmark : .none
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        return cell
    }
    
    func selectCorp(building: AGPUBuildingModel) {
        if isSection {
            self.selectedCorp = building
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                self.delegate?.audienceWasSelected(audience: building.audiences[0])
                self.navigationController?.popToRootViewController(animated: true)
            }
            self.tableView.reloadData()
        } else {
            self.openRoomsList(corp: building)
        }
        HapticsManager.shared.hapticFeedback()
    }
    
    func isCorpSelected(index: Int)-> Bool {
        let id = settingsManager.getSavedID()
        return corps[index].name == selectedCorp?.name || corps[index].audiences.contains(id)
    }
    
    func pairsCount(building: AGPUBuildingModel)-> Int {
        var disciplines = [Discipline]()
        var uniqueTimes: Set<String> = Set()
        for audience in building.audiences {
            for pair in self.disciplines {
                if audience == pair.audienceID {
                    disciplines.append(pair)
                }
            }
        }
        
        for pair in disciplines {
            
            let times = pair.time.components(separatedBy: "-")
            let startTime = times[0]
                            
            uniqueTimes.insert(startTime)
        }
        
        return uniqueTimes.count
        
    }
    
    func openRoomsList(corp: AGPUBuildingModel) {
        let corp = corp
        let vc = AudenciesListTableViewController(name: corp.name, audencies: corp.audiences)
        vc.isSection = true
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
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
