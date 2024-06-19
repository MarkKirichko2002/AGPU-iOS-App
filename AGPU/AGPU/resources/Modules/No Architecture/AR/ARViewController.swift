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
    
    private let arView = ARView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpARView()
    }
    
    private func setUpNavigation() {
        let refreshButton = UIBarButtonItem(image: UIImage(named: "refresh"), style: .plain, target: self, action: #selector(refresh))
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .plain, target: self, action: #selector(closeScreen))
        refreshButton.tintColor = .label
        closeButton.tintColor = .label
        navigationItem.title = "AR режим"
        navigationItem.leftBarButtonItem = refreshButton
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func refresh() {
        let boxAnchor = createBoxWithImage()
        arView.scene.anchors.removeAll()
        arView.scene.anchors.append(boxAnchor)
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        self.dismiss(animated: true)
    }
    
    private func setUpARView() {
        
        let boxAnchor = createBoxWithImage()
        
        view.addSubview(arView)
        arView.frame = view.bounds
        arView.scene.anchors.append(boxAnchor)
        
    }
    
    func createBoxWithImage()-> AnchorEntity {
        
        let boxMesh = MeshResource.generateBox(size: 0.3)
        
        if let texture = try? TextureResource.generate(from: image.cgImage!, options: .init(semantic: .color)) {
            var material = UnlitMaterial(color: .white)
            material.baseColor = MaterialColorParameter.texture(texture)
            
            let boxModel = ModelEntity(mesh: boxMesh, materials: [material])
            
            let boxAnchor = AnchorEntity(plane: .any)
            boxModel.position = SIMD3(0, 0, 0)
            boxAnchor.addChild(boxModel)
            
            return boxAnchor
        }
        
        return AnchorEntity()
    }
}
