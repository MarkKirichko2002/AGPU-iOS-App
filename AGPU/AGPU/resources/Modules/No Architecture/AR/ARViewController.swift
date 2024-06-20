//
//  ARViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 19.06.2024.
//

import UIKit
import RealityKit

class ARViewController: UIViewController {
    
    var image = UIImage()
    var plane: AnchoringComponent.Target.Alignment?
    
    private let arView = ARView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpARView()
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
        return UIMenu(title: "", children: [refreshAction, setUpPlaneListMenu()])
    }
    
    private func setUpPlaneListMenu()-> UIMenu {
        
        let any = UIAction(title: "Любая", state: .on) { _ in
            let box = self.createBox()
            let anchor = self.setAnchor(model: box, plane: .any)
            self.installGestures(on: box)
            self.arView.scene.anchors.removeAll()
            self.arView.scene.anchors.append(anchor)
            self.plane = .any
            HapticsManager.shared.hapticFeedback()
        }
        
        let horizontal = UIAction(title: "Горизонтально") { _ in
            let box = self.createBox()
            let anchor = self.setAnchor(model: box, plane: .horizontal)
            self.installGestures(on: box)
            self.arView.scene.anchors.removeAll()
            self.arView.scene.anchors.append(anchor)
            self.plane = .horizontal
            HapticsManager.shared.hapticFeedback()
        }
        
        let vertical = UIAction(title: "Вертикально") { _ in
            let box = self.createBox()
            let anchor = self.setAnchor(model: box, plane: .vertical)
            self.installGestures(on: box)
            self.arView.scene.anchors.removeAll()
            self.arView.scene.anchors.append(anchor)
            self.plane = .vertical
            HapticsManager.shared.hapticFeedback()
        }
        
        return UIMenu(title: "Плоскость", options: .singleSelection, children: [
            any,
            horizontal,
            vertical
        ])
    }
    
    private func refresh() {
        let box = createBox()
        let anchor = setAnchor(model: box, plane: plane ?? .any)
        installGestures(on: box)
        arView.scene.anchors.removeAll()
        arView.scene.anchors.append(anchor)
        HapticsManager.shared.hapticFeedback()
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        self.dismiss(animated: true)
    }
    
    private func setUpARView() {
        let box = createBox()
        let anchor = setAnchor(model: box, plane: .any)
        installGestures(on: box)
        view.addSubview(arView)
        arView.frame = view.bounds
        arView.scene.anchors.append(anchor)
    }
    
    func createBox()-> ModelEntity {
        
        let boxMesh = MeshResource.generateBox(size: 0.3)
        
        if let texture = try? TextureResource.generate(from: image.cgImage!, options: .init(semantic: .color)) {
            var material = UnlitMaterial(color: .white)
            material.baseColor = MaterialColorParameter.texture(texture)
            
            let boxModel = ModelEntity(mesh: boxMesh, materials: [material])
            
            return boxModel
        }
        
        return ModelEntity()
    }
    
    func setAnchor(model: ModelEntity, plane: AnchoringComponent.Target.Alignment)-> AnchorEntity {
        let boxMesh = MeshResource.generateBox(size: 0.3)
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
