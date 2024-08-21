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
    var date: String = ""
    var owner: String = ""
    
    private let arView = ARView()
    
    // MARK: - сервисы
    private let dateManager = DateManager()
    
    // MARK: - Init
    init(id: String, date: String, owner: String) {
        self.id = id
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
        
        let calendarAction = UIAction(title: "Календарь") { _ in
            let vc = CalendarARViewController(id: self.id, date: self.date, owner: self.owner)
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
    
    private func makeScreenShot() {
        arView.snapshot(saveToHDR: true) { result in
            self.ShareImage(image: UIImage(cgImage: (result?.cgImage!)!), title: "AR-скриншот", text: self.dateManager.getCurrentDate())
        }
    }
    
    func runSession() {
        guard let configuration = arView.session.configuration else {return}
        arView.session.run(configuration)
    }
    
    func stopSession() {
        arView.session.pause()
    }
}

// MARK: - CalendarARViewControllerDelegate
extension TimetableARViewController: CalendarARViewControllerDelegate {
    
    func imageWasCreated(image: UIImage, date: String) {
        self.image = image
        self.date = date
        refresh()
    }
}
