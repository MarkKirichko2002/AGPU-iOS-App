//
//  TimetableFeaturesOptionsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 27.10.2024.
//

import UIKit

class TimetableFeaturesOptionsListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
    }
    
    private func setUpNavigation() {
        let titleView = CustomTitleView(image: "star", title: "Фишки расписания", frame: .zero)
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .plain, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .label
        navigationItem.titleView = titleView
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
    }
    
    private func setUpTable() {
        tableView.register(UINib(nibName: TimetableFeatureOptionTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TimetableFeatureOptionTableViewCell.identifier)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = TimetableOptionsListTableViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            HapticsManager.shared.hapticFeedback()
        case 1:
            let vc = PairInfoOptionsListTableViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            HapticsManager.shared.hapticFeedback()
        case 2:
            let vc = SmartCalendarOptionsListTableViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            HapticsManager.shared.hapticFeedback()
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TimetableFeatures.features.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TimetableFeatureOptionTableViewCell.identifier, for: indexPath) as? TimetableFeatureOptionTableViewCell else {return UITableViewCell()}
        cell.configure(feature: TimetableFeatures.features[indexPath.row])
        return cell
    }
}
