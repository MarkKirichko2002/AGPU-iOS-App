//
//  TimeTableDatesListViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 26.06.2024.
//

import UIKit

// MARK: - UITableViewDelegate
extension TimeTableDatesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.titleForHeaderInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil,
                                          actionProvider: {
            _ in
            
            let discipline = self.viewModel.pairAtSection(section: indexPath.section, index: indexPath.row)
            let item = self.viewModel.timetable[indexPath.row]
            
            let infoAction = UIAction(title: "Подробнее", image: UIImage(named: "info")) { _ in
                let vc = PairInfoTableViewController(pair: discipline, id: item.id, date: item.date)
                let navVC = UINavigationController(rootViewController: vc)
                navVC.modalPresentationStyle = .fullScreen
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                    self.present(navVC, animated: true)
                }
            }
            
            let mapAction = UIAction(title: "Найти корпус", image: UIImage(named: "map icon")) { _ in
                let audience = discipline.audienceID
                let vc = AGPUCurrentBuildingMapViewController(audienceID: audience, id: item.id, owner: item.owner)
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                        vc.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                
                if discipline.audienceID == ""  {
                    let ok = UIAlertAction(title: "ОК", style: .default)
                    self.showAlert(title: "Корпус не найден!", message: "К сожалению у данной пары отсутствует аудитория", actions: [ok])
                }
            }
            
            return UIMenu(title: discipline.name, children: [
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
extension TimeTableDatesListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView)-> Int {
        return viewModel.numberOfTimetableSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfPairsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TimeTableTableViewCell.identifier, for: indexPath) as? TimeTableTableViewCell else {return UITableViewCell()}
        let item = viewModel.timetable[indexPath.section]
        print(item.disciplines)
        let timetable = TimeTable(id: item.id, date: item.date, disciplines: item.disciplines)
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = selectedView
        cell.delegate = self
        cell.configure(timetable: timetable, index: indexPath.row)
        return cell
    }
}

// MARK: - ITimeTableTableViewCell
extension TimeTableDatesListViewController: ITimeTableTableViewCell {
    
    func cellTapped(pair: Discipline, id: String, date: String) {
        let vc = PairInfoTableViewController(pair: pair, id: id, date: date)
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
}

extension TimeTableDatesListViewController {
    
    func showSaveImageAlert() {
        let saveAction = UIAlertAction(title: "Сохранить в фото", style: .default) { _ in
            self.viewModel.createImage { image in
                let imageSaver = ImageSaver()
                imageSaver.writeToPhotoAlbum(image: image)
            }
        }
        
        let saveAction2 = UIAlertAction(title: "Сохранить в \"Важные вещи\"", style: .default) { _ in
            self.viewModel.createImage { image in
                self.viewModel.saveImage(image: image)
            }
        }
        
        let cancel = UIAlertAction(title: "Отмена", style: .destructive) { _ in}
        self.showAlert(title: "Сохранить расписание?", message: "Вы хотите сохранить изображение расписания?", actions: [saveAction2, saveAction, cancel])
    }
}
