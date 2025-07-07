//
//  TimetableARViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 21.08.2024.
//

import UIKit
import RealityKit
import AVFoundation

protocol TimetableARViewControllerDelegate: AnyObject {
    func dateWasChanged(date: String)
}

protocol TimetableWeekARDelegate: AnyObject {
    func weekWasSelected(week: WeekModel)
}

final class TimetableARViewController: UIViewController {
    
    var image = UIImage()
    var plane: AnchoringComponent.Target.Alignment = .vertical
    var mesh: Mesh = .box
    
    var id: String = ""
    var subgroup: Int = 0
    var date: String = ""
    var owner: String = ""
    var weeks = [WeekModel]()
    var dayType = DayType.near
    var currentWeek = WeekModel(id: 0, from: "", to: "", dayNames: ["" : ""])
    var dates = [String]()
    var isDay = false
    
    weak var delegate: TimetableARViewControllerDelegate?
    weak var weekDelegate: TimetableWeekARDelegate?
    
    // MARK: - UI
    private let arView = ARView()
    
    private let spinner: SpringImageView = {
        let imageView = SpringImageView()
        imageView.image = UIImage(named: "clock")
        imageView.tintColor = .label
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - сервисы
    private let dateManager = DateManager()
    private let service = TimeTableService()
    private let animation = AnimationClass()
    private let speechRecognitionManager = SpeechRecognitionManager()
    private let settingsManager = SettingsManager()
    
    // MARK: - Init
    init(id: String, subgroup: Int, date: String, owner: String) {
        self.id = id
        self.subgroup = subgroup
        self.date = date
        self.owner = owner
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpARView()
        setUpIndicatorView()
        setUpButtons()
        getWeeks()
        SpeechSynthesizerManager.shared.registerSpeechFinishedHandler {
            self.resetSpeechRecognition()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        runSession()
        checkVoiceCommandsOption()
        resetTorchButton()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cancelRecognition()
        stopSession()
    }
    
    private func setUpNavigation() {
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .plain, target: self, action: #selector(closeScreen))
        let options =  UIBarButtonItem(image: UIImage(named: "sections"), menu: setUpMenu())
        options.tintColor = .label
        closeButton.tintColor = .label
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItem = options
    }
    
    private func setUpMenu()-> UIMenu {
        
        let searchAction = UIAction(title: "Поиск") { _ in
            let vc = TimeTableSearchListTableViewController()
            vc.isSettings = false
            vc.delegate = self
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
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
        
        let favouritesList = UIAction(title: "Избранное") { _ in
            let vc = TimeTableFavouriteItemsListTableViewController()
            vc.delegate = self
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        let daysListAction = UIAction(title: "Список дней") { _ in
            let vc = DaysListTableViewController(id: self.id, currentDate: self.date, owner: self.owner, dayType: self.dayType, week: self.currentWeek, dates: self.dates)
            vc.delegate = self
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self.present(navVC, animated: true)
            }
        }
        
        let weeks = UIAction(title: "Недели") { _ in
            let vc = AllWeeksListTableViewController(id: self.id, subgroup: self.subgroup, owner: self.owner)
            vc.isAR = true
            vc.delegate = self
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        let calendarAction = UIAction(title: "Календарь") { _ in
            let vc = CalendarARViewController(date: self.date)
            vc.delegate = self
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self.present(navVC, animated: true)
            }
        }
        
        let navigationsList = UIAction(title: "Навигация") { _ in
            let vc = NavigationsListTableViewController(screen: .timetableAR)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        let share = UIAction(title: "Поделиться") { _ in
            self.makeScreenShot()
        }
        return UIMenu(title: "AR", children: [
            searchAction,
            nearBuildingAction,
            nearBuildingAction,
            groupsList,
            teachersList,
            audiencesList,
            favouritesList,
            daysListAction,
            weeks,
            calendarAction,
            navigationsList,
            share
        ])
    }
    
    @objc private func refresh() {
        let mesh = createMesh()
        let anchor = setAnchor(model: mesh)
        installGestures(on: mesh)
        arView.scene.anchors.removeAll()
        arView.scene.anchors.append(anchor)
        arView.isUserInteractionEnabled = true
        HapticsManager.shared.hapticFeedback()
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        self.dismiss(animated: true)
    }
    
    private func setUpARView() {
        view.addSubview(arView)
        view.addSubview(arView)
        arView.frame = view.bounds
        refresh()
        setUpSwipeGestures()
        checkVoiceCommandsOption()
    }
    
    private func checkVoiceCommandsOption() {
        let screens = settingsManager.loadSpeechScreens()
        if screens.contains(SpeechScreens.ARTimetable) {
            startRecognize()
        }
        navigationTitle()
    }
    
    private func makeNavigationView(image: String, title: String) {
        DispatchQueue.main.async {
            let titleView = CustomTitleView(image: image, title: title, frame: .zero)
            self.navigationItem.titleView = titleView
        }
    }
    
   private func navigationTitle() {
        
        let style = settingsManager.getSavedCommunicationStyle()
        
        let screens = settingsManager.loadSpeechScreens()
        
        if screens.contains(SpeechScreens.ARTimetable) {
            style == .formal ? makeNavigationView(image: "microphone", title: "Говорите...") : makeNavigationView(image: "microphone", title: "Говори...")
        } else {
            makeNavigationView(image: "cube", title: "AR режим")
        }
    }
    
    private func startRecognize() {
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
    
    private func cancelRecognition() {
        let screens = settingsManager.loadSpeechScreens()
        if screens.contains(SpeechScreens.ARTimetable) {
            speechRecognitionManager.cancelSpeechRecognition()
        }
    }
    
    func resetSpeechRecognition() {
        let screens = settingsManager.loadSpeechScreens()
        if screens.contains(SpeechScreens.ARTimetable) {
            cancelRecognition()
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                self.startRecognize()
            }
        }
    }
    
    private func voiceCommands(text: String) {
        voiceRefreshTimetable(text: text)
        voiceGetCurrentTimetable(text: text)
        voiceNavigateTimetable(text: text)
        voiceWeeksList(text: text)
        voicePairsForDate(text: text)
        voiceCloseAlert(text: text)
    }
    
    func voiceRefreshTimetable(text: String) {
        if text.lowercased().contains("обнови") {
            cancelRecognition()
            restartItem()
            closeAlert()
        }
    }
    
    func voiceGetCurrentTimetable(text: String) {
        if text.lowercased().contains("сегодн") {
            cancelRecognition()
            isDay = true
            currentWeek = WeekModel(id: 0, from: "", to: "", dayNames: ["":""])
            date = dateManager.getCurrentDate()
            delegate?.dateWasChanged(date: date)
            getTimetable(date: date)
            closeAlert()
        }
    }
    
    func voiceNavigateTimetable(text: String) {
        if text.lowercased().contains("вперёд") || text.lowercased().contains("вперед") {
            cancelRecognition()
            nextItem()
            closeAlert()
        }
        if text.lowercased().contains("назад") || text.lowercased().contains("обратно") {
            cancelRecognition()
            pastItem()
            closeAlert()
        }
    }
    
    func voiceWeeksList(text: String) {
        if text.lowercased().contains("недел") {
            let vc = AllWeeksListTableViewController(id: self.id, subgroup: self.subgroup, owner: self.owner)
            vc.isAR = true
            vc.delegate = self
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
            closeAlert()
        }
    }
    
    func voicePairsForDate(text: String) {
        let ok = UIAlertAction(title: "ОК", style: .default) { _ in
            SpeechSynthesizerManager.shared.stopComment()
        }
        if text.lowercased().contains(text.lowercased().getDateFromString()) {
            cancelRecognition()
            if dateManager.checkDateFromWords(text: text) {
                isDay = true
                currentWeek = WeekModel(id: 0, from: "", to: "", dayNames: ["":""])
                date = dateManager.getDateFromWords(date: text.getDateFromString())
                delegate?.dateWasChanged(date: date)
                getTimetable(date: date)
            } else {
                self.showInfoAlert(title: "Неверная дата!", message: "не существует такой даты", actions: [ok])
            }
            closeAlert()
        }
    }
    
    func voiceCloseAlert(text: String) {
        if text.lowercased().contains("закр") {
            resetSpeechRecognition()
            closeAlert()
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
    
    func createMesh()-> ModelEntity {
        
        if let texture = try? TextureResource.generate(from: image.cgImage!, options: .init(semantic: .color)) {
            var material = UnlitMaterial(color: .white)
            material.baseColor = MaterialColorParameter.texture(texture)
            let mesh = createMesh(mesh: mesh)
            
            let boxModel = ModelEntity(mesh: mesh, materials: [material])
            
            return boxModel
        }
        
        return ModelEntity()
    }
    
    func createMesh(mesh: Mesh)-> MeshResource {
        switch mesh {
        case .box:
            return MeshResource.generateBox(size: 0.5)
        case .plane:
            return MeshResource.generatePlane(width: 0.6, depth: 0.6)
        }
    }
    
    func setAnchor(model: ModelEntity)-> AnchorEntity {
        let boxAnchor = AnchorEntity(plane: plane)
        model.position = SIMD3(0, 0, 0)
        boxAnchor.addChild(model)
        return boxAnchor
    }
    
    private func installGestures(on object: ModelEntity) {
        object.generateCollisionShapes(recursive: true)
        arView.installGestures([.all], for: object)
    }
    
    private func setUpSwipeGestures() {
        let tap = UITapGestureRecognizer(target: self, action:  #selector(share))
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(makeScreenShot))
        let left = UISwipeGestureRecognizer(target: self, action: #selector(pastItem))
        left.direction = .left
        let right = UISwipeGestureRecognizer(target: self, action: #selector(nextItem))
        right.direction = .right
        arView.addGestureRecognizer(tap)
        arView.addGestureRecognizer(longTap)
        arView.addGestureRecognizer(left)
        arView.addGestureRecognizer(right)
    }
    
    @objc private func share() {
        if currentWeek.id != 0 {
            let week = weeks[currentWeek.id - 1]
            self.ShareImage(image: image, title: id, text: "с \(week.from) по \(week.to)")
            HapticsManager.shared.hapticFeedback()
        } else {
            self.ShareImage(image: image, title: id, text: date)
            HapticsManager.shared.hapticFeedback()
        }
    }
    
    private func restartItem() {
        switch dayType {
        case .near:
            if currentWeek.id == 0 {
               delegate?.dateWasChanged(date: date)
               getTimetable(date: date)
           }
        case .week:
            if (currentWeek.id < weeks.last?.id ?? 0) && currentWeek.id != 0 {
                let number = currentWeek.id
                getTimetable(week: weeks[number])
            }
        case .selected:
            if currentWeek.id == 0 {
               delegate?.dateWasChanged(date: date)
               getTimetable(date: date)
           }
        case .recent:
            if currentWeek.id == 0 {
               delegate?.dateWasChanged(date: date)
               getTimetable(date: date)
           }
        }
    }
    
    @objc private func pastItem() {
        switch dayType {
        case .near:
            if currentWeek.id == 0 {
                date = dateManager.previousDay(date: date)
                delegate?.dateWasChanged(date: date)
                getTimetable(date: date)
            }
        case .week:
            if isDay {
                date = dateManager.previousDay(date: date)
                delegate?.dateWasChanged(date: date)
                getTimetable(date: date)
            } else if (currentWeek.id > weeks.first?.id ?? 0) && currentWeek.id != 0 {
                let number = currentWeek.id - 1
                getTimetable(week: weeks[number - 1])
                weekDelegate?.weekWasSelected(week: weeks[number - 1])
            }
        case .selected:
            if currentWeek.id == 0 {
                date = dateManager.previousDay(date: date)
                delegate?.dateWasChanged(date: date)
                getTimetable(date: date)
            }
        case .recent:
            if currentWeek.id == 0 {
                date = dateManager.previousDay(date: date)
                delegate?.dateWasChanged(date: date)
                getTimetable(date: date)
            }
        }
    }
    
    @objc private func nextItem() {
        switch dayType {
        case .near:
            if currentWeek.id == 0 {
                date = dateManager.nextDay(date: date)
                delegate?.dateWasChanged(date: date)
                getTimetable(date: date)
            }
        case .week:
            if isDay {
                date = dateManager.nextDay(date: date)
                delegate?.dateWasChanged(date: date)
                getTimetable(date: date)
            } else if (currentWeek.id < weeks.last?.id ?? 0) && currentWeek.id != 0 {
                let number = currentWeek.id
                getTimetable(week: weeks[number])
                weekDelegate?.weekWasSelected(week: weeks[number])
            }
        case .selected:
            if currentWeek.id == 0 {
                date = dateManager.nextDay(date: date)
                delegate?.dateWasChanged(date: date)
                getTimetable(date: date)
            }
        case .recent:
            if currentWeek.id == 0 {
                date = dateManager.nextDay(date: date)
                delegate?.dateWasChanged(date: date)
                getTimetable(date: date)
            }
        }
    }
    
    @objc private func makeScreenShot() {
        arView.snapshot(saveToHDR: true) { result in
            self.ShareImage(image: UIImage(cgImage: (result?.cgImage!)!), title: "AR-скриншот", text: self.dateManager.getCurrentDate())
            HapticsManager.shared.hapticFeedback()
        }
    }
    
    private func setUpIndicatorView() {
        view.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setUpButtons() {
        let torchButton = UIButton()
        torchButton.accessibilityIdentifier = "flashlight"
        torchButton.tintColor = .white
        torchButton.setImage(UIImage(named: "flashlight"), for: .normal)
        torchButton.translatesAutoresizingMaskIntoConstraints = false
        let refreshButton = UIButton()
        refreshButton.accessibilityIdentifier = "refresh"
        refreshButton.tintColor = .white
        refreshButton.setImage(UIImage(named: "refresh icon"), for: .normal)
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        arView.addSubview(torchButton)
        arView.addSubview(refreshButton)
        NSLayoutConstraint.activate([
            refreshButton.bottomAnchor.constraint(equalTo: arView.bottomAnchor, constant: -40.0),
            refreshButton.leftAnchor.constraint(equalTo: arView.leftAnchor, constant: 30.0),
            refreshButton.widthAnchor.constraint(equalToConstant: 40.0),
            refreshButton.heightAnchor.constraint(equalToConstant: 40.0),
            torchButton.bottomAnchor.constraint(equalTo: arView.bottomAnchor, constant: -40.0),
            torchButton.rightAnchor.constraint(equalTo: arView.rightAnchor, constant: -30.0),
            torchButton.widthAnchor.constraint(equalToConstant: 50.0),
            torchButton.heightAnchor.constraint(equalToConstant: 50.0)
        ])
        torchButton.addTarget(self, action: #selector(toggleTorch), for: .touchUpInside)
        refreshButton.addTarget(self, action: #selector(refresh), for: .touchUpInside)
    }
    
    @objc private func toggleTorch(sender: UIButton) {
        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else { return }
        if sender.imageView?.image == UIImage(named: "flashlight") {
            sender.setImage(UIImage(named: "flashlight on"), for: .normal)
            device.onOffTorch(on: true)
        } else if sender.imageView?.image == UIImage(named: "flashlight on") {
            sender.setImage(UIImage(named: "flashlight.off"), for: .normal)
            device.onOffTorch(on: false)
        }
    }
    
    func getTimetable(date: String) {
        arView.isUserInteractionEnabled = false
        startAnimation()
        navigationItem.title = "Загрузка..."
        service.getTimeTableDay(id: id, date: date, owner: owner) { result in
            switch result {
            case .success(let data):
                self.createImage(timetable: data)
            case .failure(let error):
                self.createImage(timetable: TimeTable(id: self.id, date: date, disciplines: []))
                print(error)
            }
        }
    }
    
    func getTimetable(week: WeekModel) {
        arView.isUserInteractionEnabled = false
        currentWeek = week
        startAnimation()
        service.getTimeTableWeek(id: id, startDate: week.from, endDate: week.to, owner: owner) { result in
            switch result {
            case .success(let data):
                self.createImage(timetable: data)
            case .failure(let error):
                self.createImage(timetable: [TimeTable(id: self.id, date: self.date, disciplines: [])])
                print(error)
            }
        }
    }
    
    func createImage(timetable: TimeTable) {
        
        let emptyTimetable = TimeTable(id: id, date: date, disciplines: [])
        
        if !timetable.disciplines.isEmpty {
            do {
                let json = try JSONEncoder().encode(timetable)
                self.service.getTimeTableDayImage(json: json) { image in
                    DispatchQueue.main.async {
                        self.image = image
                        self.stopAnimation()
                        self.checkVoiceCommandsOption()
                        self.refresh()
                        HapticsManager.shared.hapticFeedback()
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        } else {
            do {
                let json = try JSONEncoder().encode(emptyTimetable)
                self.service.getTimeTableDayImage(json: json) { image in
                    DispatchQueue.main.async {
                        self.image = image
                        self.stopAnimation()
                        self.checkVoiceCommandsOption()
                        self.refresh()
                        HapticsManager.shared.hapticFeedback()
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func createImage(timetable: [TimeTable]) {
        
        let emptyTimetable = [TimeTable(id: id, date: currentWeek.from, disciplines: [])]
        
        if !timetable.isEmpty {
            do {
                let json = try JSONEncoder().encode(timetable)
                self.service.getTimeTableWeekImage(json: json) { image in
                    DispatchQueue.main.async {
                        self.image = image
                        self.stopAnimation()
                        self.checkVoiceCommandsOption()
                        self.refresh()
                        HapticsManager.shared.hapticFeedback()
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        } else {
            do {
                let json = try JSONEncoder().encode(emptyTimetable)
                self.service.getTimeTableWeekImage(json: json) { image in
                    DispatchQueue.main.async {
                        self.image = image
                        self.stopAnimation()
                        self.checkVoiceCommandsOption()
                        self.refresh()
                        HapticsManager.shared.hapticFeedback()
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func getWeeks() {
        service.getWeeks { result in
            switch result {
            case .success(let data):
                self.weeks = data
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func runSession() {
        guard let configuration = arView.session.configuration else {return}
        arView.session.run(configuration)
    }
    
    func stopSession() {
        arView.session.pause()
    }
    
    func startAnimation() {
        spinner.isHidden = false
        animation.startRotateAnimation(view: spinner)
    }
    
    func stopAnimation() {
        spinner.isHidden = true
        animation.stopRotateAnimation(view: spinner)
    }
    
    func resetTorchButton() {
        if let button = arView.subviews.first(where: { $0.accessibilityIdentifier == "flashlight" }) {
            print("yes")
            (button as? UIButton)?.setImage(UIImage(named: "flashlight"), for: .normal)
        } else {
            print("no")
        }
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
}
