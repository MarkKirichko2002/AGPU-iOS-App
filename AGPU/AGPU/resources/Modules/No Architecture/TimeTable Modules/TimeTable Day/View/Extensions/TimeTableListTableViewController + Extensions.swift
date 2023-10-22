//
//  TimeTableDayListTableViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 12.07.2023.
//

import UIKit

// MARK: - UITableViewDelegate
extension TimeTableDayListTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil,
                                          actionProvider: {
            _ in
            
            let infoAction = UIAction(title: "подробнее", image: UIImage(named: "info")) { _ in
                let vc = PairInfoTableViewController(pair: self.timetable!.disciplines[indexPath.row], group: self.group)
                let navVC = UINavigationController(rootViewController: vc)
                navVC.modalPresentationStyle = .fullScreen
                self.present(navVC, animated: true)
            }
            
            let mapAction = UIAction(title: "найти корпус", image: UIImage(named: "map icon")) { _ in
                if let audience = self.timetable?.disciplines[indexPath.row].audienceID {
                    let vc = AGPUCurrentBuildingMapViewController(audienceID: audience)
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                        vc.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                } else if self.timetable?.disciplines[indexPath.row].audienceID == nil || self.timetable?.disciplines[indexPath.row].audienceID == ""  {
                    let ok = UIAlertAction(title: "ОК", style: .default)
                    self.showAlert(title: "Корпус не найден!", message: "К сожалению у данной пары отсутствует аудитория", actions: [ok])
                }
            }
            
            return UIMenu(title: self.timetable?.disciplines[indexPath.row].name ?? "", children: [
                infoAction,
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
extension TimeTableDayListTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timetable?.disciplines.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TimeTableTableViewCell.identifier, for: indexPath) as? TimeTableTableViewCell else {return UITableViewCell()}
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = selectedView
        if let timetable = timetable {
            cell.configure(timetable: timetable, index: indexPath.row)
        }
        return cell
    }
}
