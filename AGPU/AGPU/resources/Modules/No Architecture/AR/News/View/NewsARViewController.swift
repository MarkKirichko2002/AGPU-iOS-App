//
//  NewsARViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 20.08.2024.
//

import UIKit
import RealityKit

class NewsARViewController: UIViewController {
    
    var images = [UIImage]()
    var urls = [String]()
    var loadedUrls = [String]()
    var plane: AnchoringComponent.Target.Alignment = .vertical
    var mesh: Mesh = .plane
    var index = 0
    
    private let arView = ARView()
    
    // MARK: - сервисы
    private let dateManager = DateManager()
    
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
        
        let share = UIAction(title: "Поделиться") { _ in
            self.makeScreenShot()
        }
        return UIMenu(title: "AR", children: [
            refreshAction,
            makeImagesListMenu(),
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
        makeImage()
        setUpSwipeGestures()
    }
    
    func createMesh()-> ModelEntity {
        if !images.isEmpty {
            if let texture = try? TextureResource.generate(from: images[index].cgImage!, options: .init(semantic: .color)) {
                var material = UnlitMaterial(color: .white)
                material.baseColor = MaterialColorParameter.texture(texture)
                let mesh = createMesh(mesh: mesh)
                
                let boxModel = ModelEntity(mesh: mesh, materials: [material])
                
                return boxModel
            }
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
        let left = UISwipeGestureRecognizer(target: self, action: #selector(pastImage))
        left.direction = .left
        let right = UISwipeGestureRecognizer(target: self, action: #selector(nextImage))
        right.direction = .right
        arView.addGestureRecognizer(left)
        arView.addGestureRecognizer(right)
    }
    
    @objc private func pastImage() {
        if !images.isEmpty && index > 0 {
            index -= 1
            makeImage()
            print("left")
        }
    }
    
    @objc private func nextImage() {
        if index < urls.count - 1 {
            index += 1
            makeImage()
            print("right")
        }
    }
    
    private func makeScreenShot() {
        arView.snapshot(saveToHDR: true) { result in
            self.ShareImage(image: UIImage(cgImage: (result?.cgImage!)!), title: "AR-скриншот", text: self.dateManager.getCurrentDate())
        }
    }
    
    private func makeImage() {
        
        guard let url = URL(string: urls[index]) else {return}
        
        if checkURL() {
            URLSession.shared.dataTask(with: url) { data, error, _ in
                guard let data = data else {return}
                if let image = UIImage(data: data) {
                    if !self.images.contains(image) {
                        self.images.append(image)
                        DispatchQueue.main.async {
                            self.setUpNavigation()
                            self.refresh()
                        }
                    }
                } else {
                    fatalError()
                }
            }.resume()
        } else {
            setUpNavigation()
            refresh()
        }
    }
    
    private func checkURL()-> Bool {
        if !loadedUrls.contains(urls[index]) {
            loadedUrls.append(urls[index])
            print("еще не загружено")
            return true
        } else {
            print("уже загружено")
            return false
        }
    }
    
    private func makeImagesListMenu()-> UIMenu {
        var items = [UIAction]()
        for i in 0..<urls.count {
            let state: UIMenuElement.State = (index == i) ? .on : .off
            let action = UIAction(title: "Изображение №\(i + 1)", state: state) { _ in
                self.index = i
                self.makeImage()
                self.setUpNavigation()
            }
            items.append(action)
        }
        
        return UIMenu(title: "Изображения", children: items)
    }
    
    func stopSession() {
        arView.session.pause()
    }
}
