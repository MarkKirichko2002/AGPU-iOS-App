//
//  PairInfoOptionsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 27.10.2024.
//

import UIKit

class PairInfoOptionsListTableViewController: UITableViewController {

    var options = TimetableOptions.pairInfoOptions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
    }
    
    private func setUpNavigation() {
        let titleView = CustomTitleView(image: "info icon", title: "Экран с парой", frame: .zero)
        navigationItem.titleView = titleView
        setUpBackButton()
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
        tableView.register(UINib(nibName: TimetableOptionsTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TimetableOptionsTableViewCell.identifier)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = TimeTableSoundsListTableViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            HapticsManager.shared.hapticFeedback()
        default:
            break
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TimetableOptionsTableViewCell.identifier, for: indexPath) as? TimetableOptionsTableViewCell else {return UITableViewCell()}
        cell.configure(option: options[indexPath.row])
        return cell
    }
}
