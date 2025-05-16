//
//  TimeTableDayListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 12.07.2023.
//

import UIKit
import AVFoundation
import Combine

final class TimeTableDayListTableViewController: UIViewController {
    
    var id = ""
    var subgroup = 0
    var date = ""
    var owner = ""
    var weeks = [WeekModel]()
    var dayType = DayType.week
    var currentWeek = WeekModel(id: 0, from: "", to: "", dayNames: ["" : ""])
    var dates = [String]()
    var allDisciplines: [Discipline] = []
    var type: PairType = .all
    var currentPairName = ""
    var currentBuilding: AGPUBuildingModel?
    var currentTime: String?
    
    var timetable: TimeTable?
    var image = UIImage()
    var cancellables = Set<AnyCancellable>()
    var currentGesture: handGestures?
    var currentCamera = cameraMode.back
    var currentCameraState = cameraState.off
    var currentCameraPosition: AVCaptureDevice.Position = .back
    var captureSession: AVCaptureSession!
    
    // MARK: - сервисы
    let service = TimeTableService()
    let dateManager = DateManager()
    let textRecognitionManager = TextRecognitionManager()
    let realmManager = RealmManager()
    let settingsManager = SettingsManager()
    let animation = AnimationClass()
    let speechRecognitionManager = SpeechRecognitionManager()
    let imageSaver = ImageSaver()
    let gestureRecognitionManager = GestureRecognitionManager()
    
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
        getTimeTable(id: id, date: date, owner: owner) {}
        setUpCurrentWeek()
        createFloatingButton()
        createCameraButton()
        observeGroupChange()
        observeSubGroupChange()
        observeObjectSelected()
        observePairType()
        observeAdvancedMode()
        observeFloatingButton()
        observeCameraButton()
        SpeechSynthesizerManager.shared.registerSpeechFinishedHandler {
            self.resetSpeechRecognition()
        }
        imageSaver.registerImageHandler { title, message in
            self.showAlert(title: title, message: message, actions: [UIAlertAction(title: "ОК", style: .default)])
        }
        isRecordingVideo = settingsManager.checkRecordingVideo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkVoiceCommandsOption()
        checkGestureOption()
        checkDeviceOrientationControl()
        checkVolumeControl()
        isChanged = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cancelRecognition()
        cancelGestureRecognition()
        removeDeviceOrientationObserve()
        removeVolumeObserve()
    }
    
    private func setUpData() {
        id = UserDefaults.standard.string(forKey: "group") ?? "ВМ-ИВТ-3-1"
        subgroup = UserDefaults.standard.object(forKey: "subgroup") as? Int ?? 0
        type = UserDefaults.loadData(type: PairType.self, key: "type") ?? .all
        date = dateManager.getCurrentDate()
        owner = UserDefaults.standard.string(forKey: "recentOwner") ?? "GROUP"
    }
    
    private func setUpNavigation() {
        
        let options = UIBarButtonItem(image: UIImage(named: "sections"), menu: getCurrentMenu())
        options.accessibilityIdentifier = "menu"
        options.tintColor = .label
        
        let refreshButton = UIBarButtonItem(image: UIImage(named: "refresh"), style: .plain, target: self, action: #selector(refresh))
        refreshButton.accessibilityIdentifier = "refresh button"
        refreshButton.tintColor = .label
        
        navigationItem.leftBarButtonItem = refreshButton
        navigationItem.rightBarButtonItem = options
        
    }
    
    @objc private func refresh() {
        refreshTimetable {}
    }
    
    func getCurrentMenu()-> UIMenu {
        let onAdvancedMode = UserDefaults.standard.object(forKey: "onAdvancedMode") as? Bool ?? false
        if onAdvancedMode {
            return makeMenu()
        } else {
            return makeSimpleMenu()
        }
    }
    
    private func makeMenu()-> UIMenu {
        
        // Поиск
        let searchAction = UIAction(title: "Поиск") { _ in
            self.openSearch()
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
        
        // поделиться расписанием
        let shareTimeTable = UIAction(title: "Поделиться") { _ in
            self.shareTimetable() {}
        }
        
        return UIMenu(title: "Расписание", children: [
            searchAction,
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
            shareTimeTable
        ])
    }
    
    private func makeSimpleMenu()-> UIMenu {
        
        let searchAction = UIAction(title: "Поиск") { _ in
            self.openSearch()
        }
        
        // день
        let days = UIAction(title: "Список дней") { _ in
            self.openDaysList()
        }
        
        // недели
        let weeks = UIAction(title: "Недели") { _ in
            let vc = AllWeeksListTableViewController(id: self.id, subgroup: self.subgroup, owner: self.owner)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        // календарь
        let calendar = UIAction(title: "Календарь") { _ in
            let vc = CalendarViewController(id: self.id, subgroup: self.subgroup, date: self.date, owner: self.owner)
            vc.delegate = self
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        // способы навигации
        let navigationsList = UIAction(title: "Навигация") { _ in
            let vc = NavigationsListTableViewController(screen: .timetableDay)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        // поделиться расписанием
        let shareTimeTable = UIAction(title: "Поделиться") { _ in
            self.shareTimetable {}
        }
        
        return UIMenu(title: "Расписание", children: [
            searchAction,
            days,
            weeks,
            calendar,
            navigationsList,
            shareTimeTable
        ])
    }
    
    @objc func refreshTimetable(completion: @escaping()->Void) {
        self.type = .all
        self.currentBuilding = nil
        self.currentTime = nil
        self.subgroup = 0
        getTimeTable(id: id, date: date, owner: owner) {
            completion()
        }
        NotificationCenter.default.post(name: Notification.Name("refreshed"), object: nil)
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
    
    private func resetFloatingButton() {
        if let button = view.subviews.first(where: { $0.accessibilityIdentifier == "floating button" }) {
            button.removeFromSuperview()
            createFloatingButton()
        } else {
            createFloatingButton()
        }
    }
    
    private func createFloatingButton() {
        let onFloatingButton = UserDefaults.standard.object(forKey: "onFloatingButton timetable") as? Bool ?? true
        if onFloatingButton {
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
            navigationButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -tabBarController!.tabBar.frame.height-17),
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
            setUpDaysNavigation()
        } else if sender.imageView?.image == UIImage(named: "cross icon") {
            sender.setImage(UIImage(named: "aspu logo"), for: .normal)
            animation.springAnimation(view: sender)
            setUpNavigation()
        }
        HapticsManager.shared.hapticFeedback()
    }
    
    private func setUpDaysNavigation() {
        
        let past = UIBarButtonItem(image: UIImage(named: "backward"), style: .plain, target: self, action: #selector(pastDayTapped))
        past.tintColor = .label
        
        let next = UIBarButtonItem(image: UIImage(named: "forward"), style: .plain, target: self, action: #selector(nextDayTapped))
        next.tintColor = .label
        
        navigationItem.leftBarButtonItem = past
        navigationItem.rightBarButtonItem = next
    }
    
    @objc private func pastDayTapped() {
        pastDay { }
    }
    
    @objc private func nextDayTapped() {
        nextDay { }
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
    
    private func resetCameraButton() {
        if let button = view.subviews.first(where: { $0.accessibilityIdentifier == "camera button" }) {
            button.removeFromSuperview()
            createCameraButton()
            isRecordingVideo = false
        } else {
            createCameraButton()
        }
    }
    
    func createCameraButton() {
        let onGestureButton = UserDefaults.standard.object(forKey: "onGestureButton timetable") as? Bool ?? false
        if onGestureButton {
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
            icon.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -tabBarController!.tabBar.frame.height-17),
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
        let dayOfWeek = dateManager.getCurrentDayOfWeek(date: date)
        if option == true {
            UserDefaults.standard.setValue(id, forKey: "recentGroup")
            UserDefaults.standard.setValue(date, forKey: "recentDate")
            UserDefaults.standard.setValue(owner, forKey: "recentOwner")
            UserDefaults.standard.setValue(id, forKey: "group")
        }
        self.spinner.isHidden = false
        self.animation.startRotateAnimation(view: self.spinner)
        self.infoLabel.isHidden = true
        self.timetable?.disciplines = []
        self.tableView.reloadData()
        self.navigationItem.title = "\(dayOfWeek) \(date)"
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
                            self?.timetable?.disciplines = self?.filterLeftedPairs() ?? []
                        } else {
                            self?.timetable?.disciplines = data.filter {$0.type == self?.type}
                        }
                    } else {
                        self?.timetable?.disciplines = data
                    }
                    
                    if self?.timetable?.disciplines.isEmpty ?? false {
                        self?.infoLabel.text = "Нет пар"
                        self?.infoLabel.isHidden = false
                    } else {
                        self?.infoLabel.isHidden = true
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
                    self?.spinner.isHidden = true
                    self?.navigationItem.toggleRefreshButtonFromLeft(on: true)
                    self?.navigationItem.toggleMenuButton(on: true)
                    self?.animation.stopRotateAnimation(view: self!.spinner)
                    self?.refreshControl.endRefreshing()
                    self?.infoLabel.isHidden = false
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
            let id = notification.object as? String ?? "ВМ-ИВТ-3-1"
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
        if settingsManager.checkDeviceOrientationControl() {
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
        if settingsManager.checkDeviceOrientationControl() {
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    func checkVolumeControl() {
        if settingsManager.checkVolumeControl() {
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
        if settingsManager.checkVolumeControl() {
            cancellables.removeAll()
        }
    }
    
    func observeFloatingButton() {
        NotificationCenter.default.addObserver(forName: Notification.Name("floating button timetable"), object: nil, queue: .main) { _ in
            self.resetFloatingButton()
        }
    }
    
    func checkGestureOption() {
        let onGestureButton = UserDefaults.standard.object(forKey: "onGestureButton timetable") as? Bool ?? false
        if onGestureButton {
            observeGestureRecognition()
            setUpCaptureSession()
        }
    }
    
    func observeCameraButton() {
        NotificationCenter.default.addObserver(forName: Notification.Name("gesture button timetable"), object: nil, queue: .main) { _ in
            self.resetCameraButton()
        }
    }
    
    func observeGestureRecognition() {
        NotificationCenter.default.addObserver(forName: Notification.Name("gesture button timetable"), object: nil, queue: .main) { _ in
            self.resetCameraButton()
        }
        gestureRecognitionManager.registerHandGestureHandler { gesture in
            DispatchQueue.main.async {
                self.currentGesture = gesture
                self.closeCameraButtonMenu()
                self.cancelGestureRecognition()
                self.getTimetable(gesture: gesture)
            }
        }
    }
    
    func filterPairs(type: PairType) {
        
        self.currentBuilding = nil
        self.currentTime = nil
        self.type = type
        
        if type == .all {
            
            if self.allDisciplines.isEmpty {
                self.allDisciplines = timetable?.disciplines ?? []
            }
            
            self.timetable?.disciplines = self.allDisciplines
            self.subgroup = 0
            self.tableView.reloadData()
            
        } else if type == .leftToday {
            
            let filteredDisciplines = self.filterLeftedPairs()
            if filteredDisciplines.isEmpty {
                self.subgroup = 0
            }
            self.timetable?.disciplines = filteredDisciplines
            
            if filteredDisciplines.first?.type == .lab {
                self.subgroup = 0
            } else {
                self.subgroup = filteredDisciplines.first?.subgroup ?? 0
            }
            
            self.tableView.reloadData()
            
        } else {
            
            if self.allDisciplines.isEmpty {
                self.allDisciplines = timetable?.disciplines ?? []
            }
            
            let filteredDisciplines = self.allDisciplines.filter { $0.type == type }
            if filteredDisciplines.isEmpty {
                self.subgroup = 0
            }
            self.timetable?.disciplines = filteredDisciplines
            
            if filteredDisciplines.first?.type == .lab {
                self.subgroup = 0
            } else {
                self.subgroup = filteredDisciplines.first?.subgroup ?? 0
            }
            
            self.tableView.reloadData()
        }
        
        if self.timetable?.disciplines.isEmpty ?? false {
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
            self.timetable?.disciplines = disciplines.sorted { self.dateManager.compareTimes(time1: "\($0.time.components(separatedBy: "-")[0]):00", time2: "\($1.time.components(separatedBy: "-")[0]):00") == .orderedAscending}
            self.tableView.reloadData()
            if self.timetable?.disciplines.isEmpty ?? false {
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
            self.timetable?.disciplines = self.allDisciplines.filter { $0.time == filterTime}
            self.tableView.reloadData()
            if self.timetable?.disciplines.isEmpty ?? false {
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
            self.timetable?.disciplines = self.allDisciplines.filter { $0.name == name}
            self.tableView.reloadData()
            if self.timetable?.disciplines.isEmpty ?? false {
                self.infoLabel.isHidden = false
            } else {
                self.infoLabel.isHidden = true
            }
        }
    }
    
    func filterPairs(by subgroup: Int) {
        
        self.subgroup = subgroup
        
        if self.allDisciplines.isEmpty {
            self.allDisciplines = self.timetable!.disciplines
        }
        
        let filteredDisciplines = self.allDisciplines.filter { $0.subgroup == subgroup }
        
        self.type = filteredDisciplines.first?.type ?? .all
        
        self.timetable?.disciplines = filteredDisciplines
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
