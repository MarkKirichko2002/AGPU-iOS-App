//
//  ASPUButtonOptionsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 30.03.2024.
//

import UIKit

final class ASPUButtonOptionsListTableViewController: UITableViewController {

    // MARK: - сервисы
    private let viewModel = ASPUButtonOptionsListViewModel()
    var isNotify = false
    var isSettings = false
    weak var delegate: ScreenClosedDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        let titleView = CustomTitleView(image: "button", title: "АГПУ кнопка", frame: .zero)
        navigationItem.titleView = titleView
        if isSettings {
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
        if isNotify {
            delegate?.screenWasClosed()
        } else {
            HapticsManager.shared.hapticFeedback()
        }
        self.dismiss(animated: true)
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
        tableView.register(UINib(nibName: ASPUButtonIconOptionTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ASPUButtonIconOptionTableViewCell.identifier)
        tableView.register(UINib(nibName: ASPUButtonActionsOptionTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ASPUButtonActionsOptionTableViewCell.identifier)
        tableView.register(UINib(nibName: ASPUButtonAnimationOptionTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ASPUButtonAnimationOptionTableViewCell.identifier)
        tableView.register(UINib(nibName: ASPUButtonGesturesOptionTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ASPUButtonGesturesOptionTableViewCell.identifier)
    }
    
    private func bindViewModel() {
        viewModel.observeOptionSelected()
        viewModel.registerDataChangedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = ASPUButtonIconsListTableViewController()
            navigationController?.pushViewController(vc, animated: true)
            HapticsManager.shared.hapticFeedback()
        case 1:
            let vc = ASPUButtonActionsListTableViewController()
            navigationController?.pushViewController(vc, animated: true)
            HapticsManager.shared.hapticFeedback()
        case 2:
            let vc = ASPUButtonAnimationOptionsListTableViewController()
            navigationController?.pushViewController(vc, animated: true)
            HapticsManager.shared.hapticFeedback()
        case 3:
            let vc = ASPUButtonGestureOptionsListTableViewController()
            navigationController?.pushViewController(vc, animated: true)
            HapticsManager.shared.hapticFeedback()
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)-> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ASPUButtonIconOptionTableViewCell.identifier, for: indexPath) as? ASPUButtonIconOptionTableViewCell else {return UITableViewCell()}
            cell.configure(action: viewModel.getASPUButtonIconInfo())
            return cell
        } else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ASPUButtonActionsOptionTableViewCell.identifier, for: indexPath) as? ASPUButtonActionsOptionTableViewCell else {return UITableViewCell()}
            cell.configure(action: viewModel.getASPUButtonActionInfo())
            return cell
        } else if indexPath.row == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ASPUButtonAnimationOptionTableViewCell.identifier, for: indexPath) as? ASPUButtonAnimationOptionTableViewCell else {return UITableViewCell()}
            cell.configure(option: viewModel.getASPUButtonAnimationOptionInfo())
            return cell
        } else if indexPath.row == 3 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ASPUButtonGesturesOptionTableViewCell.identifier, for: indexPath) as? ASPUButtonGesturesOptionTableViewCell else {return UITableViewCell()}
            cell.configure(gesture: viewModel.getASPUButtonGestureOptionInfo())
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
