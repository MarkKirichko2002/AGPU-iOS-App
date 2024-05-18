//
//  TimeTableWeekListTableViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 06.08.2023.
//

import UIKit

// MARK: - UITableViewDelegate
extension TimeTableWeekListTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = "\(week.dayNames[timetable[section].date]!) \(timetable[section].date)"
        return date
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil,
                                          actionProvider: {
            _ in
            
            let discipline = self.timetable[indexPath.section].disciplines[indexPath.row]
            
            let infoAction = UIAction(title: "Подробнее", image: UIImage(named: "info")) { _ in
                let vc = PairInfoTableViewController(pair: discipline, id: self.id, date: self.timetable[indexPath.section].date)
                let navVC = UINavigationController(rootViewController: vc)
                navVC.modalPresentationStyle = .fullScreen
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                    self.present(navVC, animated: true)
                }
            }
            
            let mapAction = UIAction(title: "Найти корпус", image: UIImage(named: "map icon")) { _ in
                let audience = self.timetable[indexPath.section].disciplines[indexPath.row].audienceID 
                let vc = AGPUCurrentBuildingMapViewController(audienceID: audience, id: self.id, owner: self.owner)
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                        vc.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                
                if self.timetable[indexPath.section].disciplines[indexPath.row].audienceID == ""  {
                    let ok = UIAlertAction(title: "ОК", style: .default)
                    self.showAlert(title: "Корпус не найден!", message: "К сожалению у данной пары отсутствует аудитория", actions: [ok])
                }
            }
            
            return UIMenu(title: self.timetable[indexPath.section].disciplines[indexPath.row].name, children: [
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
extension TimeTableWeekListTableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return timetable.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timetable[section].disciplines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TimeTableTableViewCell.identifier, for: indexPath) as? TimeTableTableViewCell else {return UITableViewCell()}
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = selectedView
        
        cell.configure(timetable: timetable[indexPath.section], index: indexPath.row)
        
        return cell
    }
}

// MARK: - WeekDaysListTableViewControllerDelegate
extension TimeTableWeekListTableViewController: WeekDaysListTableViewControllerDelegate {
    
    func dateWasSelected(index: Int) {
        currentDate = timetable[index].date
        tableView.scrollToRow(at: IndexPath(row: 0, section: index), at: .top, animated: true)
    }
}

// MARK: - TimeTableSearchListTableViewControllerDelegate
extension TimeTableWeekListTableViewController: TimeTableSearchListTableViewControllerDelegate {
    
    func itemWasSelected(result: SearchTimetableModel) {
        self.id = result.name
        self.owner = result.owner
        self.getTimeTable()
    }
}

// MARK: - TimeTableFavouriteItemsListTableViewControllerDelegate
extension TimeTableWeekListTableViewController: TimeTableFavouriteItemsListTableViewControllerDelegate {
    
    func WasSelected(result: SearchTimetableModel) {
        self.id = result.name
        self.owner = result.owner
        self.getTimeTable()
    }
}
