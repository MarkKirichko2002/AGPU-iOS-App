//
//  DatesListViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 26.06.2024.
//

import UIKit

// MARK: - UITableViewDelegate
extension DatesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let date = viewModel.dateItem(index: indexPath.row)
            viewModel.deleteDate(date: date)
        }
    }
}

// MARK: - UITableViewDataSource
extension DatesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.datesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let date = viewModel.dateItem(index: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = date
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        return cell
    }
}

// MARK: - CalendarMultipleDatesViewControllerDelegate
extension DatesListViewController: CalendarMultipleDatesViewControllerDelegate {
    
    func datesWereSelected() {
        viewModel.getDates()
    }
}
