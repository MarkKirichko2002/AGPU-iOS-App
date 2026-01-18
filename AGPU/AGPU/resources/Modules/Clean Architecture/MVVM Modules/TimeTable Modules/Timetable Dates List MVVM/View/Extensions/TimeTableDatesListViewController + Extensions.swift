//
//  TimeTableDatesListViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 26.06.2024.
//

import UIKit

// MARK: - UITableViewDelegate
extension TimeTableDatesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 25))
        header.backgroundColor = .systemBackground
        header.layer.borderWidth = 3
        header.layer.borderColor = UIColor.label.cgColor
        header.layer.cornerRadius = 10
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        header.addSubview(label)
        label.text = viewModel.titleForHeaderInSection(section: section)
        label.textColor = .label
        label.font = .systemFont(ofSize: 17, weight: .black)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: header.topAnchor, constant: 10),
            label.leftAnchor.constraint(equalTo: header.leftAnchor, constant: 10),
            label.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -10),
        ])
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil,
                                          actionProvider: {
            _ in
            
            let discipline = self.viewModel.pairAtSection(section: indexPath.section, index: indexPath.row)
            
            let addPseyMenu = self.viewModel.addTimetablePseyMenu(discipline: discipline)
            let originalName = self.viewModel.configureDisciplineName(discipline: discipline)
            let item = self.viewModel.timetable[indexPath.row]
            
            let infoAction = UIAction(title: "О чем дисциплина?", image: UIImage(named: "info")) { _ in
                let vc = AIInfoViewController(text: "напиши для чего эта дисциплина: \(self.viewModel.returnOriginalDisciplineName(name: discipline.name))?")
                let navVC = UINavigationController(rootViewController: vc)
                navVC.modalPresentationStyle = .fullScreen
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                    self.present(navVC, animated: true)
                }
            }
            
            let mapAction = UIAction(title: "Найти корпус", image: UIImage(named: "map icon")) { _ in
                let originalRoom = self.viewModel.returnOriginalAudienceName(audience: discipline.audienceID)
                let vc = AGPUCurrentBuildingMapViewController(audienceID: originalRoom, id: item.id, owner: item.owner)
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                        self.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                
                if discipline.audienceID == ""  {
                    self.showAlert(title: "Корпус не найден!", message: "К сожалению у данной пары отсутствует аудитория", actions: [UIAlertAction(title: "ОК", style: .default)])
                }
            }
            
            return UIMenu(title: originalName, children: [
                infoAction,
                addPseyMenu,
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

// MARK: - TimetablePseudonymCategoriesListTableViewControllerDelegate
extension TimeTableDatesListViewController: TimetablePseudonymCategoriesListTableViewControllerDelegate {
    
    func dataWasChanged() {
        viewModel.refreshData()
    }
}

extension TimeTableDatesListViewController {
    
    func showSaveImageAlert() {
        let saveAction = UIAlertAction(title: "Сохранить в фото", style: .default) { _ in
            self.viewModel.createImage { image in
                self.imageSaver.writeToPhotoAlbum(image: image)
            }
        }
        
        let saveAction2 = UIAlertAction(title: "Сохранить в изображения", style: .default) { _ in
            self.viewModel.createImage { image in
                self.viewModel.saveImage(image: image)
            }
        }
        
        let cancel = UIAlertAction(title: "Отмена", style: .destructive) { _ in}
        self.showAlert(title: createSaveImageAlertMessage().0, message: createSaveImageAlertMessage().1, actions: [saveAction2, saveAction, cancel])
    }
}
