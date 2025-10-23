//
//  TimetableFilterCategoriesListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 08.03.2025.
//

import UIKit

enum filterCategories: String, CaseIterable {
    case types = "Типы пары"
    case buildings = "Корпуса"
    case times = "Время"
}

protocol TimetableFilterCategoriesListTableViewControllerDelegate: AnyObject {
    func pairTypeWasSelected(type: PairType)
    func buildingWasSelected(building: AGPUBuildingModel)
    func timeWasSelected(time: String)
}

final class TimetableFilterCategoriesListTableViewController: UITableViewController {

    weak var delegate: TimetableFilterCategoriesListTableViewControllerDelegate?
    
    var date: String
    var type: PairType
    var disciplines: [Discipline]
    var building: AGPUBuildingModel?
    var time: String?
    var isSection = false
    
    // MARK: - Init
    init(date: String, type: PairType, disciplines: [Discipline], building: AGPUBuildingModel?, time: String?) {
        self.date = date
        self.type = type
        self.disciplines = disciplines
        self.building = building
        self.time = time
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
        let titleView = CustomTitleView(image: "filter", title: "Категории", frame: .zero)
        if isSection {
            setUpBackButton()
        } else {
            setUpCloseButton()
        }
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterCategories.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = filterCategories.allCases[indexPath.row]
        switch category {
        case .types:
            openFilterOptionsList()
        case .buildings:
            openBuildingsList()
        case .times:
            openTimesList()
        }
        HapticsManager.shared.hapticFeedback()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = filterCategories.allCases[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        switch category {
        case .types:
            cell.textLabel?.text = "\(category.rawValue) (\(type.title))"
        case .buildings:
            if let building = building {
                cell.textLabel?.text = "\(category.rawValue) (\(building.name))"
            } else {
                cell.textLabel?.text = "\(category.rawValue) (Не выбрано)"
            }
        case .times:
            if let time = time {
                if !time.isEmpty {
                    cell.textLabel?.text = "\(category.rawValue) (\(time))"
                } else {
                    cell.textLabel?.text = "\(category.rawValue) (Не выбрано)"
                }
            } else {
                cell.textLabel?.text = "\(category.rawValue) (Не выбрано)"
            }
        }
        return cell
    }
    
    func openFilterOptionsList() {
        let vc = PairTypesListTableViewController(date: date, type: type, disciplines: disciplines)
        vc.isWeekDay = true
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func openBuildingsList() {
        let vc = CorpsListTableViewController()
        vc.disciplines = disciplines
        vc.selectedCorp = building
        vc.isSection = true
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func openTimesList() {
        let vc = PairTimeFilterListListViewController(time: time ?? "", times: disciplines.map {$0.time})
        vc.disciplines = disciplines
        vc.isSection = true
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - PairTypesListTableViewControllerDelegate
extension TimetableFilterCategoriesListTableViewController: PairTypesListTableViewControllerDelegate {
    
    func pairTypeWasSelected(type: PairType) {
        self.type = type
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.delegate?.pairTypeWasSelected(type: type)
            if self.isSection {
                self.navigationController?.popToRootViewController(animated: true)
            } else {
                self.dismiss(animated: true)
            }
        }
        refreshTable()
    }
}

// MARK: - CorpsListTableViewControllerDelegate
extension TimetableFilterCategoriesListTableViewController: CorpsListTableViewControllerDelegate {
    func audienceWasSelected(audience: String) {
        if let building = AGPUBuildings.buildings.first(where: { $0.audiences.contains(audience) }) {
            self.building = building
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                self.delegate?.buildingWasSelected(building: building)
                if self.isSection {
                    self.navigationController?.popToRootViewController(animated: true)
                } else {
                    self.dismiss(animated: true)
                }
            }
            refreshTable()
        }
    }
}

// MARK: - PairTimeFilterListListViewControllerDelegate
extension TimetableFilterCategoriesListTableViewController: PairTimeFilterListListViewControllerDelegate {
    
    func timeWasSelected(time: String) {
        self.time = time
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.delegate?.timeWasSelected(time: time)
            if self.isSection {
                self.navigationController?.popToRootViewController(animated: true)
            } else {
                self.dismiss(animated: true)
            }
        }
        refreshTable()
    }
}

extension TimetableFilterCategoriesListTableViewController {
    
    func refreshTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
