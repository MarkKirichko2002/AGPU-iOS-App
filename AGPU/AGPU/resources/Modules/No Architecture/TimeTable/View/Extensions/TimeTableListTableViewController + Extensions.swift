//
//  TimeTableListTableViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 12.07.2023.
//

import UIKit

// MARK: - UITableViewDelegate
extension TimeTableListTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil,
                                          actionProvider: {
            _ in
            
            let mapAction = UIAction(title: "найти корпус", image: UIImage(named: "search")) { _ in
                if let audience = self.timetable[indexPath.row].audienceID {
                    let vc = AGPUCurrentBuildingMapViewController(audienceID: audience)
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                } else if self.timetable[indexPath.row].audienceID == nil || self.timetable[indexPath.row].audienceID == ""  {
                    let ok = UIAlertAction(title: "ОК", style: .default)
                    self.ShowAlert(title: "Корпус не найден!", message: "К сожалению у данной пары отсутствует аудитория", actions: [ok])
                }
            }
            
            return UIMenu(title: self.timetable[indexPath.row].name, children: [
                mapAction
            ])
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) as? TimeTableTableViewCell {
            cell.didTapCell(indexPath: indexPath)
        }
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension TimeTableListTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timetable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TimeTableTableViewCell.identifier, for: indexPath) as? TimeTableTableViewCell else {return UITableViewCell()}
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = selectedView
        
        cell.configure(timetable: timetable[indexPath.row])
        
        return cell
    }
}
