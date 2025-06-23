//
//  GlanceInfoOptionsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 17.06.2025.
//

import UIKit

final class GlanceInfoOptionsListTableViewController: UITableViewController {
    
    // MARK: - сервисы
    private let viewModel = GlanceInfoOptionsListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        let titleView = CustomTitleView(image: "eye", title: "Информация", frame: .zero)
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
        tableView.register(UINib(nibName: GlanceInfoOptionsTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: GlanceInfoOptionsTableViewCell.identifier)
    }
    
    private func bindViewModel() {
        viewModel.registerDataChangedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        viewModel.getAllData()
        viewModel.observeOptionSelection()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            let vc = ScreenPresentationStylesTableViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            HapticsManager.shared.hapticFeedback()
        case 1:
            break
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: GlanceInfoOptionsTableViewCell.identifier, for: indexPath) as? GlanceInfoOptionsTableViewCell else {return UITableViewCell()}
            cell.configure(option: viewModel.options[indexPath.row])
            return cell
        default:
            return UITableViewCell()
        }
    }
}
