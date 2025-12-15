//
//  TimeTableWeekListTableViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 06.08.2023.
//

import UIKit
import AVFoundation
import MediaPipeTasksVision

// MARK: - UITableViewDelegate
extension TimeTableWeekListTableViewController: UITableViewDelegate {
    
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
        label.text = timetablePseudonymManager.setUpDayOfWeekPseudonym(date: timetable[section].date)
        label.textColor = .label
        label.font = .systemFont(ofSize: 17, weight: .black)
        
        let button = InteractiveView()
        button.image = UIImage(named: "filter icon")
        button.tapAction = {
            self.showFilter(date: self.timetable[section].date)
        }
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(button)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: header.topAnchor, constant: 10),
            label.leftAnchor.constraint(equalTo: header.leftAnchor, constant: 10),
            label.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -10),
            
            button.topAnchor.constraint(equalTo: header.topAnchor, constant: 15),
            button.rightAnchor.constraint(equalTo: header.rightAnchor, constant: -10),
            button.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -15),
            button.heightAnchor.constraint(equalToConstant: 10),
            button.widthAnchor.constraint(equalToConstant: 35),
        ])
        return header
    }
    
    @objc func showFilter(date: String) {
        let id = allTimetable.firstIndex { $0.date == date }!
        let vc = TimetableFilterCategoriesListTableViewController(date: date, type: typesDict[date]!, disciplines: allTimetable[id].disciplines, building: buildingsDict[date], time: timesDict[date])
        vc.delegate = self
        self.currentDate = date
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true)
    }
    
    func showFilter() {
        let vc = DateDaysListViewController(days: allTimetable, week: week, typesDict: typesDict, buildingsDict: buildingsDict, timesDict: timesDict)
        vc.delegate = self
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil,
                                          actionProvider: {
            _ in
            
            let discipline = self.timetable[indexPath.section].disciplines[indexPath.row]
            
            let addPseyMenu = self.timetableMenuManager.addTimetablePseyMenu(discipline: discipline)
            
            let originalName = self.timetablePseudonymManager.returnOriginalDisciplineName(name: discipline.name)
            
            let mapAction = UIAction(title: "Найти корпус", image: UIImage(named: "map icon")) { _ in
                let originalRoom = self.timetablePseudonymManager.returnOriginalAudienceName(audience: discipline.audienceID)
                let vc = AGPUCurrentBuildingMapViewController(audienceID: originalRoom, id: self.id, owner: self.owner)
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                    self.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
                if self.timetable[indexPath.section].disciplines[indexPath.row].audienceID == ""  {
                    self.showAlert(title: "Корпус не найден!", message: "К сожалению у данной пары отсутствует аудитория", actions: [UIAlertAction(title: "ОК", style: .default)])
                }
            }
            
            return UIMenu(title: originalName, children: [
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
        cell.delegate = self
        cell.configure(timetable: timetable[indexPath.section], index: indexPath.row)
        return cell
    }
}

// MARK: - ITimeTableTableViewCell
extension TimeTableWeekListTableViewController: ITimeTableTableViewCell {
    
    func cellTapped(pair: Discipline, id: String, date: String) {
        let vc = PairInfoTableViewController(pair: pair, id: id, date: date)
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
}

// MARK: - WeekDaysListTableViewControllerDelegate
extension TimeTableWeekListTableViewController: WeekDaysListTableViewControllerDelegate {
    
    func dateWasSelected(index: Int) {
        currentDate = timetable[index].date
        tableView.scrollToRow(at: IndexPath(row: 0, section: index), at: .top, animated: true)
    }
}

// MARK: - DateDaysListViewControllerDelegate
extension TimeTableWeekListTableViewController: DateDaysListViewControllerDelegate {
    
    func timeWasSelected(date: String, time: String) {
        currentDate = date
        filterPairs(by: time)
    }
    
    func buildingWasSelected(date: String, building: AGPUBuildingModel) {
        currentDate = date
        filterPairs(by: building)
    }
    
    func pairTypeSelected(date: String, type: PairType) {
        currentDate = date
        filterPairs(type: type)
    }
}

// MARK: - TimeTableSearchListTableViewControllerDelegate
extension TimeTableWeekListTableViewController: TimeTableSearchListTableViewControllerDelegate {
    
    func itemWasSelected(result: SearchTimetableModel) {
        self.id = result.name
        self.owner = result.owner
        getTimeTable {}
    }
}

// MARK: - TimetableWeekARDelegate
extension TimeTableWeekListTableViewController: TimetableWeekARDelegate {
    
    func weekWasSelected(week: WeekModel) {
        self.week = week
        toggleButtons(on: false)
        getTimeTable {}
        updateTitle()
    }
}

// MARK: - NearBuildingViewControllerDelegate
extension TimeTableWeekListTableViewController: NearBuildingViewControllerDelegate {
    
    func audienceSelected(audience: String) {
        self.id = audience
        self.owner = "CLASSROOM"
        getTimeTable {}
    }
}

// MARK: - AllGroupsListTableViewControllerDelegate
extension TimeTableWeekListTableViewController: AllGroupsListTableViewControllerDelegate {
    
    func groupWasSelected(group: String) {
        self.id = group
        self.owner = "GROUP"
        getTimeTable {}
    }
}

// MARK: - DepartmentsListTableViewControllerDelegate
extension TimeTableWeekListTableViewController: DepartmentsListTableViewControllerDelegate {
    
    func teacherSelected(teacher: String) {
        self.id = teacher
        self.owner = "TEACHER"
        getTimeTable {}
    }
}

// MARK: - CorpsListTableViewControllerDelegate
extension TimeTableWeekListTableViewController: CorpsListTableViewControllerDelegate {
    
    func audienceWasSelected(audience: String) {
        self.id = audience
        self.owner = "CLASSROOM"
        getTimeTable {}
    }
}

// MARK: - TimeTableFavouriteItemsListTableViewControllerDelegate
extension TimeTableWeekListTableViewController: TimeTableFavouriteItemsListTableViewControllerDelegate {
    
    func WasSelected(result: SearchTimetableModel) {
        self.id = result.name
        self.owner = result.owner
        getTimeTable {}
    }
}

// MARK: - UIScrollViewDelegate
extension TimeTableWeekListTableViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if tableView.isUserInteractionEnabled {
            checkScrollPosition()
            buttonSettingsManager?.handleScroll()
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("прокрутка завершилась")
        HapticsManager.shared.hapticFeedback()
        tableView.isUserInteractionEnabled = true
    }
}

// MARK: - TimetableFilterCategoriesListTableViewControllerDelegate
extension TimeTableWeekListTableViewController: TimetableFilterCategoriesListTableViewControllerDelegate {
    
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

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
extension TimeTableWeekListTableViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
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
    
    func makeDateAlertForWeek(gesture: handGestures) {
        switch gesture {
        case .one:
            pastWeek {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.startSession()
                }
            }
            HapticsManager.shared.hapticFeedback()
        case .two:
            nextWeek {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.startSession()
                }
            }
            HapticsManager.shared.hapticFeedback()
        case .palm:
            currentWeek {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.startSession()
                }
            }
            HapticsManager.shared.hapticFeedback()
        case .fist:
            refreshTimetable {
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
    
    func currentWeek(week: WeekModel)-> WeekModel {
        return weeks[currentWeekId - 1]
    }
    
    func nextWeek(week: WeekModel)-> WeekModel {
        if (week.id < weeks.last?.id ?? 0) && week.id != 0 {
            return weeks[week.id]
        }
        return WeekModel(id: 0, from: "", to: "", dayNames: ["":""])
    }
    
    func pastWeek(week: WeekModel)-> WeekModel {
        if (week.id > weeks.first?.id ?? 0) && week.id != 0 {
            let number = week.id - 1
            return weeks[number - 1]
        }
        return WeekModel(id: 0, from: "", to: "", dayNames: ["":""])
    }
    
    func showInfoAlert(title: String, message: String, actions: [UIAlertAction]) {
        let isSaying = UserDefaults.standard.object(forKey: "isSaying") as? Bool ?? false
        if isSaying {
            showAlert(title: title, message: message, actions: actions)
        } else {
            if let _ = self.presentedViewController as? UIAlertController {
                resetSpeechRecognition()
            }
            showAlert(title: title, message: message, actions: actions)
        }
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
    
    func cancelGestureRecognition() {
        let screens = settingsManager.loadScreens(way: futuristicWays.gestureRecognition)
        let isContains = screens.contains(appScreens.timetableWeek)
        if isContains {
            if let session = captureSession {
                session.stopRunning()
            }
            self.currentCameraState = .off
            self.updateCameraButtonMenu()
        }
    }
    
    func setUpCaptureSession() {
        
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: currentCameraPosition) else {return}
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            return
        }
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        } else {
            return
        }
        
        startSession()
    }
}

// MARK: - TimetablePseudonymCategoriesListTableViewControllerDelegate
extension TimeTableWeekListTableViewController: TimetablePseudonymCategoriesListTableViewControllerDelegate {
    
    func dataWasChanged() {
        refreshTimetable {}
    }
}

// MARK: - MenuOptionsListTableViewControllerDelegate
extension TimeTableWeekListTableViewController: MenuOptionsListTableViewControllerDelegate {
    
    func listWasUpdated() {
        updateMenu()
    }
    
    func updateMenu() {
        guard let item = self.navigationItem.rightBarButtonItems?.first(where: { $0.accessibilityIdentifier == "menu" }) else {return}
        item.menu = setUpTimetableMenu()
    }
}

extension TimeTableWeekListTableViewController {
    
    func isMicOn()-> Bool {
        let isOn = settingsManager.loadScreens(way: futuristicWays.voiceCommands).contains(appScreens.timetableWeek)
        if isOn {
            return speechRecognitionManager.tapInstalled
        }
        return false
    }
    
    func isRecording()-> Bool {
        return settingsManager.loadScreens(way: futuristicWays.voiceCommands).contains(appScreens.timetableWeek)
    }
    
    func checkVoiceCommandsOption() {
        let screens = settingsManager.loadScreens(way: futuristicWays.voiceCommands)
        if screens.contains(appScreens.timetableWeek) {
            resetSpeechRecognition()
        }
    }
    
    func startSpeechRecognition() {
        let screens = settingsManager.loadScreens(way: futuristicWays.voiceCommands)
        if screens.contains(appScreens.timetableWeek) {
            startRecognize()
        }
    }
    
    func resetSpeechRecognition() {
        let screens = settingsManager.loadScreens(way: futuristicWays.voiceCommands)
        if screens.contains(appScreens.timetableWeek) {
            cancelRecognition()
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                self.startRecognize()
            }
        }
    }
    
    func cancelRecognition() {
        let screens = settingsManager.loadScreens(way: futuristicWays.voiceCommands)
        if screens.contains(appScreens.timetableWeek) {
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
        timetableNavigation(text: text)
        checkWeekDay(text: text)
    }
    
    func timetableNavigation(text: String) {
        
        if text.lowercased().contains("обнови") {
            cancelRecognition()
            cancelGestureRecognition()
            refreshTimetable {
                self.startSpeechRecognition()
                self.startSession()
            }
            closeModals()
            HapticsManager.shared.hapticFeedback()
        }
        
        if text.lowercased().contains("текущ") {
            cancelRecognition()
            cancelGestureRecognition()
            currentWeek {
                self.startSpeechRecognition()
                self.startSession()
            }
            closeModals()
            HapticsManager.shared.hapticFeedback()
        }
        
        if text.lowercased().contains("вперёд") || text.lowercased().contains("вперед") {
            cancelRecognition()
            cancelGestureRecognition()
            nextWeek {
                self.startSpeechRecognition()
                self.startSession()
            }
            closeModals()
            HapticsManager.shared.hapticFeedback()
        }
        
        if text.lowercased().contains("назад") || text.lowercased().contains("обратно") {
            cancelRecognition()
            cancelGestureRecognition()
            pastWeek {
                self.startSpeechRecognition()
                self.startSession()
            }
            closeModals()
            HapticsManager.shared.hapticFeedback()
        }
    }
    
    func checkWeekDay(text: String) {
        
        if text.lowercased().contains("понедельник") {
            if let day = week.dayNames.first(where: { $1 == "Понедельник" }) {
                resetSpeechRecognition()
                currentDate = day.key
                scrollToSection(isTimer: false)
            }
        }
        
        if text.lowercased().contains("вторник") {
            if let day = week.dayNames.first(where: { $1 == "Вторник" }) {
                resetSpeechRecognition()
                currentDate = day.key
                scrollToSection(isTimer: false)
            }
        }
        
        if text.lowercased().contains("сред") {
            if let day = week.dayNames.first(where: { $1 == "Среда" }) {
                resetSpeechRecognition()
                currentDate = day.key
                scrollToSection(isTimer: false)
            }
        }
        
        if text.lowercased().contains("четверг") {
            if let day = week.dayNames.first(where: { $1 == "Четверг" }) {
                resetSpeechRecognition()
                currentDate = day.key
                scrollToSection(isTimer: false)
            }
        }
        
        if text.lowercased().contains("пятниц") {
            if let day = week.dayNames.first(where: { $1 == "Пятница" }) {
                resetSpeechRecognition()
                currentDate = day.key
                scrollToSection(isTimer: false)
            }
        }
        
        if text.lowercased().contains("суббот") {
            if let day = week.dayNames.first(where: { $1 == "Суббота" }) {
                resetSpeechRecognition()
                currentDate = day.key
                scrollToSection(isTimer: false)
            }
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
    
    func currentWeek(completion: @escaping()->Void) {
        week = weeks[currentWeekId - 1]
        toggleButtons(on: false)
        getTimeTable {
            completion()
        }
        updateTitle()
    }
    
    func checkButtons() {
        if week.id == 1 {
            checkLeftButton()
        }
        if week.id == weeks.count {
            checkRightButton()
        }
    }
    
    @objc func pastWeek(completion: @escaping()->Void) {
        if (week.id > weeks.first?.id ?? 0) && week.id != 0 {
            let number = week.id - 1
            week = weeks[number - 1]
            toggleButtons(on: false)
            getTimeTable {
                completion()
            }
        }
        checkLeftButton()
        updateTitle()
    }
    
    func checkLeftButton() {
        guard let next = navigationItem.rightBarButtonItems?.first(where: { $0.accessibilityIdentifier == "next" }) else {return}
        if week.id == 1 {
            let past = navigationItem.leftBarButtonItems?.first(where: { $0.accessibilityIdentifier == "past" })
            past?.isHidden = true
        }
        if next.isHidden {
            next.isHidden = false
        }
    }
    
    @objc func nextWeek(completion: @escaping()->Void) {
        if (week.id < weeks.last?.id ?? 0) && week.id != 0 {
            week = weeks[week.id]
            toggleButtons(on: false)
            getTimeTable {
                completion()
            }
        }
        checkRightButton()
        updateTitle()
    }
    
    func checkRightButton() {
        guard let past = navigationItem.leftBarButtonItems?.first(where: { $0.accessibilityIdentifier == "past" }) else {return}
        if week.id == weeks.count {
            let next = navigationItem.rightBarButtonItems?.first(where: { $0.accessibilityIdentifier == "next" })
            next?.isHidden = true
        }
        if past.isHidden {
            past.isHidden = false
        }
    }
    
    func updateTitle() {
        navigationItem.title = "с \(week.from) до \(week.to)"
    }
    
    func checkScrollPosition() {
        if let indexPath = tableView.indexPathForRow(at: CGPoint(x: 0, y: tableView.contentOffset.y + 200)) {
            currentDate = timetable[indexPath.section].date
        }
    }
    
    func filterPairs(by building: AGPUBuildingModel) {
        let index = allTimetable.firstIndex { $0.date == currentDate }!
        self.currentBuilding = building
        self.buildingsDict[currentDate] = building
        self.typesDict[currentDate] = .all
        self.timesDict[currentDate] = nil
        var disciplines = [Discipline]()
        guard let corp = currentBuilding else {return}
        for audience in corp.audiences {
            for pair in allTimetable[index].disciplines {
                if audience == pair.audienceID {
                    disciplines.append(pair)
                }
            }
        }
        
        DispatchQueue.main.async {
            self.timetable[index].disciplines = disciplines.sorted { self.dateManager.compareTimes(time1: "\($0.time.components(separatedBy: "-")[0]):00", time2: "\($1.time.components(separatedBy: "-")[0]):00") == .orderedAscending}
            self.timetable = self.timetable.filter { !$0.disciplines.isEmpty }
            self.refreshTable()
            if self.timetable.isEmpty {
                self.noTimeTableLabel.text = "Нет пар"
                self.noTimeTableLabel.isHidden = false
            } else {
                if !self.timetable[index].disciplines.isEmpty {
                    self.scrollToSection(isTimer: true)
                    self.noTimeTableLabel.isHidden = true
                }
            }
        }
    }
    
    func filterPairs(by time: String) {
        let index = allTimetable.firstIndex { $0.date == currentDate }!
        self.timesDict[currentDate] = time
        self.buildingsDict[currentDate] = nil
        self.typesDict[currentDate] = .all
        DispatchQueue.main.async {
            self.timetable[index].disciplines = self.allTimetable[index].disciplines.filter({ $0.time == time })
            self.timetable = self.timetable.filter { !$0.disciplines.isEmpty }
            self.refreshTable()
            if self.timetable.isEmpty {
                self.noTimeTableLabel.text = "Нет пар"
                self.noTimeTableLabel.isHidden = false
            } else {
                if !self.timetable[index].disciplines.isEmpty {
                    self.scrollToSection(isTimer: true)
                    self.noTimeTableLabel.isHidden = true
                }
            }
        }
    }
}

extension TimeTableWeekListTableViewController {
    
    func setUpTimetableMenu()-> UIMenu {
        let savedOptions = settingsManager.loadMenuOptions(category: menuOptionCategories.timetableWeek.rawValue)
        let options = savedOptions.map { findOption(option: $0) }
        return UIMenu(title: "Расписание", children: options)
    }
    
    func getAllOptions()-> [UIAction] {
        
        let searchAction = UIAction(title: "Поиск") { _ in
            let vc = TimeTableSearchListTableViewController()
            vc.isSettings = false
            vc.delegate = self
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        let abbreviationsAction = UIAction(title: "Псевдонимы") { _ in
            let vc = TimetablePseudonymCategoriesListTableViewController()
            vc.delegate = self
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        let ARAction = UIAction(title: "AR режим") { _ in
            let vc = TimetableARViewController(id: self.id, subgroup: self.subgroup, date: self.currentDate, owner: self.owner)
            vc.currentWeek = self.week
            vc.weekDelegate = self
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.createImage {
                vc.image = self.image
                self.present(navVC, animated: true)
            }
        }
        
        let nearBuildingAction = UIAction(title: "Нужное здание") { _ in
            let vc = NearBuildingViewController(info: .audiences)
            vc.delegate = self
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
        
        let groupsList = UIAction(title: "Группы") { _ in
            let vc = AllGroupsListTableViewController(group: self.id)
            vc.delegate = self
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        let teachersList = UIAction(title: "Преподаватели") { _ in
            let vc = DepartmentsListTableViewController()
            vc.delegate = self
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        let audiencesList = UIAction(title: "Аудитории") { _ in
            let vc = CorpsListTableViewController()
            vc.delegate = self
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        // список дней
        let days = UIAction(title: "День") { _ in
            let vc = WeekDaysListTableViewController(id: self.id, owner: self.owner, week: self.week, timetable: self.timetable, currentDate: self.currentDate)
            vc.delegate = self
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        // избранное
        let favouritesList = UIAction(title: "Избранное") { _ in
            let vc = TimeTableFavouriteItemsListTableViewController()
            vc.delegate = self
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        let filterAction = UIAction(title: "Фильтрация") { _ in
            self.showFilter()
        }
        
        // сохранить расписание
        let saveTimetable = UIAction(title: "Сохранить") { _ in
            self.showSaveImageAlert()
        }
        
        // способы навигации
        let navigationsList = UIAction(title: "Навигация") { _ in
            let vc = NavigationsListTableViewController(screen: .timetableWeek)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        let voiceCommandsAction = UIAction(title: "Голосовые команды") { _ in
            let vc = VoiceCommandsListTableViewController(type: .timetableWeek)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        // поделиться
        let share = UIAction(title: "Поделиться") { _ in
            self.shareTimetable()
        }
        
        return [
            searchAction,
            abbreviationsAction,
            ARAction,
            nearBuildingAction,
            groupsList,
            teachersList,
            audiencesList,
            days,
            favouritesList,
            filterAction,
            saveTimetable,
            navigationsList,
            voiceCommandsAction,
            share
        ]
    }
    
    func findOption(option: MenuOptionModel)-> UIAction {
        let originalOptions = getAllOptions()
        let searchOption = TimetableWeekOptions.list.first(where: { $0.name == option.name })!
        let item = originalOptions.first { $0.title == searchOption.name }!
        return item
    }
}
