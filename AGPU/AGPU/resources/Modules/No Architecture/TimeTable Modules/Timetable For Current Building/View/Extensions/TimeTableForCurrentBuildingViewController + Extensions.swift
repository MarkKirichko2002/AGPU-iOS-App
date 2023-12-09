//
//  TimeTableForCurrentBuildingViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 06.12.2023.
//

import UIKit

// MARK: - UITableViewDelegate
extension TimeTableForCurrentBuildingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil,
                                          actionProvider: {
            _ in
            
            let discipline = self.timetable.disciplines[indexPath.row]
            let group = self.timetable.groupName
            let date = self.timetable.date
            
            let infoAction = UIAction(title: "Подробнее", image: UIImage(named: "info")) { _ in
                let vc = PairInfoTableViewController(pair: discipline, group: group, date: date)
                let navVC = UINavigationController(rootViewController: vc)
                navVC.modalPresentationStyle = .fullScreen
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                    self.present(navVC, animated: true)
                }
            }
            
//            let shareAction = UIAction(title: "Поделиться", image: UIImage(named: "share")) { _ in
//                do {
//                    let json = try JSONEncoder().encode([discipline])
//                    let dayOfWeek = self.dateManager.getCurrentDayOfWeek(date: date)
//                    self.service.getDisciplineImage(json: json) { image in
//                        self.ShareImage(image: image, title: group, text: "\(dayOfWeek) \(date)")
//                    }
//                } catch {
//                    print(error.localizedDescription)
//                }
//            }
            
            return UIMenu(title: self.timetable.disciplines[indexPath.row].name, children: [
                infoAction
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
extension TimeTableForCurrentBuildingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timetable.disciplines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TimeTableTableViewCell.identifier, for: indexPath) as? TimeTableTableViewCell else {return UITableViewCell()}
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = selectedView
        cell.configure(timetable: timetable, index: indexPath.row)
        return cell
    }
}
