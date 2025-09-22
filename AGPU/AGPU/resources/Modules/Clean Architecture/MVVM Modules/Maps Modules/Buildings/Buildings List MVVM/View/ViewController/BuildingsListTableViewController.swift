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

final class BuildingsListTableViewController: UITableViewController {
    
    weak var delegate: BuildingsListTableViewControllerDelegate?
    
    private let viewModel: BuildingsListViewModel
    
    // MARK: - Init
    init(currentLocation: MKAnnotation, annotations: [MKAnnotation]) {
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
        let titleView = CustomTitleView(image: "building", title: "Здания", frame: .zero)
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .plain, target: self, action: #selector(closeScreen))
        let menu = UIBarButtonItem(image: UIImage(named: "sections"), menu: viewModel.createTransportTypeMenu())
        closeButton.tintColor = .label
        menu.tintColor = .label
        navigationItem.titleView = titleView
        navigationItem.rightBarButtonItem = menu
        navigationItem.leftBarButtonItem = closeButton
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        self.dismiss(animated: true)
    }
    
    private func setUpTable() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func bindViewModel() {
        
        viewModel.registerDataChangedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        viewModel.registerSelectedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            self.delegate?.buildingWasSelected(location: (self.viewModel.buildings[self.viewModel.index].annotation, self.viewModel.index))
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                self.dismiss(animated: true)
            }
        }
        
        viewModel.registerTransportTypeHandler {
            DispatchQueue.main.async {
                self.setUpNavigation()
            }
        }
        viewModel.getData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectBuilding(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil,
                                          actionProvider: {
            _ in
            
            let infoAction = UIAction(title: "Подробнее", image: UIImage(named: "info")) { _ in
                let storyboard = UIStoryboard(name: "AGPUBuildingDetailViewController", bundle: nil)
                if let vc = storyboard.instantiateViewController(withIdentifier: "AGPUBuildingDetailViewController") as? AGPUBuildingDetailViewController {
                    vc.annotation = self.viewModel.buildingItem(index: indexPath.row).annotation
                    vc.id = UserDefaults.standard.object(forKey: "group") as? String ?? "ВМ-ИВТ-4-1"
                    vc.owner = "GROUP"
                    let navVC = UINavigationController(rootViewController: vc)
                    navVC.modalPresentationStyle = .fullScreen
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                        self.present(navVC, animated: true)
                    }
                }
            }
            
            let shareAction = UIAction(title: "Поделиться", image: UIImage(named: "share")) { _ in
                let vc = ShareLocationAppsViewController(annotation: self.viewModel.buildingItem(index: indexPath.row).annotation)
                vc.modalPresentationStyle = .fullScreen
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                    self.present(vc, animated: true)
                }
            }
            
            return UIMenu(title: "Здание", children: [
                infoAction,
                shareAction
            ])
        })
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.buildingItemsCountInSection()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.tintColor = .systemGreen
        cell.textLabel?.text = viewModel.configureItem(index: indexPath.row)
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        cell.textLabel?.textColor = viewModel.isBuildingSelected(index: indexPath.row) ? .systemGreen : .label
        cell.textLabel?.numberOfLines = 0
        cell.accessoryType = viewModel.isBuildingSelected(index: indexPath.row) ? .checkmark : .none
        return cell
    }
}
