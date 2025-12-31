//
//  TimeTableDayListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 12.07.2023.
//

import UIKit
import AVFoundation
import Combine

enum MenuState {
    case opened
    case closed
}

protocol TimeTableDayListTableViewControllerDelegate: AnyObject {
    func didSwipeLeftEdge()
    func didSwipeRightEdge()
    func weekWasChanged(week: WeekModel)
}

final class TimeTableDayListTableViewController: UIViewController {
    
    var id = ""
    var timer: Timer?
    var subgroup = 0
    var date = ""
    var owner = ""
    var weeks = [WeekModel]()
    var dayType = DayType.week
    var currentWeek = WeekModel(id: 0, from: "", to: "", dayNames: ["" : ""]) {
        didSet {
            delegate?.weekWasChanged(week: currentWeek)
        }
    }
    var dates = [String]()
    var intervals = [String]()
    var allDisciplines: [Discipline] = []
    var type: PairType = .all
    var currentPairName = ""
    var currentBuilding: AGPUBuildingModel?
    var currentTime: String?
    var currentNavigationType = DateNavigationTypes.day
    
    var timetable = TimeTable(id: "", date: "", disciplines: []) {
        didSet {
            timetable.disciplines = timetablePseudonymManager.setUpTimetablePseudonyms(pairs: &timetable.disciplines)
            DispatchQueue.main.async {
                self.navigationItem.title = self.timetablePseudonymManager.setUpDayOfWeekPseudonym(date: self.date)
            }
        }
    }
    var image = UIImage()
    var cancellables = Set<AnyCancellable>()
    var currentGesture: handGestures?
    var currentCamera = cameraMode.back
    var currentCameraState = cameraState.off
    var currentCameraPosition: AVCaptureDevice.Position = .back
    var captureSession: AVCaptureSession!
    var buttonSettingsManager: ButtonSettingsManager?
    
    private var menuState: MenuState = .closed
    
    weak var delegate: TimeTableDayListTableViewControllerDelegate?
    
    // MARK: - сервисы
    let service = TimeTableService()
    let dateManager = DateManager()
    let realmManager = RealmManager()
    let settingsManager = SettingsManager()
    let animation = AnimationClass()
    let speechRecognitionManager = SpeechRecognitionManager()
    let imageSaver = ImageSaver()
    let gestureRecognitionManager = GestureRecognitionManager()
    let timetablePseudonymManager = TimetablePseudonymManager()
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
    
    let infoLabel = UILabel()
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
        setUpNavigation()
        setUpTable()
        setUpRefreshControl()
        setUpIndicatorView()
        setUpLabel()
        setUpSideMenu()
        getTimeTable(id: id, date: date, owner: owner) {}
        setUpCurrentWeek()
        createFloatingButton()
        observeGroupChange()
        observeSubGroupChange()
        observeObjectSelected()
        observePairType()
        observeAdvancedMode()
        observeFloatingButton()
        observeTimetableOptionsChanges()
        setUpButtonSettings()
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
        checkGestureOption()
        checkDeviceOrientationControl()
        checkVolumeControl()
        buttonSettingsManager?.checkTimer()
        isChanged = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cancelRecognition()
        cancelGestureRecognition()
        removeDeviceOrientationObserve()
        removeVolumeObserve()
        buttonSettingsManager?.stopTimer()
    }
    
    private func setUpData() {
        id = UserDefaults.standard.string(forKey: "group") ?? "ВМ-ИВТ-4-1"
        subgroup = UserDefaults.standard.object(forKey: "subgroup") as? Int ?? 0
        type = UserDefaults.loadData(type: PairType.self, key: "type") ?? .all
        date = dateManager.getCurrentDate()
        owner = UserDefaults.standard.string(forKey: "recentOwner") ?? "GROUP"
    }
    
    private func setUpNavigation() {
        let options = UIBarButtonItem(image: UIImage(named: "sections"), menu: setUpTimetableMenu())
        options.accessibilityIdentifier = "menu"
        options.tintColor = .label
        
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(named: "refresh"), for: .normal)
        button.addTarget(self, action: #selector(refresh), for: .touchUpInside)
        button.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(getCurrentDay)))
        let refreshButton = UIBarButtonItem(customView: button)
        refreshButton.accessibilityIdentifier = "refresh button"
        refreshButton.tintColor = .label
        
        navigationItem.leftBarButtonItem = refreshButton
        navigationItem.rightBarButtonItem = options
        setUpNavigationGestures()
    }
    
    private func setUpNavigationGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(openMenuSettings))
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(showPastDay))
        swipeLeft.direction = .left
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(showNextDay))
        swipeRight.direction = .right
        navigationController?.navigationBar.addGestureRecognizer(tap)
        navigationController?.navigationBar.addGestureRecognizer(swipeLeft)
        navigationController?.navigationBar.addGestureRecognizer(swipeRight)
    }
    
    @objc private func openMenuSettings(gesture: UIGestureRecognizer) {
        let vc = ScreenMenuOptionsListTableViewController(screen: .timetableDay)
        vc.delegate = self
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
        HapticsManager.shared.hapticFeedback()
    }
    
    @objc private func showPastDay() {
        pastDay {
            AudioPlayerClass.shared.playSound(sound: "paper", isPlaying: false)
            HapticsManager.shared.hapticFeedback()
        }
    }
    
    @objc private func showNextDay() {
        nextDay {
            AudioPlayerClass.shared.playSound(sound: "paper", isPlaying: false)
            HapticsManager.shared.hapticFeedback()
        }
    }
    
    @objc private func refresh() {
        refreshTimetable {}
    }
    
    @objc private func getCurrentDay(gesture: UIGestureRecognizer) {
        if gesture.state == .ended {
            currentDay {}
        }
    }
    
    @objc func refreshTimetable(completion: @escaping()->Void) {
        self.type = .all
        self.currentBuilding = nil
        self.currentTime = nil
        self.subgroup = 0
        getTimeTable(id: id, date: date, owner: owner) {
            completion()
        }
    }
    
    func createImage(completion: @escaping()->Void) {
        do {
            let json = try JSONEncoder().encode(self.timetable)
            self.service.getTimeTableDayImage(json: json) { image in
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
    
    private func setUpIndicatorView() {
        view.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        self.spinner.isHidden = false
        self.animation.startRotateAnimation(view: self.spinner)
    }
    
    private func setUpTable() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: TimeTableTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TimeTableTableViewCell.identifier)
        tableView.separatorStyle = .none
    }
    
    private func setUpRefreshControl() {
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    private func setUpLabel() {
        view.addSubview(infoLabel)
        infoLabel.text = "Нет расписания"
        infoLabel.font = .systemFont(ofSize: 18, weight: .medium)
        infoLabel.isHidden = true
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setUpSideMenu() {
        let swipeEdgeLeft = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        swipeEdgeLeft.edges = .left
        let swipeEdgeRight = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        swipeEdgeRight.edges = .right
        view.addGestureRecognizer(swipeEdgeLeft)
        view.addGestureRecognizer(swipeEdgeRight)
    }
    
    @objc func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .recognized {
            switch recognizer.edges {
            case .left:
                delegate?.didSwipeLeftEdge()
            case .right:
                delegate?.didSwipeRightEdge()
            default:
                break
            }
        }
    }
    
    private func resetFloatingButton() {
        if let button = view.subviews.first(where: { $0.accessibilityIdentifier == "floating button" }) {
            button.removeFromSuperview()
            createFloatingButton()
        } else {
            createFloatingButton()
        }
    }
    
    func createFloatingButton() {
        if settingsManager.loadASPUButtonScreens().contains(ASPUButtonScreens.timetableDay) {
            setUpFloatingButton()
        }
    }
    
    private func setUpFloatingButton() {
        let interaction = UIContextMenuInteraction(delegate: self)
        let navigationButton = UIButton()
        navigationButton.tintColor = .label
        navigationButton.setImage(UIImage(named: "aspu logo"), for: .normal)
        navigationButton.accessibilityIdentifier = "floating button"
        navigationButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationButton)
        NSLayoutConstraint.activate([
            navigationButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -tabBarController!.tabBar.frame.height-17),
            navigationButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30.0),
            navigationButton.widthAnchor.constraint(equalToConstant: 70.0),
            navigationButton.heightAnchor.constraint(equalToConstant: 70.0)
        ])
        navigationButton.addInteraction(interaction)
        navigationButton.addTarget(self, action: #selector(toggleNavigation), for: .touchUpInside)
    }
    
    @objc private func toggleNavigation(sender: UIButton) {
        if sender.imageView?.image == UIImage(named: "aspu logo") {
            sender.setImage(UIImage(named: "cross icon"), for: .normal)
            sender.tintColor = .systemRed
            animation.springAnimation(view: sender)
            setUpDaysNavigation()
        } else if sender.imageView?.image == UIImage(named: "cross icon") {
            sender.setImage(UIImage(named: "aspu logo"), for: .normal)
            animation.springAnimation(view: sender)
            setUpNavigation()
        }
        HapticsManager.shared.hapticFeedback()
    }
    
    private func setUpDaysNavigation() {
        
        let past = UIBarButtonItem(image: UIImage(named: "backward"), style: .plain, target: self, action: #selector(pastTapped))
        past.tintColor = .label
        
        let next = UIBarButtonItem(image: UIImage(named: "forward"), style: .plain, target: self, action: #selector(nextTapped))
        next.tintColor = .label
        
        navigationItem.leftBarButtonItem = past
        navigationItem.rightBarButtonItem = next
    }
    
    @objc private func pastTapped() {
        switch currentNavigationType {
        case .day:
            pastDay { }
        case .month:
            pastMonth { }
        case .year:
            pastYear { }
        }
    }
    
    @objc private func nextTapped() {
        switch currentNavigationType {
        case .day:
            nextDay { }
        case .month:
            nextMonth { }
        case .year:
            nextYear { }
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
            icon.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -tabBarController!.tabBar.frame.height-17),
            icon.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30.0),
            icon.widthAnchor.constraint(equalToConstant: 60.0),
            icon.heightAnchor.constraint(equalToConstant: 60.0)
        ])
        icon.showsMenuAsPrimaryAction = true
        icon.menu = setUpCameraMenu()
    }
    
    func removeCameraButton() {
        if let button = view.subviews.first(where: { $0.accessibilityIdentifier == "camera button" }) {
            button.removeFromSuperview()
        }
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
                cancelGestureRecognition()
            }
        }
    }
    
    @objc func switchCamera() {
        
        currentCameraPosition = (currentCameraPosition == .back) ? .front : .back
        
        cancelGestureRecognition()
        
        if let currentInput = captureSession.inputs.first {
            captureSession.removeInput(currentInput)
        }
        
        setUpCaptureSession()
    }
    
    func getTimeTable(id: String, date: String, owner: String, completion: @escaping()->Void) {
        let option = settingsManager.checkSaveRecentTimetableItem()
        if option == true {
            UserDefaults.standard.setValue(id, forKey: "recentGroup")
            UserDefaults.standard.setValue(date, forKey: "recentDate")
            UserDefaults.standard.setValue(owner, forKey: "recentOwner")
            UserDefaults.standard.setValue(id, forKey: "group")
        }
        self.spinner.isHidden = false
        self.animation.startRotateAnimation(view: self.spinner)
        self.infoLabel.isHidden = true
        self.timetable.disciplines = []
        self.date = date
        self.tableView.reloadData()
        self.navigationItem.toggleRefreshButtonFromLeft(on: false)
        self.navigationItem.toggleMenuButton(on: false)
        service.getTimeTableDay(id: id, date: date, owner: owner) { [weak self] result in
            switch result {
            case .success(let schedule):
                self?.timetable = schedule
                self?.allDisciplines = schedule.disciplines
                if !schedule.disciplines.isEmpty {
                    let data = schedule.disciplines.filter { $0.subgroup == self?.subgroup || $0.subgroup == 0 || (self?.subgroup == 0 && ($0.subgroup == 1 || $0.subgroup == 2)) }
                    if self?.type != .all {
                        if self?.type == .leftToday {
                            self?.timetable.disciplines = self?.filterLeftedPairs() ?? []
                        } else {
                            self?.timetable.disciplines = data.filter {$0.type == self?.type}
                        }
                    } else {
                        self?.timetable.disciplines = data
                    }
                    
                    if self?.timetable.disciplines.isEmpty ?? false {
                        DispatchQueue.main.async {
                            self?.infoLabel.text = "Нет пар"
                            self?.infoLabel.isHidden = false
                        }
                    } else {
                        DispatchQueue.main.async {
                            self?.infoLabel.isHidden = true
                        }
                    }
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                        self?.spinner.isHidden = true
                        self?.navigationItem.toggleRefreshButtonFromLeft(on: true)
                        self?.navigationItem.toggleMenuButton(on: true)
                        self?.animation.stopRotateAnimation(view: self!.spinner)
                        self?.refreshControl.endRefreshing()
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.spinner.isHidden = true
                        self?.navigationItem.toggleRefreshButtonFromLeft(on: true)
                        self?.navigationItem.toggleMenuButton(on: true)
                        self?.animation.stopRotateAnimation(view: self!.spinner)
                        self?.refreshControl.endRefreshing()
                        self?.infoLabel.isHidden = false
                    }
                }
                completion()
            case .failure(let error):
                self?.timetable = TimeTable(id: id, date: date, disciplines: [])
                DispatchQueue.main.async {
                    self?.spinner.isHidden = true
                    self?.navigationItem.toggleRefreshButtonFromLeft(on: true)
                    self?.navigationItem.toggleMenuButton(on: true)
                    self?.animation.stopRotateAnimation(view: self!.spinner)
                    self?.refreshControl.endRefreshing()
                    self?.infoLabel.text = "Нет расписания"
                    self?.infoLabel.isHidden = false
                }
                print(error.localizedDescription)
                completion()
            }
        }
    }
    
    func setUpTimeIntervals() {
        intervals = settingsManager.loadTimetableIntervals()
        filterPairs(by: intervals)
    }
    
    func setUpCurrentWeek() {
        getWeeks {
            self.getCurrentWeek()
        }
    }
    
    func getWeeks(completion: @escaping()->Void) {
        service.getWeeks { result in
            switch result {
            case .success(let data):
                self.weeks = data
                completion()
            case .failure(let error):
                print(error)
                completion()
            }
        }
    }
    
    func getCurrentWeek() {
        if !weeks.isEmpty {
            for week in weeks {
                if isCurrentWeek(index: week.id - 1) {
                    currentWeek = week
                    break
                }
            }
        }
    }
    
    func isCurrentWeek(index: Int)-> Bool {
        let week = weeks[index]
        let isRange = dateManager.dateRange(startDate: week.from, endDate: week.to)
        return isRange
    }
    
    private func observeGroupChange() {
        NotificationCenter.default.addObserver(forName: Notification.Name("group changed"), object: nil, queue: .main) { notification in
            let id = notification.object as? String ?? "ВМ-ИВТ-4-1"
            self.id = id
            self.owner = "GROUP"
            self.getTimeTable(id: self.id, date: self.date, owner: self.owner) {}
        }
    }
    
    private func observeSubGroupChange() {
        
        NotificationCenter.default.addObserver(forName: Notification.Name("subgroup changed"), object: nil, queue: .main) { notification in
            
            if let subgroup = notification.object as? Int {
                self.filterPairs(by: subgroup)
            }
        }
    }
    
    private func observeObjectSelected() {
        NotificationCenter.default.addObserver(forName: Notification.Name("object selected"), object: nil, queue: .main) { notification in
            if let object = notification.object as? SearchTimetableModel {
                self.getTimeTable(id: object.name, date: self.date, owner: object.owner) {}
                self.id = object.name
                self.owner = object.owner
                print(self.owner)
            }
        }
    }
    
    private func observePairType() {
        
        NotificationCenter.default.addObserver(forName: Notification.Name("TypeWasSelected"), object: nil, queue: .main) { [weak self] notification in
            
            guard let type = notification.object as? PairType, let self = self else { return }
            self.filterPairs(type: type)
        }
    }
    
    private func observeAdvancedMode() {
        NotificationCenter.default.addObserver(forName: Notification.Name("advanced mode"), object: nil, queue: .main) { _ in
            self.setUpNavigation()
        }
    }
    
    private func checkDeviceOrientationControl() {
        let screens = settingsManager.loadScreens(way: .deviceOrientation)
        if screens.contains(appScreens.timetableDay) {
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
                title: "Расписание на \(dateManager.previousDay(date: date))",
                message: "показать расписание?",
                action: {
                    self.pastDay { }
                }
            )
        case .landscapeRight:
            closeAlert()
            showActionAlert(
                title: "Расписание на \(dateManager.nextDay(date: date))",
                message: "показать расписание?",
                action: {
                    self.nextDay { }
                }
            )
        case .faceUp:
            break
        case .faceDown:
            closeAlert()
            showActionAlert(
                title: "Расписание на сегодня",
                message: "показать расписание?",
                action: {
                    self.currentDay {}
                }
            )
        @unknown default:
            break
        }
    }
    
    func removeDeviceOrientationObserve() {
        let screens = settingsManager.loadScreens(way: .deviceOrientation)
        if screens.contains(appScreens.timetableDay) {
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    func checkVolumeControl() {
        let screens = settingsManager.loadScreens(way: .volume)
        if screens.contains(appScreens.timetableDay) {
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
                title: "Расписание на \(dateManager.previousDay(date: date))",
                message: "показать расписание?",
                action: {
                    self.pastDay { }
                }
            )
        case 0.5:
            closeAlert()
            showActionAlert(
                title: "Расписание на сегодня",
                message: "показать расписание?",
                action: {
                    self.currentDay {}
                }
            )
        case 1.0:
            closeAlert()
            showActionAlert(
                title: "Расписание на \(dateManager.nextDay(date: date))",
                message: "показать расписание?",
                action: {
                    self.nextDay { }
                }
            )
        default:
            break
        }
    }
    
    func removeVolumeObserve() {
        let screens = settingsManager.loadScreens(way: .volume)
        if screens.contains(appScreens.timetableDay) {
            cancellables.removeAll()
        }
    }
    
    func observeFloatingButton() {
        NotificationCenter.default.addObserver(forName: Notification.Name("floating button timetable day"), object: nil, queue: .main) { _ in
            self.resetFloatingButton()
        }
    }
    
    func checkGestureOption() {
        let screens = settingsManager.loadScreens(way: differentWays.gestureRecognition)
        let isContains = screens.contains(appScreens.timetableDay)
        isRecordingVideo = isContains
        if isContains {
            makeCameraButton()
            observeGestureRecognition()
            setUpCaptureSession()
        } else {
            removeCameraButton()
        }
    }
    
    private func makeCameraButton() {
        if !view.subviews.contains(where: { $0.accessibilityIdentifier == "camera button" }) {
            setUpCameraButton()
        }
    }
    
    func observeTimetableOptionsChanges() {
        NotificationCenter.default.addObserver(forName: Notification.Name("timetable day options changed"), object: nil, queue: .main) { _ in
            self.updateMenu()
        }
    }
    
    func updateMenu() {
        guard let item = self.navigationItem.rightBarButtonItems?.first(where: { $0.accessibilityIdentifier == "menu" }) else {return}
        item.menu = setUpTimetableMenu()
    }
    
    func observeGestureRecognition() {
        gestureRecognitionManager.registerHandGestureHandler { gesture in
            DispatchQueue.main.async {
                self.currentGesture = gesture
                self.closeCameraButtonMenu()
                self.cancelGestureRecognition()
                self.getTimetable(gesture: gesture)
            }
        }
    }
    
    private func setUpButtonSettings() {
        self.buttonSettingsManager = ButtonSettingsManager(screen: .timetableDay, view: self.view)
    }
    
    func filterPairs(type: PairType) {
        
        self.currentBuilding = nil
        self.currentTime = nil
        self.type = type
        
        if type == .all {
            
            if self.allDisciplines.isEmpty {
                self.allDisciplines = timetable.disciplines
            }
            
            self.timetable.disciplines = self.allDisciplines
            self.subgroup = 0
            self.tableView.reloadData()
            
        } else if type == .leftToday {
            
            let filteredDisciplines = self.filterLeftedPairs()
            if filteredDisciplines.isEmpty {
                self.subgroup = 0
            }
            self.timetable.disciplines = filteredDisciplines
            
            if filteredDisciplines.first?.type == .lab {
                self.subgroup = 0
            } else {
                self.subgroup = filteredDisciplines.first?.subgroup ?? 0
            }
            
            self.tableView.reloadData()
            
        } else {
            
            if self.allDisciplines.isEmpty {
                self.allDisciplines = timetable.disciplines
            }
            
            let filteredDisciplines = self.allDisciplines.filter { $0.type == type }
            if filteredDisciplines.isEmpty {
                self.subgroup = 0
            }
            self.timetable.disciplines = filteredDisciplines
            
            if filteredDisciplines.first?.type == .lab {
                self.subgroup = 0
            } else {
                self.subgroup = filteredDisciplines.first?.subgroup ?? 0
            }
            
            self.tableView.reloadData()
        }
        
        if self.timetable.disciplines.isEmpty {
            self.infoLabel.text = "Нет пар"
            self.infoLabel.isHidden = false
        } else {
            self.infoLabel.isHidden = true
        }
    }
    
    func filterPairs(by building: AGPUBuildingModel) {
        self.currentBuilding = building
        self.currentTime = nil
        self.type = .all
        var disciplines = [Discipline]()
        guard let corp = currentBuilding else {return}
        for audience in corp.audiences {
            for pair in allDisciplines {
                if audience == pair.audienceID {
                    disciplines.append(pair)
                }
            }
        }
        DispatchQueue.main.async {
            self.timetable.disciplines = disciplines.sorted { self.dateManager.compareTimes(time1: "\($0.time.components(separatedBy: "-")[0]):00", time2: "\($1.time.components(separatedBy: "-")[0]):00") == .orderedAscending}
            self.tableView.reloadData()
            if self.timetable.disciplines.isEmpty {
                self.infoLabel.isHidden = false
            } else {
                self.infoLabel.isHidden = true
            }
        }
    }
    
    func filterPairs(by time: String) {
        self.currentTime = time
        self.currentBuilding = nil
        self.type = .all
        guard let filterTime = currentTime else {return}
        DispatchQueue.main.async {
            self.timetable.disciplines = self.allDisciplines.filter { $0.time == filterTime}
            self.tableView.reloadData()
            if self.timetable.disciplines.isEmpty {
                self.infoLabel.isHidden = false
            } else {
                self.infoLabel.isHidden = true
            }
        }
    }
    
    func filterPairs(name: String) {
        self.currentTime = nil
        self.currentBuilding = nil
        DispatchQueue.main.async {
            self.timetable.disciplines = self.allDisciplines.filter { $0.name == name}
            self.tableView.reloadData()
            if self.timetable.disciplines.isEmpty {
                self.infoLabel.isHidden = false
            } else {
                self.infoLabel.isHidden = true
            }
        }
    }
    
    func filterPairs(by subgroup: Int) {
        
        self.subgroup = subgroup
        
        if self.allDisciplines.isEmpty {
            self.allDisciplines = self.timetable.disciplines
        }
        
        let filteredDisciplines = self.allDisciplines.filter { $0.subgroup == subgroup }
        
        self.type = filteredDisciplines.first?.type ?? .all
        
        self.timetable.disciplines = filteredDisciplines
        self.tableView.reloadData()
    }
    
    func filterLeftedPairs()-> [Discipline] {
        
        var disciplines = [Discipline]()
        
        let currentDate = dateManager.getCurrentDate()
        let currentTime = dateManager.getCurrentTime(isFullFormat: true)
        
        for pair in allDisciplines {
            
            let pairEndTime = "\(pair.time.components(separatedBy: "-")[1]):00"
            
            let timetableDate = date
            
            let compareDate = dateManager.compareDates(date1: timetableDate, date2: currentDate)
            let compareTime = dateManager.compareTimes(time1: pairEndTime, time2: currentTime)
            
            // прошлый день
            if compareDate == .orderedAscending {
                return disciplines
            }
            
            // время больше и тот же день
            if compareTime == .orderedDescending && compareDate == .orderedSame {
                disciplines.append(pair)
            }
            
            // следующий день
            if compareDate == .orderedDescending {
                return allDisciplines
            }
        }
        
        return disciplines
    }
}
