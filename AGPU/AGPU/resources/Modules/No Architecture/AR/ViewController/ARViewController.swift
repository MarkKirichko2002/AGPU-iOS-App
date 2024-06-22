//
//  ARViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 19.06.2024.
//

import UIKit
import RealityKit

enum Mesh {
    case box
    case sphere
    case plane
}

class ARViewController: UIViewController {
    
    var image = UIImage()
    var plane: AnchoringComponent.Target.Alignment = .horizontal
    var mesh: Mesh = .box
    
    private let arView = ARView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpARView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopSession()
    }
    
    private func setUpNavigation() {
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
        let imagesList = UIAction(title: "Сохраненные изображения") { _ in
            let vc = SavedImagesListTableViewController()
            vc.ARDelegate = self
            vc.isOption = true
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        return UIMenu(title: "", children: [
            refreshAction,
            setUpMeshListMenu(),
            setUpPlaneListMenu(),
            imagesList,
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
        
        let horizontal = UIAction(title: "Горизонтально", state: .on) { _ in
            self.plane = .horizontal
            let box = self.createMesh()
            let anchor = self.setAnchor(model: box)
            self.installGestures(on: box)
            self.arView.scene.anchors.removeAll()
            self.arView.scene.anchors.append(anchor)
            HapticsManager.shared.hapticFeedback()
        }
        
        let vertical = UIAction(title: "Вертикально") { _ in
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
        
        let sphere = UIAction(title: "Сфера") { _ in
            self.mesh = .sphere
            self.refresh()
        }
        
        let plane = UIAction(title: "Плоскость") { _ in
            self.mesh = .plane
            self.refresh()
        }
        
        return UIMenu(title: "Форма", options: .singleSelection, children: [
            box,
            sphere,
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
        
        let mesh = createMesh(mesh: mesh)
        
        if let texture = try? TextureResource.generate(from: image.cgImage!, options: .init(semantic: .color)) {
            var material = UnlitMaterial(color: .white)
            material.baseColor = MaterialColorParameter.texture(texture)
            
            let boxModel = ModelEntity(mesh: mesh, materials: [material])
            
            return boxModel
        }
        
        return ModelEntity()
    }
    
    func createMesh(mesh: Mesh)-> MeshResource {
        switch mesh {
        case .box:
            return MeshResource.generateBox(size: 0.5)
        case .sphere:
            return MeshResource.generateSphere(radius: 0.3)
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
}

// MARK: - SavedImagesListTableViewControllerARDelegate
extension ARViewController: SavedImagesListTableViewControllerARDelegate {
    
    func screenWasClosed() {
        runSession()
    }
    
    func ARImageWasSelected(image: UIImage) {
        self.image = image
        runSession()
        refresh()
    }
    
    func runSession() {
        guard let configuration = arView.session.configuration else {return}
        arView.session.run(configuration)
    }
    
    func stopSession() {
        arView.session.pause()
    }
}
