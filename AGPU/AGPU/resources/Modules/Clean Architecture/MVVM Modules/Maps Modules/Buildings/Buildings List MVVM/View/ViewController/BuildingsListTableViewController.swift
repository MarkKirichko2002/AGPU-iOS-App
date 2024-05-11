//
//  BuildingsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 11.05.2024.
//

import UIKit
import MapKit

protocol BuildingsListTableViewControllerDelegate: AnyObject {
    func buildingWasSelected(location: (MKAnnotation, Int))
}

class BuildingsListTableViewController: UITableViewController {
    
    weak var delegate: BuildingsListTableViewControllerDelegate?
    
    private let viewModel: BuildingsListViewModel
    
    // MARK: - Init
    init(currentLocation: MKAnnotation, annotations:[MKAnnotation]) {
        self.viewModel = BuildingsListViewModel(currentLocation: currentLocation, buildings: annotations)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .plain, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .label
        navigationItem.title = "Здания"
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        self.dismiss(animated: true)
    }
    
    private func setUpTable() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func bindViewModel() {
        viewModel.registerSelectedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            self.delegate?.buildingWasSelected(location: (self.viewModel.currentLocation!, self.viewModel.index))
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                self.dismiss(animated: true)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectBuilding(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.buildingItemsCountInSection()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let building = viewModel.buildingItem(index: indexPath.row)
        cell.tintColor = .systemGreen
        cell.textLabel?.text = building.title!
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        cell.textLabel?.textColor = viewModel.isBuildingSelected(index: indexPath.row) ? .systemGreen : .label
        cell.accessoryType = viewModel.isBuildingSelected(index: indexPath.row) ? .checkmark : .none
        return cell
    }
}
