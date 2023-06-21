//
//  MapRealisationsListViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 22.06.2023.
//

import UIKit

// MARK: - UITableViewDataSource
extension MapRealisationsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realisations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = realisations[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDelegate,
extension MapRealisationsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
           let vc = AGPUMapViewController()
           self.navigationController?.pushViewController(vc, animated: true)
        case 1:
           let vc = AGPUSecondMapViewController()
           self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}
