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
            
            let discipline = self.timetable?.disciplines[indexPath.row]
            
            let infoAction = UIAction(title: "Подробнее", image: UIImage(named: "info")) { _ in
                let vc = PairInfoTableViewController(pair: discipline!, id: self.id, date: self.date)
                let navVC = UINavigationController(rootViewController: vc)
                navVC.modalPresentationStyle = .fullScreen
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                    self.present(navVC, animated: true)
                }
            }
            
            let mapAction = UIAction(title: "Найти корпус", image: UIImage(named: "map icon")) { _ in
                if let audience = discipline?.audienceID {
                    let vc = AGPUCurrentBuildingMapViewController(audienceID: audience, id: self.id, owner: self.owner)
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                        vc.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                } else if discipline?.audienceID == nil || discipline?.audienceID == ""  {
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
        cell.delegate = self
        if let timetable = timetable {
            cell.configure(timetable: timetable, index: indexPath.row)
        }
        return cell
    }
}

// MARK: - ITimeTableTableViewCell
extension TimeTableDayListTableViewController: ITimeTableTableViewCell {
    
    func cellTapped(pair: Discipline, id: String, date: String) {
        let vc = PairInfoTableViewController(pair: pair, id: id, date: date)
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
}

// MARK: - TimeTableSearchListTableViewControllerDelegate
extension TimeTableDayListTableViewController: TimeTableSearchListTableViewControllerDelegate {
    
    func itemWasSelected(result: SearchTimetableModel) {
        type = .all
        getTimeTable(id: result.name, date: self.date, owner: result.owner)
        id = result.name
        owner = result.owner
        print(owner)
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension TimeTableDayListTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        textRecognitionManager.recognizeText(image: image) { date in
            
            let isCorrectFormat = self.dateManager.isCorrectFormat(str: date)
            
            if isCorrectFormat {
                let dayOfWeek = self.dateManager.getCurrentDayOfWeek(date: date)
                self.date = date
                self.type = .all
                self.subgroup = 0
                self.getTimeTable(id: self.id, date: self.date, owner: self.owner)
                self.navigationItem.title = "\(dayOfWeek) \(date)"
            } else {
                self.showAlert(title: "Неверный формат даты!", message: "сфотографируйте дату еще раз (формат должен быть дд.мм.гггг).", actions: [UIAlertAction(title: "OK", style: .default)])
            }
            self.dismiss(animated: true)
        }
    }
}


// MARK: - AllGroupsListTableViewControllerDelegate
extension TimeTableDayListTableViewController: AllGroupsListTableViewControllerDelegate {
    
    func groupWasSelected(group: String) {
        id = group
        owner = "GROUP"
        getTimeTable(id: self.id, date: self.date, owner: self.owner)
    }
}

// MARK: - SubGroupsListTableViewControllerDelegate
extension TimeTableDayListTableViewController: SubGroupsListTableViewControllerDelegate {
    
    func subGroupWasSelected(subgroup: Int) {
        filterPairs(by: subgroup)
    }
}

// MARK: - TimeTableFavouriteItemsListTableViewControllerDelegate
extension TimeTableDayListTableViewController: TimeTableFavouriteItemsListTableViewControllerDelegate {
    
    func WasSelected(result: SearchTimetableModel) {
        self.getTimeTable(id: result.name, date: self.date, owner: result.owner)
        self.id = result.name
        self.owner = result.owner
        print(self.owner)
    }
}

// MARK: - DaysListTableViewControllerDelegate
extension TimeTableDayListTableViewController: DaysListTableViewControllerDelegate {
    
    func dateSelected(date: String) {
        let dayOfWeek = self.dateManager.getCurrentDayOfWeek(date: date)
        self.date = date
        self.type = .all
        self.subgroup = 0
        self.getTimeTable(id: self.id, date: self.date, owner: self.owner)
        self.navigationItem.title = "\(dayOfWeek) \(date)"
    }
}

// MARK: - CalendarViewControllerDelegate
extension TimeTableDayListTableViewController: CalendarViewControllerDelegate {
    
    func dateWasSelected(model: TimeTableChangesModel)  {
        let dayOfWeek = self.dateManager.getCurrentDayOfWeek(date: date)
        self.id = model.id
        self.date = model.date
        self.owner = model.owner
        self.type = model.type
        self.subgroup = model.subgroup
        self.allDisciplines = model.allPairs
        self.timetable?.disciplines = model.filteredPairs
        self.tableView.reloadData()
        if timetable?.disciplines.isEmpty ?? false {
            self.infoLabel.isHidden = false
        } else {
            self.infoLabel.isHidden = true
        }
        self.navigationItem.title = "\(dayOfWeek) \(date)"
    }
}

// MARK: - PairTypesListTableViewControllerDelegate
extension TimeTableDayListTableViewController: PairTypesListTableViewControllerDelegate {
    
    func pairTypeWasSelected(type: PairType) {
        filterPairs(type: type)
    }
}

extension TimeTableDayListTableViewController {
    
    func showSaveImageAlert() {
        let saveAction = UIAlertAction(title: "Сохранить в фото", style: .default) { _ in
            do {
                let json = try JSONEncoder().encode(self.timetable)
                self.service.getTimeTableDayImage(json: json) { image in
                    let imageSaver = ImageSaver()
                    imageSaver.writeToPhotoAlbum(image: image)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
        let saveAction2 = UIAlertAction(title: "Сохранить в \"Важные вещи\"", style: .default) { _ in
            do {
                let json = try JSONEncoder().encode(self.timetable)
                self.service.getTimeTableDayImage(json: json) { image in
                    if let imageData = image.jpegData(compressionQuality: 1.0) {
                        let model = ImageModel()
                        model.date = self.dateManager.getCurrentDate()
                        model.image = imageData
                        self.realmManager.saveImage(image: model)
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
        let cancel = UIAlertAction(title: "Отмена", style: .destructive) { _ in}
        self.showAlert(title: "Сохранить расписание?", message: "Вы хотите сохранить изображение расписания?", actions: [saveAction2, saveAction, cancel])
    }
}
