//
//  PairTimeFilterListListViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 10.03.2025.
//

import UIKit

protocol PairTimeFilterListListViewControllerDelegate: AnyObject {
    func timeWasSelected(time: String)
}

final class PairTimeFilterListListViewController: UIViewController {

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private let noTimesLabel = UILabel()
    
    weak var delegate: PairTimeFilterListListViewControllerDelegate?
    var times: [String]
    var selectedTime = ""
    
    init(time: String, times: [String]) {
        self.selectedTime = time
        self.times = times
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTableView()
        setUpLabel()
        setUpData()
    }
    
    private func setUpNavigation() {
        navigationItem.title = "Список времени"
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
    
    private func setUpTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setUpLabel() {
        view.addSubview(noTimesLabel)
        noTimesLabel.text = "Нет времени"
        noTimesLabel.font = .systemFont(ofSize: 18, weight: .medium)
        noTimesLabel.isHidden = true
        noTimesLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noTimesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noTimesLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setUpData() {
        self.times = removeDublicates()
        if !times.isEmpty {
            self.noTimesLabel.isHidden = true
        } else {
            self.noTimesLabel.isHidden = false
        }
    }
    
    func removeDublicates()-> [String] {
        var arr = [String]()
        for time in times {
            if !arr.contains(time) {
                arr.append(time)
            }
        }
        return arr
    }
}

// MARK: - UITableViewDelegate
extension PairTimeFilterListListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectTime(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension PairTimeFilterListListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return times.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.tintColor = .systemGreen
        cell.textLabel?.text = times[indexPath.row]
        cell.textLabel?.textColor = isTimeSelected(index: indexPath.row) ? .systemGreen : .label
        cell.accessoryType = isTimeSelected(index: indexPath.row) ? .checkmark : .none
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        return cell
    }
}

extension PairTimeFilterListListViewController {
    
    func selectTime(index: Int) {
        selectedTime = times[index]
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.delegate?.timeWasSelected(time: self.times[index])
            self.navigationController?.popToRootViewController(animated: true)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        HapticsManager.shared.hapticFeedback()
    }
    
    func isTimeSelected(index: Int)-> Bool {
        return times[index] == selectedTime
    }
}
