//
//  ARViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 19.06.2024.
//

import UIKit
import RealityKit
import AVFoundation

final class ARViewController: UIViewController {
    
    var image = UIImage()
    var plane: AnchoringComponent.Target.Alignment = .vertical
    var mesh: Mesh = .plane
    
    private let arView = ARView()
    
    // MARK: - сервисы
    private let dateManager = DateManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpARView()
        setUpButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        runSession()
        resetTorchButton()
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
        let imagesList = UIAction(title: "Сохраненные изображения") { _ in
            let vc = SavedImagesListTableViewController()
            vc.ARDelegate = self
            vc.isOption = true
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        let share = UIAction(title: "Поделиться") { _ in
            self.makeScreenShot()
        }
        return UIMenu(title: "AR", children: [
            imagesList,
            share
        ])
    }
        
    @objc private func refresh() {
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
            HapticsManager.shared.hapticFeedback()
        }
    }
}

// MARK: - SavedImagesListTableViewControllerARDelegate
extension ARViewController: SavedImagesListTableViewControllerARDelegate {
        
    func ARImageWasSelected(image: UIImage) {
        self.image = image
        refresh()
    }
    
    func runSession() {
        guard let configuration = arView.session.configuration else {return}
        arView.session.run(configuration)
    }
    
    func stopSession() {
        arView.session.pause()
    }
    
    func resetTorchButton() {
        if let button = arView.subviews.first(where: { $0.accessibilityIdentifier == "flashlight" }) {
            print("yes")
            (button as? UIButton)?.setImage(UIImage(named: "flashlight"), for: .normal)
        } else {
            print("no")
        }
    }
}
