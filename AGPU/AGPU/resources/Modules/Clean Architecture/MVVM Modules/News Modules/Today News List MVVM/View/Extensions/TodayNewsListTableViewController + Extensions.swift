//
//  TodayNewsListTableViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 25.05.2024.
//

import UIKit

// MARK: - UITableViewDelegate
extension TodayNewsListTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.titleForHeaderInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension TodayNewsListTableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView)-> Int {
        return viewModel.numberOfNewsSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfNewsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell else {return UITableViewCell()}
        cell.configure(article: viewModel.newsItemAtSection(section: indexPath.section, index: indexPath.row))
        return cell
    }
}
