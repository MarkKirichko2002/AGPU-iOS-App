//
//  TimeTableWeekListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 06.08.2023.
//

import UIKit
import AVFoundation
import Combine

protocol TimeTableWeekListTableViewControllerDelegate: AnyObject {
    func checkWeek(week: WeekModel)
}

final class TimeTableWeekListTableViewController: UIViewController {
    
    var id: String = ""
    var currentWeekId: Int = 0
    var subgroup: Int = 0
    var owner: String = ""
    var week: WeekModel!
    var weeks: [WeekModel]
    var timetable: [TimeTable] = [] {
        didSet {
            timetable = timetable.map { day in
                var modifiedDay = day
                modifiedDay.disciplines = self.timetablePseudonymManager.setUpTimetablePseudonyms(pairs: &modifiedDay.disciplines)
                modifiedDay.disciplines = modifiedDay.disciplines.sorted { dateManager.compareTimes(time1: "\($0.time.components(separatedBy: "-")[0]):00", time2: "\($1.time.components(separatedBy: "-")[0]):00") == .orderedAscending}
                return modifiedDay
            }
        }
    }
    var allTimetable = [TimeTable]()
    weak var delegate: TimeTableWeekListTableViewControllerDelegate?
    var currentDate = ""
    var type = PairType.all
    var typesDict: [String: PairType] = [:]
    var buildingsDict: [String: AGPUBuildingModel] = [:]
    var timesDict: [String: String] = [:]
    var cancellables = Set<AnyCancellable>()
    var currentBuilding: AGPUBuildingModel?
    var image = UIImage()
    var captureSession: AVCaptureSession!
    var currentGesture: handGestures?
    var timer: Timer?
    var currentCamera = cameraMode.back
    var currentCameraState = cameraState.off
    var currentCameraPosition: AVCaptureDevice.Position = .back
    var buttonSettingsManager: ButtonSettingsManager?
    
    // MARK: - сервисы
    let service = TimeTableService()
    let dateManager = DateManager()
    let realmManager = RealmManager()
    let animation = AnimationClass()
    let speechRecognitionManager = SpeechRecognitionManager()
    let settingsManager = SettingsManager()
    let imageSaver = ImageSaver()
    let gestureRecognitionManager = GestureRecognitionManager()
    let visionManager = VisionManager()
    let timetablePseudonymManager = PseudonymManager()
    let timetableMenuManager = TimetableMenuManager()
    
    // MARK: - флаги
    var isChanged = false
    var isRecordingVideo = false
    
    // MARK: - UI
    let tableView = UITableView()
    
    private let spinner: SpringImageView = {
        let imageView = SpringImageView()
        imageView.image = UIImage(named: "clock")
        imageView.tintColor = .label
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let noTimeTableLabel = UILabel()
    
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Init
    init(id: String, subgroup: Int, currentWeek: WeekModel, weeks: [WeekModel], owner: String) {
        self.id = id
        self.subgroup = subgroup
        self.week = currentWeek
        self.currentWeekId = week.id
        self.weeks = weeks
        self.owner = owner
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        setUpLabel()
        createFloatingButton()
        setUpIndicatorView()
        setUpRefreshControl()
        getTimeTable {}
        SpeechSynthesizerManager.shared.registerSpeechFinishedHandler {
            self.resetSpeechRecognition()
        }
        imageSaver.registerImageHandler { title, message in
            self.showAlert(title: title, message: message, actions: [UIAlertAction(title: "ОК", style: .default)])
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkVoiceCommandsOption()
        checkRecognitionOption()
        checkDeviceOrientationControl()
        checkVolumeControl()
        buttonSettingsManager?.checkTimer()
        isChanged = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cancelSpeechRecognition()
        cancelRecognitionOption()
        removeDeviceOrientationObserve()
        removeVolumeObserve()
        buttonSettingsManager?.stopTimer()
    }
    
    private func setUpNavigation() {
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .plain, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .label
        let options = UIBarButtonItem(image: UIImage(named: "sections"), menu: setUpTimetableMenu())
        options.accessibilityIdentifier = "menu"
        options.tintColor = .label
        updateTitle()
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItem = options
        setUpNavigationGestures()
    }
    
    private func setUpNavigationGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(openMenuSettings))
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(showPastWeek))
        swipeLeft.direction = .left
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(showNextWeek))
        swipeRight.direction = .right
        navigationController?.navigationBar.addGestureRecognizer(tap)
        navigationController?.navigationBar.addGestureRecognizer(swipeLeft)
        navigationController?.navigationBar.addGestureRecognizer(swipeRight)
    }
    
    @objc private func openMenuSettings(gesture: UIGestureRecognizer) {
        let vc = ScreenMenuOptionsListTableViewController(screen: .timetableWeek)
        vc.delegate = self
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
        HapticsManager.shared.hapticFeedback()
    }
    
    @objc private func showPastWeek() {
        pastWeek {
            AudioPlayerClass.shared.playSound(sound: "paper", isPlaying: false)
            HapticsManager.shared.hapticFeedback()
        }
    }
    
    @objc private func showNextWeek() {
        nextWeek {
            AudioPlayerClass.shared.playSound(sound: "paper", isPlaying: false)
            HapticsManager.shared.hapticFeedback()
        }
    }
    
    func getAllPairs()-> [Discipline] {
        let currentDay = allTimetable.first { $0.date == currentDate }!
        return currentDay.disciplines
    }
    
    private func makeSimpleMenu()-> UIMenu {
        
        let searchAction = UIAction(title: "Поиск") { _ in
            let vc = TimeTableSearchListTableViewController()
            vc.isSettings = false
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
        
        // способы навигации
        let navigationsList = UIAction(title: "Навигация") { _ in
            let vc = NavigationsListTableViewController(screen: .timetableWeek)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        // поделиться
        let share = UIAction(title: "Поделиться") { _ in
            self.shareTimetable()
        }
        
        return UIMenu(title: "Расписание", children: [
            searchAction,
            days,
            navigationsList,
            share
        ])
    }
    
    @objc private func closeScreen() {
        speechRecognitionManager.cancelSpeechRecognition()
        HapticsManager.shared.hapticFeedback()
        delegate?.checkWeek(week: week)
        dismiss(animated: true)
    }
    
    func createImage(completion: @escaping()->Void) {
        do {
            let json = try JSONEncoder().encode(self.timetable)
            self.service.getTimeTableWeekImage(json: json) { image in
                self.image = image
                HapticsManager.shared.hapticFeedback()
                DispatchQueue.main.async {
                    completion()
                }
            }
        } catch {
            print(error)
        }
    }
    
    private func setUpTable() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: TimeTableTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TimeTableTableViewCell.identifier)
        tableView.separatorStyle = .none
    }
    
    private func setUpLabel() {
        view.addSubview(noTimeTableLabel)
        noTimeTableLabel.text = "Нет расписания"
        noTimeTableLabel.font = .systemFont(ofSize: 18, weight: .medium)
        noTimeTableLabel.isHidden = true
        noTimeTableLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noTimeTableLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noTimeTableLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setUpIndicatorView() {
        view.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        self.spinner.isHidden = false
        self.animation.startRotateAnimation(view: self.spinner)
    }
    
    private func setUpRefreshControl() {
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    @objc private func refresh() {
        refreshTimetable {}
    }
    
    @objc func refreshTimetable(completion: @escaping()->Void) {
        self.type = .all
        self.currentBuilding = nil
        self.subgroup = 0
        getTimeTable {
            completion()
        }
    }
    
    func createFloatingButton() {
        if settingsManager.loadASPUButtonScreens().contains(ASPUButtonScreens.timetableWeek) {
            setUpFloatingButton()
        }
    }
    
    private func setUpFloatingButton() {
        let navigationButton = UIButton()
        navigationButton.tintColor = .label
        navigationButton.setImage(UIImage(named: "aspu logo"), for: .normal)
        navigationButton.accessibilityIdentifier = "floating button"
        navigationButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationButton)
        NSLayoutConstraint.activate([
            navigationButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40.0),
            navigationButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30.0),
            navigationButton.widthAnchor.constraint(equalToConstant: 70.0),
            navigationButton.heightAnchor.constraint(equalToConstant: 70.0)
        ])
        navigationButton.addTarget(self, action: #selector(toggleNavigation), for: .touchUpInside)
    }
    
    @objc private func toggleNavigation(sender: UIButton) {
        if sender.imageView?.image == UIImage(named: "aspu logo") {
            sender.setImage(UIImage(named: "cross icon"), for: .normal)
            sender.tintColor = .systemRed
            animation.springAnimation(view: sender)
            setUpWeeksNavigation()
        } else if sender.imageView?.image == UIImage(named: "cross icon") {
            sender.setImage(UIImage(named: "aspu logo"), for: .normal)
            animation.springAnimation(view: sender)
            setUpNavigation()
        }
        HapticsManager.shared.hapticFeedback()
    }
    
    private func setUpWeeksNavigation() {
        let past = UIBarButtonItem(image: UIImage(named: "backward"), style: .plain, target: self, action: #selector(pastWeekTapped))
        past.accessibilityIdentifier = "past"
        past.tintColor = .label
        let next = UIBarButtonItem(image: UIImage(named: "forward"), style: .plain, target: self, action: #selector(nextWeekTapped))
        next.accessibilityIdentifier = "next"
        next.tintColor = .label
        navigationItem.leftBarButtonItem = past
        navigationItem.rightBarButtonItem = next
    }
    
    @objc func pastWeekTapped() {
        pastWeek {}
    }
    
    @objc func nextWeekTapped() {
        nextWeek {}
    }
    
    func toggleButtons(on: Bool) {
        guard let leftItems = navigationItem.leftBarButtonItems else {return}
        guard let rightItems = navigationItem.rightBarButtonItems else {return}
        if leftItems.contains(where: { $0.accessibilityIdentifier == "past" }) {
            let past = leftItems.first(where: { $0.accessibilityIdentifier == "past" })!
            past.isEnabled = on
        }
        if rightItems.contains(where: { $0.accessibilityIdentifier == "next" }) {
            let next = rightItems.first(where: { $0.accessibilityIdentifier == "next" })!
            next.isEnabled = on
        }
    }
    
    func getTimeTable(completion: @escaping()->Void) {
        let option = settingsManager.checkSaveRecentTimetableItem()
        if option == true {
            UserDefaults.standard.setValue(id, forKey: "recentGroup")
            UserDefaults.standard.setValue(currentDate, forKey: "recentDate")
            UserDefaults.standard.setValue(owner, forKey: "recentOwner")
            UserDefaults.standard.setValue(id, forKey: "group")
        }
        spinner.isHidden = false
        animation.startRotateAnimation(view: self.spinner)
        noTimeTableLabel.isHidden = true
        timetable = []
        navigationItem.toggleMenuButton(on: false)
        refreshTable()
        service.getTimeTableWeek(id: id, startDate: week.from, endDate: week.to, owner: owner) { [weak self] result in
            switch result {
            case .success(let timetable):
                var arr = [TimeTable]()
                if !timetable.isEmpty {
                    for timetable in timetable {
                        let data = timetable.disciplines.filter { $0.subgroup == self?.subgroup || $0.subgroup == 0 || (self?.subgroup == 0 && ($0.subgroup == 1 || $0.subgroup == 2)) }
                        let timeTable = TimeTable(id: self?.id ?? "ВМ-ИВТ-4-1", date: timetable.date, disciplines: data)
                        if !timetable.disciplines.isEmpty {
                            arr.append(timeTable)
                        }
                    }
                    DispatchQueue.main.async {
                        self?.timetable = arr
                        self?.allTimetable = arr
                        self?.tableView.reloadData()
                        self?.spinner.isHidden = true
                        self?.animation.stopRotateAnimation(view: self!.spinner)
                        self?.refreshControl.endRefreshing()
                        self?.noTimeTableLabel.isHidden = true
                        if !(self?.timetable.isEmpty ?? false) {
                            self?.scrollToCurrentDay()
                        }
                        self?.navigationItem.toggleMenuButton(on: true)
                        self?.setUpDict()
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.noTimeTableLabel.isHidden = false
                        self?.spinner.isHidden = true
                        self?.animation.stopRotateAnimation(view: self!.spinner)
                        self?.navigationItem.toggleMenuButton(on: true)
                        self?.refreshControl.endRefreshing()
                    }
                }
                self?.toggleButtons(on: true)
                completion()
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.spinner.isHidden = true
                    self?.animation.stopRotateAnimation(view: self!.spinner)
                    self?.noTimeTableLabel.text = "Нет расписания"
                    self?.noTimeTableLabel.isHidden = false
                    self?.navigationItem.toggleMenuButton(on: true)
                    self?.refreshControl.endRefreshing()
                    self?.toggleButtons(on: true)
                    print(error.localizedDescription)
                    completion()
                }
            }
        }
    }
    
    private func checkDeviceOrientationControl() {
        let screens = settingsManager.loadScreens(way: .deviceOrientation)
        if screens.contains(appScreens.timetableWeek) {
            NotificationCenter.default.addObserver(self, selector: #selector(checkDeviceOrientation), name: UIDevice.orientationDidChangeNotification, object: nil)
        }
    }
    
    @objc private func checkDeviceOrientation() {
        let orientation = UIDevice.current.orientation
        switch orientation {
        case .unknown:
            break
        case .portrait:
            break
        case .portraitUpsideDown:
            break
        case .landscapeLeft:
            closeAlert()
            showActionAlert(
                title: "Расписание на прошлую неделю (\(pastWeek(week: week).id))", message: "показать расписание?",
                action: {
                    self.pastWeek {}
                }
            )
        case .landscapeRight:
            closeAlert()
            showActionAlert(
                title: "Расписание на следующую неделю (\(nextWeek(week: week).id))",
                message: "показать расписание?",
                action: {
                    self.nextWeek {}
                }
            )
        case .faceUp:
            break
        case .faceDown:
            closeAlert()
            showActionAlert(
                title: "Расписание на эту неделю (\(currentWeek(week: week).id))",
                message: "показать расписание?",
                action: {
                    self.currentWeek {}
                }
            )
        @unknown default:
            break
        }
    }
    
    func removeDeviceOrientationObserve() {
        let screens = settingsManager.loadScreens(way: .deviceOrientation)
        if screens.contains(appScreens.timetableWeek) {
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    func checkVolumeControl() {
        let screens = settingsManager.loadScreens(way: .volume)
        if screens.contains(appScreens.timetableWeek) {
            AVAudioSession.sharedInstance().publisher(for: \.outputVolume)
                .removeDuplicates()
                .filter({ _ in self.isMicOn() || !self.isRecording()})
                .sink { volume in
                    self.checkVolume(volume: volume)
                }
                .store(in: &cancellables)
        }
    }
    
    func checkVolume(volume: Float) {
        if !self.isChanged {
            self.isChanged = true
        } else {
            self.checkVolumeLevel(volume: volume)
        }
    }
    
    @objc private func checkVolumeLevel(volume: Float) {
        switch volume {
        case 0.0:
            closeAlert()
            showActionAlert(
                title: "Расписание на прошлую неделю (\(pastWeek(week: week).id))", message: "показать расписание?",
                action: {
                    self.pastWeek {}
                }
            )
        case 0.5:
            closeAlert()
            showActionAlert(
                title: "Расписание на эту неделю (\(currentWeek(week: week).id))",
                message: "показать расписание?",
                action: {
                    self.currentWeek {}
                }
            )
        case 1.0:
            closeAlert()
            showActionAlert(
                title: "Расписание на следующую неделю (\(nextWeek(week: week).id))",
                message: "показать расписание?",
                action: {
                    self.nextWeek {}
                }
            )
        default:
            break
        }
    }
    
    func removeVolumeObserve() {
        let screens = settingsManager.loadScreens(way: .volume)
        if screens.contains(appScreens.timetableWeek) {
            cancellables.removeAll()
        }
    }
    
    @objc func shareTimetable() {
        let emptyTimetable = [TimeTable(id: id, date: week.from, disciplines: [])]
        if !self.timetable.isEmpty {
            do {
                let json = try JSONEncoder().encode(timetable)
                service.getTimeTableWeekImage(json: json) { image in
                    self.ShareImage(image: image, title: self.id, text: "с \(self.week.from) по \(self.week.to)")
                    HapticsManager.shared.hapticFeedback()
                }
            } catch {
                print(error.localizedDescription)
            }
        } else {
            do {
                let json = try JSONEncoder().encode(emptyTimetable)
                service.getTimeTableWeekImage(json: json) { image in
                    self.ShareImage(image: image, title: self.id, text: "с \(self.week.from) по \(self.week.to)")
                    HapticsManager.shared.hapticFeedback()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func scrollToCurrentDay() {
        let currentDate = dateManager.getCurrentDate()
        timetable.enumerated().forEach { (index: Int, timetable: TimeTable) in
            if timetable.date == currentDate {
                tableView.isUserInteractionEnabled = false
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                    DispatchQueue.main.async {
                        let indexPath = IndexPath(row: 0, section: index)
                        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                        self.currentDate = timetable.date
                    }
                }
            } else {
                self.currentDate = week.from
            }
        }
    }
    
    func scrollToSection(isTimer: Bool) {
        if let index = timetable.firstIndex(where: { $0.date == currentDate }) {
            if isTimer {
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                    self.tableView.scrollToRow(at: IndexPath(row: 0, section: index), at: .top, animated: true)
                }
            } else {
                tableView.scrollToRow(at: IndexPath(row: 0, section: index), at: .top, animated: true)
            }
        }
    }
    
    func showSaveImageAlert() {
        let saveAction = UIAlertAction(title: "Сохранить в фото", style: .default) { _ in
            do {
                let json = try JSONEncoder().encode(self.timetable)
                self.service.getTimeTableWeekImage(json: json) { image in
                    self.imageSaver.writeToPhotoAlbum(image: image)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
        let saveAction2 = UIAlertAction(title: "Сохранить в изображения", style: .default) { _ in
            do {
                let json = try JSONEncoder().encode(self.timetable)
                self.service.getTimeTableWeekImage(json: json) { image in
                    if let imageData = image.jpegData(compressionQuality: 1.0) {
                        let model = ImageModel()
                        model.date = self.dateManager.getCurrentDate()
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
    
    func filterPairs(type: PairType) {
        
        typesDict[currentDate] = type
        buildingsDict[currentDate] = nil
        timesDict[currentDate] = nil
        
        if type == .all {
            
            let index = allTimetable.firstIndex { $0.date == currentDate }!
            
            if allTimetable.isEmpty {
                allTimetable = timetable
            }
            
            if !timetable.contains(where: { $0.date == allTimetable[index].date }) {
                if timetable.count < index {
                    timetable.append(allTimetable[index])
                } else {
                    timetable.insert(allTimetable[index], at: index)
                }
            } else {
                timetable.remove(at: index)
                timetable.append(allTimetable[index])
            }
            timetable = timetable.sorted { dateManager.compareDates(date1: $0.date, date2: $1.date) == .orderedAscending }
            timetable = timetable.filter { !$0.disciplines.isEmpty}
            subgroup = 0
            refreshTable()
            
        } else if type == .leftToday {
            
            let filteredTimetable = filterLeftedPairs()
            
            if filteredTimetable.isEmpty {
                self.subgroup = 0
            }
            timetable = filteredTimetable
            
            if filteredTimetable.first?.disciplines.first?.type == .lab {
                subgroup = 0
            } else {
                subgroup = filteredTimetable.first?.disciplines.first?.subgroup ?? 0
            }
            
            refreshTable()
            
        } else {
            
            if allTimetable.isEmpty {
                allTimetable = timetable
            }
            
            let filteredTimetable = filterTimetable()
            if filteredTimetable.isEmpty {
                subgroup = 0
            }
            timetable = filteredTimetable
            
            if filteredTimetable.first?.disciplines.first?.type == .lab {
                subgroup = 0
            } else {
                subgroup = filteredTimetable.first?.disciplines.first?.subgroup ?? 0
            }
            
            refreshTable()
        }
        
        if timetable.isEmpty {
            noTimeTableLabel.text = "Нет пар"
            noTimeTableLabel.isHidden = false
        } else {
            scrollToSection(isTimer: true)
            noTimeTableLabel.isHidden = true
        }
    }
    
    func checkRecognitionOption() {
        let gestureScreens = settingsManager.loadScreens(way: .gestureRecognition)
        let headPoseScreens = settingsManager.loadScreens(way: .headTurns)
        if !gestureScreens.isEmpty {
            checkGestureOption(screens: gestureScreens)
        }
        if !headPoseScreens.isEmpty {
            checkHeadPoseOption(screens: headPoseScreens)
        }
    }
    
    func checkGestureOption(screens: [appScreens]) {
        let isContains = screens.contains(appScreens.timetableWeek)
        isRecordingVideo = isContains
        if isContains {
            makeCameraButton()
            observeGestureRecognition()
            setUpCaptureSession()
        }
    }
    
    func checkHeadPoseOption(screens: [appScreens]) {
        let isContains = screens.contains(appScreens.timetableWeek)
        isRecordingVideo = isContains
        if isContains {
            makeCameraButton()
            observeHeadPoseRecognition()
            setUpCaptureSession()
        }
    }
    
    private func makeCameraButton() {
        if !view.subviews.contains(where: { $0.accessibilityIdentifier == "camera button" }) {
            setUpCameraButton()
        }
    }
    
    func updateCameraButtonMenu() {
        if let button = view.subviews.first(where: { $0.accessibilityIdentifier == "camera button" }) {
            DispatchQueue.main.async {
                (button as? UIButton)?.menu = self.setUpCameraMenu()
            }
        }
    }
    
    func setUpCameraButton() {
        let icon = UIButton()
        icon.accessibilityIdentifier = "camera button"
        icon.tintColor = .darkGray
        icon.setImage(UIImage(named: "camera"), for: .normal)
        icon.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(icon)
        NSLayoutConstraint.activate([
            icon.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40.0),
            icon.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30.0),
            icon.widthAnchor.constraint(equalToConstant: 60.0),
            icon.heightAnchor.constraint(equalToConstant: 60.0)
        ])
        icon.showsMenuAsPrimaryAction = true
        icon.menu = setUpCameraMenu()
    }
    
    private func setUpCameraMenu()-> UIMenu {
        let state = UIMenu(title: "Состояние", children: cameraState.allCases.map({ value in UIAction(title: value.rawValue, state: value == currentCameraState ? .on : .off) { _ in
            self.currentCameraState = value
            self.onOffCamera()
            self.updateCameraButtonMenu()
        }}).reversed())
        let modes = UIMenu(title: "Камера", children: cameraMode.allCases.map({ value in UIAction(title: value.rawValue, state: value == currentCamera ? .on : .off) { _ in
            self.currentCamera = value
            self.switchCamera()
            self.updateCameraButtonMenu()
        }}).reversed())
        let actions = [modes, state]
        let camera = [state]
        return UIMenu(title: "Распознавание жестов", children: currentCameraState == .on ? actions : camera)
    }
    
    @objc func onOffCamera() {
        switch currentCameraState {
        case .on:
            isRecordingVideo = true
            if !captureSession.isRunning {
                startSession()
            }
        case .off:
            isRecordingVideo = false
            if captureSession.isRunning {
                cancelRecognitionOption()
            }
        }
    }
    
    @objc func switchCamera() {
        
        cancelRecognitionOption()
        
        currentCameraPosition = (currentCameraPosition == .back) ? .front : .back
        
        if let currentInput = captureSession.inputs.first {
            captureSession.removeInput(currentInput)
        }
        
        setUpCaptureSession()
    }
    
    func observeGestureRecognition() {
        gestureRecognitionManager.registerHandGestureHandler { gesture in
            DispatchQueue.main.async {
                self.currentGesture = gesture
                self.closeCameraButtonMenu()
                self.cancelRecognitionOption()
                self.makeDateAlertForWeek(gesture: gesture)
            }
        }
    }
    
    func observeHeadPoseRecognition() {
        visionManager.registerHandPoseHandler { pose in
            DispatchQueue.main.async {
                self.closeCameraButtonMenu()
                self.cancelRecognitionOption()
                self.getTimetable(pose: pose)
            }
        }
    }
    
    private func setUpButtonSettings() {
        self.buttonSettingsManager = ButtonSettingsManager(screen: .timetableWeek, view: self.view)
    }
    
    func filterTimetable()-> [TimeTable] {
        var timetables = timetable
        var allDays = allTimetable
        let type = typesDict[currentDate]
        if timetables.contains(where: { $0.date == currentDate }) {
            if let index = timetables.firstIndex(where: { $0.date == currentDate }) {
                timetables[index].disciplines = allDays[index].disciplines.filter({ $0.type == type })
                timetables = timetables.filter { !$0.disciplines.isEmpty }
            }
        } else {
            if let index = allDays.firstIndex(where: { $0.date == currentDate }) {
                allDays[index].disciplines = allDays[index].disciplines.filter({ $0.type == type })
                if timetables.count < index {
                    timetables.append(allDays[index])
                } else {
                    timetables.insert(allDays[index], at: index)
                }
                timetables = timetables.sorted { dateManager.compareDates(date1: $0.date, date2: $1.date) == .orderedAscending }
                timetables = timetables.filter { !$0.disciplines.isEmpty }
            }
        }
        return timetables
    }
    
    private func filterLeftedPairs()-> [TimeTable] {
        
        var timetables = timetable
        var allDays = allTimetable
        
        let currentDate = dateManager.getCurrentDate()
        let currentTime = dateManager.getCurrentTime(isFullFormat: true)
        var pairs = [Discipline]()
        
        if timetable.contains(where: { $0.date == self.currentDate }) {
            
            let day = timetables.first { $0.date == self.currentDate }!
            let index = timetables.firstIndex { $0.date == self.currentDate }!
            
            for pair in day.disciplines {
                
                let pairEndTime = "\(pair.time.components(separatedBy: "-")[1]):00"
                
                let timetableDate = self.currentDate
                
                let compareDate = dateManager.compareDates(date1: timetableDate, date2: currentDate)
                let compareTime = dateManager.compareTimes(time1: pairEndTime, time2: currentTime)
                
                // прошлый день
                if compareDate == .orderedAscending {
                    let index = timetables.firstIndex { $0.date == self.currentDate } ?? 0
                    timetables[index].disciplines = []
                    break
                }
                
                // время больше и тот же день
                if compareTime == .orderedDescending && compareDate == .orderedSame {
                    pairs.append(pair)
                }
                
                // следующий день
                if compareDate == .orderedDescending {
                    return timetables
                }
            }
            
            if !pairs.isEmpty {
                timetables[index].disciplines = pairs
            } else {
                timetables[index].disciplines = []
            }
        } else {
            if let index = allDays.firstIndex(where: { $0.date == currentDate }) {
                allDays[index].disciplines = []
                if timetables.count < index {
                    timetables.append(allDays[index])
                } else {
                    timetables.insert(allDays[index], at: index)
                }
                timetables = timetables.sorted { dateManager.compareDates(date1: $0.date, date2: $1.date) == .orderedAscending }
                timetables = timetables.filter { !$0.disciplines.isEmpty }
            }
        }
        
        return timetables.filter { !$0.disciplines.isEmpty }
    }
    
    private func setUpDict() {
        for day in timetable {
            typesDict[day.date] = PairType.all
            timesDict[day.date] = nil
            buildingsDict[day.date] = nil
        }
    }
    
    func refreshTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
