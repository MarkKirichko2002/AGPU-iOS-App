//
//  TimetableTimeIntervalsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 07.10.2025.
//

import UIKit

protocol TimetableTimeIntervalsListTableViewControllerDelegate: AnyObject {
    func timeIntervalsSelected(intervals: [String])
}

final class TimetableTimeIntervalsListTableViewController: UITableViewController {

    // MARK: - сервисы
    let viewModel = TimetableTimeIntervalsListViewModel()
    
    weak var delegate: TimetableTimeIntervalsListTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTableView()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        let titleView = CustomTitleView(image: "eye crossed", title: "Спрятать пары", frame: .zero)
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .plain, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .label
        let confirmButton = UIBarButtonItem(image: UIImage(named: "check icon"), style: .plain, target: self, action: #selector(chooseIntervals))
        confirmButton.tintColor = .label
        navigationItem.titleView = titleView
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItem = confirmButton
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
    }
    
    @objc private func chooseIntervals() {
        delegate?.timeIntervalsSelected(intervals: viewModel.selectedIntervals)
        viewModel.saveAllIntervals()
        dismiss(animated: true)
    }
    
    private func setUpTableView() {
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func bindViewModel() {
        viewModel.registerDataChangedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        viewModel.getIntervals()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectInterval(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.intervalsCount()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let interval = viewModel.intervalItem(index: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.tintColor = .systemGreen
        cell.textLabel?.text = interval
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        cell.textLabel?.textColor = viewModel.isIntervalSelected(index: indexPath.row) ? UIColor.systemGreen : UIColor.label
        cell.accessoryType = viewModel.isIntervalSelected(index: indexPath.row) ? .checkmark : .none
        return cell
    }
}
