//
//  TimetableARViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 21.08.2024.
//

import UIKit
import RealityKit

class TimetableARViewController: UIViewController {
    
    var image = UIImage()
    var plane: AnchoringComponent.Target.Alignment = .vertical
    var mesh: Mesh = .box
    
    var id: String = ""
    var subgroup: Int = 0
    var date: String = ""
    var owner: String = ""
    var weeks = [WeekModel]()
    var currentWeek = WeekModel(id: 0, from: "", to: "", dayNames: ["" : ""])
    
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
        getWeeks()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        runSession()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
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
        navigationItem.title = "AR режим"
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItem = options
    }
    
    private func setUpMenu()-> UIMenu {
        
        let refreshAction = UIAction(title: "Обновить") { _ in
            self.refresh()
        }
        
        let daysListAction = UIAction(title: "День") { _ in
            let vc = DaysListTableViewController(id: self.id, currentDate: self.date, owner: self.owner)
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
        
        let share = UIAction(title: "Поделиться") { _ in
            self.makeScreenShot()
        }
        return UIMenu(title: "AR", children: [
            refreshAction,
            daysListAction,
            weeks,
            calendarAction,
            setUpMeshListMenu(),
            setUpPlaneListMenu(),
            share
        ])
    }
    
    private func setUpPlaneListMenu()-> UIMenu {
        
        let any = UIAction(title: "Любая") { _ in
            self.plane = .any
            let box = self.createMesh()
            let anchor = self.setAnchor(model: box)
            self.installGestures(on: box)
            self.arView.scene.anchors.removeAll()
            self.arView.scene.anchors.append(anchor)
            HapticsManager.shared.hapticFeedback()
        }
        
        let horizontal = UIAction(title: "Горизонтально") { _ in
            self.plane = .horizontal
            let box = self.createMesh()
            let anchor = self.setAnchor(model: box)
            self.installGestures(on: box)
            self.arView.scene.anchors.removeAll()
            self.arView.scene.anchors.append(anchor)
            HapticsManager.shared.hapticFeedback()
        }
        
        let vertical = UIAction(title: "Вертикально", state: .on) { _ in
            self.plane = .vertical
            let box = self.createMesh()
            let anchor = self.setAnchor(model: box)
            self.installGestures(on: box)
            self.arView.scene.anchors.removeAll()
            self.arView.scene.anchors.append(anchor)
            HapticsManager.shared.hapticFeedback()
        }
        
        return UIMenu(title: "Плоскость", options: .singleSelection, children: [
            any,
            horizontal,
            vertical
        ])
    }
    
    private func setUpMeshListMenu()-> UIMenu {
        
        let box = UIAction(title: "Куб", state: .on) { _ in
            self.mesh = .box
            self.refresh()
        }
        
        let plane = UIAction(title: "Плоскость") { _ in
            self.mesh = .plane
            self.refresh()
        }
        
        return UIMenu(title: "Форма", options: .singleSelection, children: [
            box,
            plane
        ])
    }
    
    private func refresh() {
        let mesh = createMesh()
        let anchor = setAnchor(model: mesh)
        installGestures(on: mesh)
        arView.scene.anchors.removeAll()
        arView.scene.anchors.append(anchor)
        HapticsManager.shared.hapticFeedback()
        self.arView.isUserInteractionEnabled = true
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        self.dismiss(animated: true)
    }
    
    private func setUpARView() {
        let box = createMesh()
        let anchor = setAnchor(model: box)
        installGestures(on: box)
        view.addSubview(arView)
        arView.frame = view.bounds
        arView.scene.anchors.append(anchor)
        setUpSwipeGestures()
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
    
    @objc private func pastItem() {
        if (currentWeek.id > weeks.first?.id ?? 0) && currentWeek.id != 0 {
            print(currentWeek.id)
            print(weeks.first?.id ?? 0)
            let number = currentWeek.id - 1
            getTimetable(week: weeks[number - 1])
        } else if currentWeek.id == 0 {
            print("past day")
            date = dateManager.previousDay(date: date)
            getTimetable(date: date)
        }
    }
    
    @objc private func nextItem() {
        if (currentWeek.id < weeks.last?.id ?? 0) && currentWeek.id != 0 {
            print(currentWeek.id)
            print(weeks.last?.id ?? 0)
            let number = currentWeek.id
            getTimetable(week: weeks[number])
        } else if currentWeek.id == 0 {
            print("next day")
            date = dateManager.nextDay(date: date)
            getTimetable(date: date)
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
    
    func getTimetable(date: String) {
        arView.isUserInteractionEnabled = false
        startAnimation()
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
                    self.image = image
                    self.stopAnimation()
                    self.refresh()
                }
            } catch {
                print(error.localizedDescription)
            }
        } else {
            do {
                let json = try JSONEncoder().encode(emptyTimetable)
                self.service.getTimeTableDayImage(json: json) { image in
                    self.image = image
                    self.stopAnimation()
                    self.refresh()
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
                    self.image = image
                    self.stopAnimation()
                    self.refresh()
                }
            } catch {
                print(error.localizedDescription)
            }
        } else {
            do {
                let json = try JSONEncoder().encode(emptyTimetable)
                self.service.getTimeTableWeekImage(json: json) { image in
                    self.image = image
                    self.stopAnimation()
                    self.refresh()
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
}

// MARK: - CalendarARViewControllerDelegate
extension TimetableARViewController: CalendarARViewControllerDelegate {
    
    func dateWasSelected(date: String) {
        self.date = date
        self.currentWeek = WeekModel(id: 0, from: "", to: "", dayNames: ["":""])
        getTimetable(date: date)
    }
}

// MARK: - TimeTableDayListTableViewController
extension TimetableARViewController: DaysListTableViewControllerDelegate {
    
    func dateSelected(date: String) {
        self.date = date
        currentWeek = WeekModel(id: 0, from: "", to: "", dayNames: ["":""])
        getTimetable(date: date)
    }
}

// MARK: - AllWeeksListTableViewControllerDelegate
extension TimetableARViewController: AllWeeksListTableViewControllerDelegate {
    
    func weekWasSelected(week: WeekModel) {
        date = week.from
        getTimetable(week: week)
    }
}
