//
//  TimeTableDayListTableViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 12.07.2023.
//

import UIKit
import AVFoundation
import MediaPipeTasksVision

// MARK: - UITableViewDelegate
extension TimeTableDayListTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil,
                                          actionProvider: {
            _ in
            
            let discipline = self.timetable.disciplines[indexPath.row]
            
            let originalName = self.timetablePseudonymManager.returnOriginalDisciplineName(name: discipline.name)
            
            let infoAction = UIAction(title: "О чем дисциплина?", image: UIImage(named: "info")) { _ in
                let vc = AIInfoViewController(text: "напиши для чего эта дисциплина: \(self.timetablePseudonymManager.returnOriginalDisciplineName(name: discipline.name))?")
                let navVC = UINavigationController(rootViewController: vc)
                navVC.modalPresentationStyle = .fullScreen
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                    self.present(navVC, animated: true)
                }
            }
            
            let daysMenu = self.findPairDaysMenu(name: discipline.name)
            
            let addPseyMenu = self.timetableMenuManager.addTimetablePseyMenu(discipline: discipline)
            
            let mapAction = UIAction(title: "Найти корпус", image: UIImage(named: "map icon")) { _ in
                let originalRoom = self.timetablePseudonymManager.returnOriginalAudienceName(audience: discipline.audienceID)
                let vc = AGPUCurrentBuildingMapViewController(audienceID: originalRoom, id: self.id, owner: self.owner)
                vc.hidesBottomBarWhenPushed = true
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
            return UIMenu(title: originalName, children: [
                infoAction,
                daysMenu,
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
extension TimeTableDayListTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timetable.disciplines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TimeTableTableViewCell.identifier, for: indexPath) as? TimeTableTableViewCell else {return UITableViewCell()}
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = selectedView
        cell.delegate = self
        cell.configure(timetable: timetable, index: indexPath.row)
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
        id = result.name
        owner = result.owner
        getTimeTable(id: result.name, date: self.date, owner: result.owner) {}
    }
}

// MARK: - NearBuildingViewControllerDelegate
extension TimeTableDayListTableViewController: NearBuildingViewControllerDelegate {
    
    func audienceSelected(audience: String) {
        type = .all
        id = audience
        owner = "CLASSROOM"
        getTimeTable(id: audience, date: self.date, owner: "CLASSROOM") {}
    }
}

// MARK: - AllGroupsListTableViewControllerDelegate
extension TimeTableDayListTableViewController: AllGroupsListTableViewControllerDelegate {
    
    func groupWasSelected(group: String) {
        id = group
        owner = "GROUP"
        getTimeTable(id: self.id, date: self.date, owner: self.owner) {}
    }
}

// MARK: - SubGroupsListTableViewControllerDelegate
extension TimeTableDayListTableViewController: SubGroupsListTableViewControllerDelegate {
    
    func subGroupWasSelected(subgroup: Int) {
        filterPairs(by: subgroup)
    }
}

// MARK: - DepartmentsListTableViewControllerDelegate
extension TimeTableDayListTableViewController: DepartmentsListTableViewControllerDelegate {
    
    func teacherSelected(teacher: String) {
        type = .all
        id = teacher
        owner = "TEACHER"
        getTimeTable(id: teacher, date: self.date, owner: "TEACHER") {}
    }
}

// MARK: - CorpsListTableViewControllerDelegate
extension TimeTableDayListTableViewController: CorpsListTableViewControllerDelegate {
    
    func audienceWasSelected(audience: String) {
        type = .all
        id = audience
        owner = "CLASSROOM"
        getTimeTable(id: audience, date: self.date, owner: "CLASSROOM") {}
    }
}

// MARK: - TimeTableFavouriteItemsListTableViewControllerDelegate
extension TimeTableDayListTableViewController: TimeTableFavouriteItemsListTableViewControllerDelegate {
    
    func WasSelected(result: SearchTimetableModel) {
        self.getTimeTable(id: result.name, date: self.date, owner: result.owner) {}
        self.id = result.name
        self.owner = result.owner
        print(self.owner)
    }
}

// MARK: - DaysListTableViewControllerDelegate
extension TimeTableDayListTableViewController: DaysListTableViewControllerDelegate {
    
    func datesSelected(dates: [String]) {
        self.dates = dates
    }
    
    func dayTypeSelected(type: DayType) {
        self.dayType = type
    }
    
    func weekSelected(week: WeekModel) {
        self.currentWeek = week
    }
    
    func dateSelected(date: String) {
        self.date = date
        self.type = .all
        self.subgroup = 0
        self.getTimeTable(id: self.id, date: self.date, owner: self.owner) {}
    }
}

// MARK: - CalendarViewControllerDelegate
extension TimeTableDayListTableViewController: CalendarViewControllerDelegate {
    
    func dateWasSelected(date: String) {
        self.date = date
        self.type = .all
        self.subgroup = 0
        self.getTimeTable(id: self.id, date: self.date, owner: self.owner) {}
    }
    
    func dateWasSelected(model: TimeTableChangesModel)  {
        self.id = model.id
        self.date = model.date
        self.owner = model.owner
        self.type = model.type
        self.subgroup = model.subgroup
        self.allDisciplines = model.allPairs
        self.timetable.disciplines = []
        self.timetable.disciplines = model.filteredPairs
        DispatchQueue.main.async {
            if self.timetable.disciplines.isEmpty {
                self.infoLabel.isHidden = false
            } else {
                self.infoLabel.isHidden = true
            }
            self.navigationItem.title = "\(self.dateManager.getCurrentDayOfWeek(date: self.date)) \(self.date)"
            self.tableView.reloadData()
        }
    }
}

// MARK: - CalendarDisciplineNameViewControllerDelegate
extension TimeTableDayListTableViewController: CalendarDisciplineNameViewControllerDelegate {
    
    func dateWasSelected(date: String, name: String) {
        self.date = date
        self.type = .all
        self.subgroup = 0
        self.getTimeTable(id: self.id, date: self.date, owner: self.owner) {
            self.filterPairs(name: name)
        }
    }
}

// MARK: - TimetableFilterCategoriesListTableViewControllerDelegate
extension TimeTableDayListTableViewController: TimetableFilterCategoriesListTableViewControllerDelegate {
    
    func timeWasSelected(time: String) {
        filterPairs(by: time)
    }
    
    func buildingWasSelected(building: AGPUBuildingModel) {
        filterPairs(by: building)
    }
    
    func pairTypeWasSelected(type: PairType) {
        filterPairs(type: type)
    }
}

// MARK: - DisciplinesPseudonymListViewControllerDelegate
extension TimeTableDayListTableViewController: TimetablePseudonymCategoriesListTableViewControllerDelegate {
    
    func dataWasChanged() {
        refreshTimetable {}
    }
}

extension TimeTableDayListTableViewController {
    
    func showSaveImageAlert() {
        let saveAction = UIAlertAction(title: "Сохранить в фото", style: .default) { _ in
            do {
                let json = try JSONEncoder().encode(self.timetable)
                self.service.getTimeTableDayImage(json: json) { image in
                    self.imageSaver.writeToPhotoAlbum(image: image)
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
                        model.date = self.date
                        model.image = imageData
                        DispatchQueue.main.async {
                            self.realmManager.saveImage(image: model)
                        }
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
        let cancel = UIAlertAction(title: "Отмена", style: .destructive) { _ in}
        self.showAlert(title: createSaveImageAlertMessage().0, message: createSaveImageAlertMessage().1, actions: [saveAction2, saveAction, cancel])
    }
}

extension TimeTableDayListTableViewController {
    
    func openSearch() {
        let vc = TimeTableSearchListTableViewController()
        vc.isSettings = false
        vc.delegate = self
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true)
    }
    
    func openDaysList() {
        let vc = DaysListTableViewController(id: id, currentDate: date, owner: owner, dayType: dayType, week: currentWeek, dates: dates)
        vc.delegate = self
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true)
    }
    
    func openAR() {
        let vc = TimetableARViewController(id: self.id, subgroup: self.subgroup, date: self.date, owner: self.owner)
        vc.delegate = self
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        self.createImage {
            vc.image = self.image
            self.present(navVC, animated: true)
        }
    }
    
    func openFavouritesList() {
        let vc = TimeTableFavouriteItemsListTableViewController()
        vc.delegate = self
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true)
    }
    
    func openFilterOptionsList() {
        let vc = TimetableFilterCategoriesListTableViewController(date: date, type: type, disciplines: allDisciplines, building: currentBuilding, time: currentTime)
        vc.delegate = self
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true)
    }
}

// MARK: - TimetableARViewControllerDelegate
extension TimeTableDayListTableViewController: TimetableARViewControllerDelegate {
    
    func dateWasChanged(date: String) {
        self.date = date
        self.type = .all
        self.subgroup = 0
        self.getTimeTable(id: self.id, date: self.date, owner: self.owner) {}
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
extension TimeTableDayListTableViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        recognizeGesture(sampleBuffer: sampleBuffer)
    }
    
    func recognizeGesture(sampleBuffer: CMSampleBuffer) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let timestamp = Int(CMSampleBufferGetPresentationTimeStamp(sampleBuffer).value)
        do {
            let image = try MPImage(pixelBuffer: pixelBuffer, orientation: .right)
            try gestureRecognitionManager.gestureRecognizer?.recognizeAsync(image: image, timestampInMilliseconds: timestamp)
        } catch {
            print("Ошибка обработки кадра: \(error)")
        }
    }
    
    func getTimetable(gesture: handGestures) {
        switch gesture {
        case .fist, .one, .two, .palm:
            self.date = self.dateForGesture(gesture: gesture)
            self.getTimeTable(id: self.id, date: self.date, owner: self.owner) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.startSession()
                }
            }
            HapticsManager.shared.hapticFeedback()
        case .like:
            let add = UIAlertAction(title: "Добавить", style: .default) { _ in
                let item = SearchTimetableModel()
                item.name = self.id
                item.owner = self.owner
                self.realmManager.saveTimetableItem(item: item)
                self.startSession()
            }
            let restart = UIAlertAction(title: "Распознать заново", style: .default) { _ in
                self.startSession()
            }
            let cancel = UIAlertAction(title: "Отмена", style: .destructive) { _ in
                self.startSession()
            }
            showInfoAlert(title: "Жест \(gesture.rawValue) обнаружен!", message: "добавить \(id) в избранное?", actions: [add, restart, cancel])
            HapticsManager.shared.hapticFeedback()
        case .dislike:
            let remove = UIAlertAction(title: "Убрать", style: .default) { _ in
                let item = SearchTimetableModel()
                item.name = self.id
                item.owner = self.owner
                self.realmManager.deleteTimetableItem(item: item)
                self.startSession()
            }
            let restart = UIAlertAction(title: "Распознать заново", style: .default) { _ in
                self.startSession()
            }
            let cancel = UIAlertAction(title: "Отмена", style: .destructive) { _ in
                self.startSession()
            }
            showInfoAlert(title: "Жест \(gesture.rawValue) обнаружен!", message: "убрать \(id) из избранного?", actions: [remove, restart, cancel])
            HapticsManager.shared.hapticFeedback()
        }
    }
    
    func dateForGesture(gesture: handGestures)-> String {
        switch gesture {
        case .fist:
            return date
        case .one:
            return dateManager.previousDay(date: self.date)
        case .two:
            return dateManager.nextDay(date: self.date)
        case .palm:
            return dateManager.getCurrentDate()
        case .like:
            break
        case .dislike:
            break
        }
        return ""
    }
    
    func startSession() {
        if isRecordingVideo {
            DispatchQueue.global(qos: .background).async {
                self.captureSession.startRunning()
            }
            self.currentCameraState = .on
            self.updateCameraButtonMenu()
        }
    }
}

// MARK: - UIContextMenuInteractionDelegate
extension TimeTableDayListTableViewController: UIContextMenuInteractionDelegate {
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil,
                                          actionProvider: {
            suggestedActions in
            
            return self.dateNavigationMenu()
        })
    }
}

// MARK: - TimetableDayInfoViewControllerDelegate
extension TimeTableDayListTableViewController: TimetableDayInfoViewControllerDelegate {
    func buttonWasTapped() {
        refreshTimetable {}
    }
}

// MARK: - TimetableTimeIntervalsListTableViewControllerDelegate
extension TimeTableDayListTableViewController: TimetableTimeIntervalsListTableViewControllerDelegate {
    
    func timeIntervalsSelected(intervals: [String]) {
        getTimeTable(id: id, date: date, owner: owner) {
            self.filterPairs(by: intervals)
        }
    }
}

// MARK: - UIScrollViewDelegate
extension TimeTableDayListTableViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        buttonSettingsManager?.handleScroll()
    }
}

extension TimeTableDayListTableViewController {
    
    func filterPairs(by intervals: [String]) {
        if intervals.isEmpty {
            timetable.disciplines = allDisciplines
        } else {
            intervals.forEach { interval in
                timetable.disciplines = timetable.disciplines.filter({ $0.time != interval })
            }
        }
        DispatchQueue.main.async {
            if self.timetable.disciplines.isEmpty {
                self.infoLabel.isHidden = false
            } else {
                self.infoLabel.isHidden = true
            }
            self.tableView.reloadData()
        }
    }
    
    func checkTimetableShowVC() {
        let style = settingsManager.checkScreenPresentationStyleOption()
        let savedDate = settingsManager.getSavedDate(screen: "timetable day")
        if savedDate != dateManager.getCurrentDate() {
            UserDefaults.standard.set(dateManager.getCurrentDate(), forKey: "saved date timetable day")
            if style != .notShow {
                checkTimeRange()
            }
        }
    }
    
    func checkTimeRange() {
        let currentTime = dateManager.getCurrentTime(isFullFormat: false)
        let dayTimeRange = dateManager.timeRange(startTime: "00:00", endTime: "19:59", currentTime: currentTime)
        let eveningTimeRange = dateManager.timeRange(startTime: "20:00", endTime: "23:59", currentTime: currentTime)
        if dayTimeRange {
            showTimetableInfo()
        } else if eveningTimeRange {
            let show = UIAlertAction(title: "Показать", style: .default) { _ in
                self.date = self.dateManager.nextDay(date: self.date)
                self.getTimeTable(id: self.id, date: self.date, owner: self.owner) {}
            }
            let cancel = UIAlertAction(title: "Отмена", style: .destructive)
            self.showAlert(title: "Показать расписание на завтра?", message: "", actions: [show, cancel])
        }
    }
    
    func showTimetableInfo() {
        let style = UserDefaults.loadData(type: ScreenPresentationStyles.self, key: "screen presentation style") ?? .notShow
        let vc = TimetableDayInfoViewController()
        vc.delegate = self
        switch style {
        case .fullScreen:
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        case .sheet:
            vc.modalPresentationStyle = .pageSheet
            present(vc, animated: true)
        case .notShow:
            let vc = HintViewController(info: "Чтобы увидеть экран, нужно выбрать его отображение в настройках опции \"Наглядные изменения\"")
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
    }
    
    func showTimetableIntervalsVC() {
        let vc = TimetableTimeIntervalsListTableViewController()
        vc.delegate = self
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true)
    }
    
    func isMicOn()-> Bool {
        let isOn = settingsManager.loadScreens(way: differentWays.voiceCommands).contains(appScreens.timetableDay)
        if isOn {
            return speechRecognitionManager.tapInstalled
        }
        return false
    }
    
    func isRecording()-> Bool {
        return settingsManager.loadScreens(way: differentWays.voiceCommands).contains(appScreens.timetableDay)
    }
    
    func checkVoiceCommandsOption() {
        let screens = settingsManager.loadScreens(way: differentWays.voiceCommands)
        if screens.contains(appScreens.timetableDay) {
            resetSpeechRecognition()
        }
    }
    
    func startSpeechRecognition() {
        let screens = settingsManager.loadScreens(way: differentWays.voiceCommands)
        if screens.contains(appScreens.timetableDay) {
            startRecognize()
        }
    }
    
    func resetSpeechRecognition() {
        let screens = settingsManager.loadScreens(way: differentWays.voiceCommands)
        if screens.contains(appScreens.timetableDay) {
            cancelRecognition()
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                self.startRecognize()
            }
        }
    }
    
    func cancelRecognition() {
        let screens = settingsManager.loadScreens(way: differentWays.voiceCommands)
        if screens.contains(appScreens.timetableDay) {
            speechRecognitionManager.cancelSpeechRecognition()
        }
    }
    
    func startRecognize() {
        speechRecognitionManager.requestSpeechAndMicrophonePermission()
        speechRecognitionManager.registerSpeechAuthorizationHandler { auth in
            switch auth {
            case .notDetermined:
                print("Разрешение на распознавание речи еще не было получено.")
            case .denied:
                let settingsAction = UIAlertAction(title: "Перейти в настройки", style: .default) { _ in
                    self.openSettings()
                }
                let cancel = UIAlertAction(title: "Отмена", style: .destructive) { _ in}
                self.showAlert(title: self.createAlertMessage().0, message: self.createAlertMessage().1, actions: [settingsAction, cancel])
                print("Доступ к распознаванию речи был отклонен.")
            case .restricted:
                print("Функциональность распознавания речи ограничена.")
            case .authorized:
                print("Разрешение на распознавание речи получено.")
                self.speechRecognitionManager.startRecognize()
            @unknown default:
                print("неизвестно")
            }
        }
        speechRecognitionManager.registerSpeechRecognitionHandler { text in
            self.voiceCommands(text: text)
        }
    }
    
    func voiceCommands(text: String) {
        showAllPairs(text: text)
        showPairsForWeekDay(text: text)
        resetCurrentWeek(text: text)
        showPairsForDate(text: text)
        showLeftedPairs(text: text)
        filterVoice(text: text)
        filterBuildingVoice(text: text)
        showCurrentPair(text: text)
        showNextPair(text: text)
        showPreviousPair(text: text)
        showLastPair(text: text)
        showPairForCount(text: text)
        timetableNavigation(text: text)
        closeAlertWithVoice(text: text)
    }
    
    func showAllPairs(text: String) {
        if text.lowercased().contains("сколько всего пар") || text.lowercased().contains("скоко всего пар") {
            type = .all
            subgroup = 0
            cancelRecognition()
            cancelGestureRecognition()
            refreshTimetable {
                DispatchQueue.main.async {
                    self.countPairs()
                }
            }
            closeModals()
            HapticsManager.shared.hapticFeedback()
        }
    }
    
    func resetCurrentWeek(text: String) {
        if text.lowercased().contains("текущая неделя") {
            getCurrentWeek()
            cancelRecognition()
            cancelGestureRecognition()
            date = dateManager.getCurrentDate()
            getTimeTable(id: id, date: date, owner: owner) {
                DispatchQueue.main.async {
                    self.startSpeechRecognition()
                    self.startSession()
                }
            }
            closeModals()
            HapticsManager.shared.hapticFeedback()
        }
    }
    
    func showPairsForWeekDay(text: String) {
        
        let ok = UIAlertAction(title: "ОК", style: .default) { _ in
            self.startSession()
            SpeechSynthesizerManager.shared.stopComment()
        }
        
        if text.lowercased().contains("понедельник") {
            if let day = currentWeek.dayNames.first(where: { $1 == "Понедельник" }) {
                cancelRecognition()
                cancelGestureRecognition()
                date = day.key
                getTimeTable(id: id, date: date, owner: owner) {
                    DispatchQueue.main.async {
                        self.startSpeechRecognition()
                        self.startSession()
                    }
                }
            } else {
                self.showInfoAlert(title: "День не найден!", message: "у текущей недели нет такого дня", actions: [ok])
            }
            closeModals()
            HapticsManager.shared.hapticFeedback()
        }
        
        if text.lowercased().contains("вторник") {
            if let day = currentWeek.dayNames.first(where: { $1 == "Вторник" }) {
                cancelRecognition()
                cancelGestureRecognition()
                date = day.key
                getTimeTable(id: id, date: date, owner: owner) {
                    DispatchQueue.main.async {
                        self.startSpeechRecognition()
                        self.startSession()
                    }
                }
            } else {
                self.showInfoAlert(title: "День не найден!", message: "у текущей недели нет такого дня", actions: [ok])
            }
            closeModals()
            HapticsManager.shared.hapticFeedback()
        }
        
        if text.lowercased().contains("сред") {
            if let day = currentWeek.dayNames.first(where: { $1 == "Среда" }) {
                cancelRecognition()
                cancelGestureRecognition()
                date = day.key
                getTimeTable(id: id, date: date, owner: owner) {
                    DispatchQueue.main.async {
                        self.startSpeechRecognition()
                        self.startSession()
                    }
                }
            } else {
                self.showInfoAlert(title: "День не найден!", message: "у текущей недели нет такого дня", actions: [ok])
            }
            closeModals()
            HapticsManager.shared.hapticFeedback()
        }
        
        if text.lowercased().contains("четверг") {
            if let day = currentWeek.dayNames.first(where: { $1 == "Четверг" }) {
                cancelRecognition()
                cancelGestureRecognition()
                date = day.key
                getTimeTable(id: id, date: date, owner: owner) {
                    DispatchQueue.main.async {
                        self.startSpeechRecognition()
                        self.startSession()
                    }
                }
            } else {
                self.showInfoAlert(title: "День не найден!", message: "у текущей недели нет такого дня", actions: [ok])
            }
            closeModals()
            HapticsManager.shared.hapticFeedback()
        }
        
        if text.lowercased().contains("пятниц") {
            if let day = currentWeek.dayNames.first(where: { $1 == "Пятница" }) {
                cancelRecognition()
                cancelGestureRecognition()
                date = day.key
                getTimeTable(id: id, date: date, owner: owner) {
                    DispatchQueue.main.async {
                        self.startSpeechRecognition()
                        self.startSession()
                    }
                }
            } else {
                self.showInfoAlert(title: "День не найден!", message: "у текущей недели нет такого дня", actions: [ok])
            }
            closeModals()
            HapticsManager.shared.hapticFeedback()
        }
        
        if text.lowercased().contains("суббот") {
            if let day = currentWeek.dayNames.first(where: { $1 == "Суббота" }) {
                cancelRecognition()
                cancelGestureRecognition()
                date = day.key
                getTimeTable(id: id, date: date, owner: owner) {
                    DispatchQueue.main.async {
                        self.startSpeechRecognition()
                        self.startSession()
                    }
                }
            } else {
                self.showInfoAlert(title: "День не найден!", message: "у текущей недели нет такого дня", actions: [ok])
            }
            closeModals()
            HapticsManager.shared.hapticFeedback()
        }
    }
    
    func showPairsForDate(text: String) {
        let ok = UIAlertAction(title: "ОК", style: .default) { _ in
            self.startSession()
            SpeechSynthesizerManager.shared.stopComment()
        }
        if text.lowercased().contains(text.lowercased().getDateFromString()) {
            if dateManager.checkDateFromWords(text: text) {
                cancelRecognition()
                cancelGestureRecognition()
                self.date = dateManager.getDateFromWords(date: text.getDateFromString())
                getTimeTable(id: id, date: date, owner: owner) {
                    DispatchQueue.main.async {
                        self.startSpeechRecognition()
                        self.startSession()
                    }
                }
            } else {
                self.showInfoAlert(title: "Неверная дата!", message: "не существует такой даты", actions: [ok])
            }
            closeModals()
            HapticsManager.shared.hapticFeedback()
        }
    }
    
    func showLeftedPairs(text: String) {
        if text.lowercased().contains("оставшиеся пары") || text.lowercased().contains("сколько осталось пар") || text.lowercased().contains("скоко осталось пар") || text.lowercased().contains("сколько пар осталось") || text.lowercased().contains("скоко пар осталось") {
            cancelRecognition()
            cancelGestureRecognition()
            refreshTimetable {
                DispatchQueue.main.async {
                    self.filterPairs(type: .leftToday)
                    self.countLeftedPairs()
                }
            }
            closeModals()
            HapticsManager.shared.hapticFeedback()
        }
    }
    
    func filterVoice(text: String) {
        for type in PairType.allCases {
            if text.lowercased().contains(type.voiceCommand) {
                print("ТИП ПАРЫ: \(type.rawValue)")
                cancelRecognition()
                cancelGestureRecognition()
                getTimeTable(id: id, date: date, owner: owner) {
                    DispatchQueue.main.async {
                        self.filterPairs(type: type)
                        self.startSpeechRecognition()
                        self.startSession()
                    }
                }
                closeModals()
                HapticsManager.shared.hapticFeedback()
                break
            }
        }
    }
    
    func filterBuildingVoice(text: String) {
        for building in AGPUBuildings.buildings {
            for voiceCommand in building.voiceCommands {
                if text.lowercased().contains(voiceCommand) {
                    cancelRecognition()
                    cancelGestureRecognition()
                    getTimeTable(id: id, date: date, owner: owner) {
                        DispatchQueue.main.async {
                            self.filterPairs(by: building)
                            self.startSpeechRecognition()
                            self.startSession()
                        }
                    }
                    closeModals()
                    HapticsManager.shared.hapticFeedback()
                    break
                }
            }
        }
    }
    
    func showCurrentPair(text: String) {
        if text.lowercased().contains("текущая пара") || text.lowercased().contains("сейчас пара") {
            cancelRecognition()
            cancelGestureRecognition()
            refreshTimetable {
                let leftedPairs = self.filterLeftedPairs()
                DispatchQueue.main.async {
                    if leftedPairs.count > 0 {
                        let time = leftedPairs[0].time
                        self.timetable.disciplines = self.allDisciplines.filter({ $0.time == time })
                        self.tableView.reloadData()
                    } else {
                        self.filterPairs(type: .none)
                    }
                    self.closeModals()
                    self.startSpeechRecognition()
                    self.startSession()
                    HapticsManager.shared.hapticFeedback()
                }
            }
        }
    }
    
    func showNextPair(text: String) {
        if text.lowercased().contains("следующая пара") {
            cancelRecognition()
            cancelGestureRecognition()
            refreshTimetable {
                let leftedPairs = self.filterLeftedPairs()
                let times = self.countLeftedTimes(pairs: leftedPairs)
                DispatchQueue.main.async {
                    if leftedPairs.count > 0 {
                        if times.count > 1 {
                            self.timetable.disciplines = self.allDisciplines.filter({ $0.time == times[1] })
                            self.tableView.reloadData()
                        } else {
                            self.filterPairs(type: .none)
                        }
                    } else {
                        self.filterPairs(type: .none)
                    }
                    self.closeModals()
                    self.startSpeechRecognition()
                    self.startSession()
                    HapticsManager.shared.hapticFeedback()
                }
            }
        }
    }
    
    func showPreviousPair(text: String) {
        if text.lowercased().contains("прошлая пара") || text.lowercased().contains("предыдущая пара") {
            cancelRecognition()
            cancelGestureRecognition()
            refreshTimetable {
                let leftedPairs = self.filterLeftedPairs()
                DispatchQueue.main.async {
                    if leftedPairs.count > 0 {
                        let time = leftedPairs[0].time
                        if let index = self.allDisciplines.firstIndex(where: { $0.time == time }) {
                            if index > 0 {
                                self.timetable.disciplines = self.allDisciplines.filter({ $0.time == self.allDisciplines[index - 1].time })
                                self.tableView.reloadData()
                            } else {
                                self.filterPairs(type: .none)
                            }
                        }
                    } else {
                        self.filterPairs(type: .none)
                    }
                    self.closeModals()
                    self.startSpeechRecognition()
                    self.startSession()
                    HapticsManager.shared.hapticFeedback()
                }
            }
        }
    }
    
    func showLastPair(text: String) {
        if text.lowercased().contains("последняя пара") {
            cancelRecognition()
            cancelGestureRecognition()
            refreshTimetable { DispatchQueue.main.async {
                if self.allDisciplines.count > 0 {
                    self.timetable.disciplines = self.allDisciplines.filter({ $0.time == self.allDisciplines.last?.time})
                    self.tableView.reloadData()
                } else {
                    self.filterPairs(type: .none)
                }
                self.closeModals()
                self.startSpeechRecognition()
                self.startSession()
                HapticsManager.shared.hapticFeedback()
            }
            }
        }
    }
    
    func showPairForCount(text: String) {
        
        let ok = UIAlertAction(title: "ОК", style: .default) { _ in
            self.startSession()
            SpeechSynthesizerManager.shared.stopComment()
        }
        
        if text.lowercased().contains("1-я пара") || text.lowercased().contains("первая пара") || text.lowercased().contains("первую пару") {
            cancelRecognition()
            cancelGestureRecognition()
            refreshTimetable {
                let times = self.countTimes()
                if times.count > 0 {
                    DispatchQueue.main.async {
                        self.timetable.disciplines = self.allDisciplines.filter({ $0.time.components(separatedBy: "-")[0] == times[0]})
                        self.tableView.reloadData()
                        self.startSpeechRecognition()
                        self.startSession()
                        self.closeModals()
                        HapticsManager.shared.hapticFeedback()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showInfoAlert(title: "1-й пары\n нет в списке", message: "", actions: [ok])
                        self.closeModals()
                        HapticsManager.shared.hapticFeedback()
                    }
                }
            }
        }
        
        if text.lowercased().contains("2-я пара") || text.lowercased().contains("вторая пара") || text.lowercased().contains("вторую пару") {
            cancelRecognition()
            cancelGestureRecognition()
            refreshTimetable {
                let times = self.countTimes()
                if times.count > 1 {
                    DispatchQueue.main.async {
                        self.timetable.disciplines = self.allDisciplines.filter({ $0.time.components(separatedBy: "-")[0] == times[1]})
                        self.tableView.reloadData()
                        self.startSpeechRecognition()
                        self.startSession()
                        self.closeModals()
                        HapticsManager.shared.hapticFeedback()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showInfoAlert(title: "2-й пары\n нет в списке", message: "", actions: [ok])
                        self.closeModals()
                        HapticsManager.shared.hapticFeedback()
                    }
                }
            }
        }
        
        if text.lowercased().contains("3-я пара") || text.lowercased().contains("третья пара") || text.lowercased().contains("третью пару") {
            cancelRecognition()
            cancelGestureRecognition()
            refreshTimetable {
                let times = self.countTimes()
                if times.count > 2 {
                    DispatchQueue.main.async {
                        self.timetable.disciplines = self.allDisciplines.filter({ $0.time.components(separatedBy: "-")[0] == times[2]})
                        self.tableView.reloadData()
                        self.startSpeechRecognition()
                        self.startSession()
                        self.closeModals()
                        HapticsManager.shared.hapticFeedback()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showInfoAlert(title: "3-й пары\n нет в списке", message: "", actions: [ok])
                        self.closeModals()
                        HapticsManager.shared.hapticFeedback()
                    }
                }
            }
        }
        
        if text.lowercased().contains("четвертая пара") || text.lowercased().contains("четвёртая пара") {
            cancelRecognition()
            cancelGestureRecognition()
            refreshTimetable {
                let times = self.countTimes()
                if times.count > 3 {
                    DispatchQueue.main.async {
                        self.timetable.disciplines = self.allDisciplines.filter({ $0.time.components(separatedBy: "-")[0] == times[3]})
                        self.tableView.reloadData()
                        self.startSpeechRecognition()
                        self.startSession()
                        self.closeModals()
                        HapticsManager.shared.hapticFeedback()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showInfoAlert(title: "4-й пары\n нет в списке", message: "", actions: [ok])
                        self.closeModals()
                        HapticsManager.shared.hapticFeedback()
                    }
                }
            }
        }
        
        if text.lowercased().contains("5-я пара") || text.lowercased().contains("пятая пара") || text.lowercased().contains("пятую пару") {
            cancelRecognition()
            cancelGestureRecognition()
            refreshTimetable {
                let times = self.countTimes()
                if times.count > 4 {
                    DispatchQueue.main.async {
                        self.timetable.disciplines = self.allDisciplines.filter({ $0.time.components(separatedBy: "-")[0] == times[4]})
                        self.tableView.reloadData()
                        self.startSpeechRecognition()
                        self.startSession()
                        self.closeModals()
                        HapticsManager.shared.hapticFeedback()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showInfoAlert(title: "5-й пары\n нет в списке", message: "", actions: [ok])
                        self.closeModals()
                        HapticsManager.shared.hapticFeedback()
                    }
                }
            }
        }
        
        if text.lowercased().contains("6-я пара") || text.lowercased().contains("шестая пара") || text.lowercased().contains("шестую пару") {
            cancelRecognition()
            cancelGestureRecognition()
            refreshTimetable {
                let times = self.countTimes()
                if times.count > 5 {
                    DispatchQueue.main.async {
                        self.timetable.disciplines = self.allDisciplines.filter({ $0.time.components(separatedBy: "-")[0] == times[5]})
                        self.tableView.reloadData()
                        self.startSpeechRecognition()
                        self.startSession()
                        self.closeModals()
                        HapticsManager.shared.hapticFeedback()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showInfoAlert(title: "6-й пары\n нет в списке", message: "", actions: [ok])
                        self.closeModals()
                        HapticsManager.shared.hapticFeedback()
                    }
                }
            }
        }
        
        if text.lowercased().contains("7-я пара") || text.lowercased().contains("седьмая пара") || text.lowercased().contains("седьмую пару") {
            cancelRecognition()
            cancelGestureRecognition()
            refreshTimetable {
                let times = self.countTimes()
                if times.count > 6 {
                    DispatchQueue.main.async {
                        self.timetable.disciplines = self.allDisciplines.filter({ $0.time.components(separatedBy: "-")[0] == times[6]})
                        self.tableView.reloadData()
                        self.startSpeechRecognition()
                        self.startSession()
                        self.closeModals()
                        HapticsManager.shared.hapticFeedback()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showInfoAlert(title: "7-й пары\n нет в списке", message: "", actions: [ok])
                        self.closeModals()
                        HapticsManager.shared.hapticFeedback()
                    }
                }
            }
        }
    }
    
    func timetableNavigation(text: String) {
        
        if text.lowercased().contains("обнови") {
            cancelRecognition()
            cancelGestureRecognition()
            refreshTimetable {
                DispatchQueue.main.async {
                    self.startSpeechRecognition()
                    self.startSession()
                }
            }
            closeModals()
            HapticsManager.shared.hapticFeedback()
        }
        
        if text.lowercased().contains("сегодн") {
            cancelRecognition()
            cancelGestureRecognition()
            currentDay() {
                self.startSpeechRecognition()
                self.startSession()
            }
            closeModals()
            HapticsManager.shared.hapticFeedback()
        }
        
        if text.lowercased().contains("завтр") {
            cancelRecognition()
            cancelGestureRecognition()
            tomorrowDay() {
                self.startSpeechRecognition()
                self.startSession()
            }
            closeModals()
            HapticsManager.shared.hapticFeedback()
        }
        
        if text.lowercased().contains("вчер") {
            cancelRecognition()
            cancelGestureRecognition()
            yesterDay() {
                self.startSpeechRecognition()
                self.startSession()
            }
            closeModals()
            HapticsManager.shared.hapticFeedback()
        }
        
        if text.lowercased().contains("вперёд") || text.lowercased().contains("вперед") {
            cancelRecognition()
            cancelGestureRecognition()
            nextDay() {
                self.startSpeechRecognition()
                self.startSession()
            }
            closeModals()
            HapticsManager.shared.hapticFeedback()
        }
        
        if text.lowercased().contains("назад") || text.lowercased().contains("обратно") {
            cancelRecognition()
            cancelGestureRecognition()
            pastDay() {
                self.startSpeechRecognition()
                self.startSession()
            }
            closeModals()
            HapticsManager.shared.hapticFeedback()
        }
    }
    
    func closeAlertWithVoice(text: String) {
        if text.lowercased().contains("закр") {
            resetSpeechRecognition()
            startSession()
            closeModals()
            HapticsManager.shared.hapticFeedback()
        }
    }
    
    func createAlertMessage()-> (String, String) {
        let style = settingsManager.getSavedCommunicationStyle()
        let name = UserDefaults.standard.string(forKey: "name") ?? ""
        switch style {
        case .formal:
            return ("Микрофон выключен", "\(!name.isEmpty ? "\(name) хотите" : "Хотите") включить в настройках?")
        case .informal:
            return ("Микрофон выключен", "\(!name.isEmpty ? "\(name) хочешь" : "Хочешь") врубить в настройках?")
        }
    }
    
    func openCalendar() {
        let vc = CalendarViewController(id: self.id, subgroup: self.subgroup, date: self.date, owner: self.owner)
        vc.delegate = self
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true)
    }
    
    func openNameCalendar(name: String) {
        let vc = CalendarDisciplineNameViewController(id: self.id, date: self.date, owner: self.owner, name: name)
        vc.delegate = self
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true)
    }
    
    func openWeeksList() {
        let vc = AllWeeksListTableViewController(id: self.id, subgroup: self.subgroup, owner: self.owner)
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true)
    }
    
    // навигация
    func currentDay(completion: @escaping()->Void) {
        date = dateManager.getCurrentDate()
        type = .all
        subgroup = 0
        getTimeTable(id: id, date: date, owner: owner) {
            completion()
        }
    }
    
    @objc func nextDay(completion: @escaping()->Void) {
        date = dateManager.nextDay(date: date)
        type = .all
        subgroup = 0
        getTimeTable(id: id, date: date, owner: owner) {
            completion()
        }
    }
    
    @objc func pastDay(completion: @escaping()->Void) {
        date = dateManager.previousDay(date: date)
        type = .all
        subgroup = 0
        getTimeTable(id: id, date: date, owner: owner) {
            completion()
        }
    }
    
    func tomorrowDay(completion: @escaping()->Void) {
        let currentDate = dateManager.getCurrentDate()
        date = dateManager.nextDay(date: currentDate)
        type = .all
        subgroup = 0
        getTimeTable(id: id, date: date, owner: owner) {
            completion()
        }
    }
    
    func yesterDay(completion: @escaping()->Void) {
        let currentDate = dateManager.getCurrentDate()
        date = dateManager.previousDay(date: currentDate)
        type = .all
        subgroup = 0
        getTimeTable(id: id, date: date, owner: owner) {
            completion()
        }
    }
    
    @objc func nextMonth(completion: @escaping()->Void) {
        date = dateManager.nextMonth(date: date)
        type = .all
        subgroup = 0
        getTimeTable(id: id, date: date, owner: owner) {
            completion()
        }
    }
    
    @objc func pastMonth(completion: @escaping()->Void) {
        date = dateManager.pastMonth(date: date)
        type = .all
        subgroup = 0
        getTimeTable(id: id, date: date, owner: owner) {
            completion()
        }
    }
    
    @objc func nextYear(completion: @escaping()->Void) {
        date = dateManager.nextYear(date: date)
        type = .all
        subgroup = 0
        getTimeTable(id: id, date: date, owner: owner) {
            completion()
        }
    }
    
    @objc func pastYear(completion: @escaping()->Void) {
        date = dateManager.pastYear(date: date)
        type = .all
        subgroup = 0
        getTimeTable(id: id, date: date, owner: owner) {
            completion()
        }
    }
    
    func countLeftedTimes(pairs: [Discipline])-> [String] {
        
        var uniqueTimes: Set<String> = Set()
        
        for pair in pairs {
            
            let time = pair.time
            
            uniqueTimes.insert(time)
        }
        
        return Array(uniqueTimes).sorted { dateManager.compareTimes(time1: "\($0.components(separatedBy: "-")[0]):00", time2: "\($1.components(separatedBy: "-")[0]):00") == .orderedAscending}
    }
    
    func countTimes()-> [String] {
        
        var uniqueTimes: Set<String> = Set()
        
        for pair in allDisciplines {
            
            let times = pair.time.components(separatedBy: "-")
            let startTime = times[0]
            
            uniqueTimes.insert(startTime)
        }
        
        return Array(uniqueTimes).sorted { dateManager.compareTimes(time1: "\($0):00", time2: "\($1):00") == .orderedAscending}
    }
    
    func countEndTimes()-> [String] {
        
        var uniqueTimes: Set<String> = Set()
        
        for pair in allDisciplines {
            
            let times = pair.time.components(separatedBy: "-")
            let startTime = times[1]
            
            uniqueTimes.insert(startTime)
        }
        
        return Array(uniqueTimes).sorted { dateManager.compareTimes(time1: "\($0):00", time2: "\($1):00") == .orderedAscending}
    }
    
    func countPairs() {
        
        var uniqueTimes: Set<String> = Set()
        let ok = UIAlertAction(title: "ОК", style: .default) { _ in
            self.startSession()
            SpeechSynthesizerManager.shared.stopComment()
        }
        
        for pair in allDisciplines {
            
            let times = pair.time.components(separatedBy: "-")
            let startTime = times[0]
            
            uniqueTimes.insert(startTime)
        }
        
        showInfoAlert(title: "\(date)\nвсего пар: \(uniqueTimes.count)", message: "", actions: [ok])
    }
    
    func countLeftedPairs() {
        
        var uniqueTimes: Set<String> = Set()
        let ok = UIAlertAction(title: "ОК", style: .default) { _ in
            self.startSession()
            SpeechSynthesizerManager.shared.stopComment()
        }
        
        for pair in timetable.disciplines {
            
            let times = pair.time.components(separatedBy: "-")
            let startTime = times[0]
            
            uniqueTimes.insert(startTime)
        }
        
        showInfoAlert(title: "\(date)\nосталось пар: \(uniqueTimes.count)", message: "", actions: [ok])
    }
    
    func showInfoAlert(title: String, message: String, actions: [UIAlertAction]) {
        let isSaying = UserDefaults.standard.object(forKey: "isSaying") as? Bool ?? false
        if isSaying {
            showAlert(title: title, message: message, actions: actions)
        } else {
            resetSpeechRecognition()
            showAlert(title: title, message: message, actions: actions)
        }
    }
    
    func shareTimetable(completion: @escaping()->Void) {
        let ok = UIAlertAction(title: "ОК", style: .default) { _ in
            self.startSession()
            SpeechSynthesizerManager.shared.stopComment()
        }
        do {
            let json = try JSONEncoder().encode(timetable)
            let dayOfWeek = self.dateManager.getCurrentDayOfWeek(date: self.date)
            self.service.getTimeTableDayImage(json: json) { image in
                self.ShareImage(image: image, title: self.id, text: "\(dayOfWeek) \(self.date)")
                HapticsManager.shared.hapticFeedback()
                completion()
            }
        } catch {
            self.showInfoAlert(title: "Ошибка", message: "не получилось создать картинку", actions: [ok])
            completion()
        }
    }
    
    func cancelGestureRecognition() {
        let screens = settingsManager.loadScreens(way: differentWays.gestureRecognition)
        let isContains = screens.contains(appScreens.timetableDay)
        if isContains {
            if let session = captureSession {
                session.stopRunning()
            }
            self.currentCameraState = .off
            self.updateCameraButtonMenu()
        }
    }
    
    func findPairDaysMenu(name: String)-> UIMenu {
        
        let originalName = timetablePseudonymManager.returnOriginalDisciplineName(name: name)
        
        let calendarAction = UIAction(title: "Календарь", image: UIImage(named: "calendar icon")) { _ in
            self.openNameCalendar(name: originalName)
        }
        
        let nextDayAction = UIAction(title: "Следующий день", image: UIImage(named: "forward")) { _ in
            self.nextDay {
                self.filterPairs(name: originalName)
            }
        }
        
        let pastDayAction = UIAction(title: "Предыдущий день", image: UIImage(named: "backward")) { _ in
            self.pastDay {
                self.filterPairs(name: originalName)
            }
        }
        
        return UIMenu(title: "Найти пару", image: UIImage(named: "search"), children: [calendarAction, nextDayAction, pastDayAction])
    }
    
    func dateNavigationMenu()-> UIMenu {
        let types = DateNavigationTypes.allCases.map { type in
            UIAction(title: type.rawValue, state: currentNavigationType == type ? .on : .off) { _ in
                self.currentNavigationType = type
            }}
        return UIMenu(title: "Типы навигации", children: types)
    }
    
    func nextWeek()-> WeekModel {
        if (currentWeek.id < weeks.last?.id ?? 0) && currentWeek.id != 0 {
            return weeks[currentWeek.id]
        }
        return WeekModel(id: 0, from: "", to: "", dayNames: ["":""])
    }
}

extension TimeTableDayListTableViewController {
    
    func setUpTimetableMenu()-> UIMenu {
        let savedOptions = settingsManager.loadMenuOptions(category: menuOptionCategories.timetableDay.rawValue)
        let options = savedOptions.map { findOption(option: $0) }
        return UIMenu(title: "Расписание", children: options)
    }
    
    func getAllOptions()-> [UIAction] {
        
        // Поиск
        let searchAction = UIAction(title: "Поиск") { _ in
            self.openSearch()
        }
        
        // Информация о паре
        let timetableInfoAction = UIAction(title: "Сколько пар?") { _ in
            self.showTimetableInfo()
        }
        
        let abbreviationsAction = UIAction(title: "Псевдонимы") { _ in
            let vc = TimetablePseudonymCategoriesListTableViewController()
            vc.delegate = self
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        // AR
        let ARAction = UIAction(title: "AR режим") { _ in
            self.openAR()
        }
        
        // Нужное здание
        let nearBuildingAction = UIAction(title: "Нужное здание") { _ in
            let vc = NearBuildingViewController(info: .audiences)
            vc.delegate = self
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
        
        // список групп
        let groupsList = UIAction(title: "Группы") { _ in
            let vc = AllGroupsListTableViewController(group: self.id)
            vc.delegate = self
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        // список подгрупп
        let subGroupsList = UIAction(title: "Подгруппы") { _ in
            let vc = SubGroupsListTableViewController(subgroup: self.subgroup, disciplines: self.allDisciplines)
            vc.delegate = self
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        // преподаватели
        let teachersList = UIAction(title: "Преподаватели") { _ in
            let vc = DepartmentsListTableViewController()
            vc.delegate = self
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        // аудитории
        let audiencesList = UIAction(title: "Аудитории") { _ in
            let vc = CorpsListTableViewController()
            vc.delegate = self
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        // избранное
        let favouritesList = UIAction(title: "Избранное") { _ in
            self.openFavouritesList()
        }
        
        // день
        let days = UIAction(title: "Список дней") { _ in
            self.openDaysList()
        }
        
        // недели
        let weeks = UIAction(title: "Недели") { _ in
            self.openWeeksList()
        }
        
        // календарь
        let calendar = UIAction(title: "Календарь") { _ in
            self.openCalendar()
        }
        
        // фильтрация
        let pairTypesList = UIAction(title: "Фильтрация") { _ in
            self.openFilterOptionsList()
        }
        
        // сохранить расписание
        let saveTimetable = UIAction(title: "Сохранить") { _ in
            self.showSaveImageAlert()
        }
        
        // способы навигации
        let navigationsList = UIAction(title: "Навигация") { _ in
            let vc = NavigationsListTableViewController(screen: .timetableDay)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        let voiceCommandsAction = UIAction(title: "Голосовые команды") { _ in
            let vc = VoiceCommandsListTableViewController(type: .timetableDay)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        // поделиться расписанием
        let shareTimeTable = UIAction(title: "Поделиться") { _ in
            self.shareTimetable() {}
        }
        
        return [
            searchAction,
            timetableInfoAction,
            abbreviationsAction,
            ARAction,
            nearBuildingAction,
            groupsList,
            subGroupsList,
            teachersList,
            audiencesList,
            favouritesList,
            days,
            weeks,
            calendar,
            pairTypesList,
            saveTimetable,
            navigationsList,
            voiceCommandsAction,
            shareTimeTable
        ]
    }
    
    func findOption(option: MenuOptionModel)-> UIAction  {
        let originalOptions = getAllOptions()
        let searchOption = TimetableDayOptions.list.first(where: { $0.name == option.name })!
        let item = originalOptions.first { $0.title == searchOption.name }!
        return item
    }
}
