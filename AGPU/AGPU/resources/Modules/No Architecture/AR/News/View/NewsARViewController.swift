//
//  NewsARViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 20.08.2024.
//

import UIKit
import RealityKit
import SnapKit
import AVFoundation

final class NewsARViewController: UIViewController {
    
    var images = [UIImage]()
    var urls = [String]()
    var loadedUrls = [String]()
    var plane: AnchoringComponent.Target.Alignment = .vertical
    var mesh: Mesh = .plane
    var index = 0
    
    private let arView = ARView()
    
    // MARK: - сервисы
    private let dateManager = DateManager()
    private let speechRecognitionManager = SpeechRecognitionManager()
    private let settingsManager = SettingsManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillArray()
        setUpNavigation()
        setUpARView()
        setUpButtons()
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
    
    private func fillArray() {
        for _ in 0..<urls.count {
            images.append(UIImage(named: "АГПУ")!)
        }
    }
    
    private func setUpMenu()-> UIMenu {
        
        let voiceCommandsList = UIAction(title: "Голосовые команды") { _ in
            let vc = VoiceCommandsListTableViewController(type: .newsAR)
            vc.screenDelegate = self
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        let share = UIAction(title: "Поделиться") { _ in
            self.makeScreenShot()
        }
        return UIMenu(title: "AR", children: [
            makeImagesListMenu(),
            voiceCommandsList,
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
        view.addSubview(arView)
        view.addSubview(arView)
        arView.frame = view.bounds
        refresh()
        makeImage()
        setUpSwipeGestures()
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
    
    private func checkVoiceCommandsOption() {
        let screens = settingsManager.loadSpeechScreens()
        if screens.contains(SpeechScreens.ARNews) {
            startRecognize()
        }
        navigationTitle()
    }
    
    private func navigationTitle() {
        
        let style = settingsManager.getSavedCommunicationStyle()
        
        let screens = settingsManager.loadSpeechScreens()
        
        if screens.contains(SpeechScreens.ARNews) {
            style == .formal ? makeNavigationView(image: "microphone", title: "Говорите...") : makeNavigationView(image: "microphone", title: "Говори...")
        } else {
            makeNavigationView(image: "cube", title: "AR режим")
        }
    }
    
    private func makeNavigationView(image: String, title: String) {
        DispatchQueue.main.async {
            let titleView = CustomTitleView(image: image, title: title, frame: .zero)
            self.navigationItem.titleView = titleView
        }
    }
    
    private func cancelRecognition() {
        let screens = settingsManager.loadSpeechScreens()
        if screens.contains(SpeechScreens.ARNews) {
            speechRecognitionManager.cancelSpeechRecognition()
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
    
    private func voiceCommands(text: String) {
        
        if text.lowercased().contains("вперёд") || text.lowercased().contains("вперед") {
            cancelRecognition()
            nextImage()
        }
        
        if text.lowercased().contains("назад") || text.lowercased().contains("обратно") {
            cancelRecognition()
            pastImage()
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
    
    func showAlert(title: String) {
        let alertVC = UIAlertController(title: title, message: "больше нет изображений", preferredStyle: .alert)
        alertVC.title = title
        alertVC.addAction(UIAlertAction(title: "ОК", style: .default))
        present(alertVC, animated: true)
    }
    
    func createMesh()-> ModelEntity {
        
        print(images.count)
        
        if let texture = try? TextureResource.generate(from: images[index].cgImage!, options: .init(semantic: .color)) {
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
        } else {
            showAlert(title: "Это первое изображение!")
            checkVoiceCommandsOption()
        }
    }
    
    @objc private func nextImage() {
        if index < urls.count - 1 {
            index += 1
            makeImage()
        } else {
            showAlert(title: "Это последнее изображение!")
            checkVoiceCommandsOption()
        }
    }
    
    private func makeScreenShot() {
        arView.snapshot(saveToHDR: true) { result in
            self.ShareImage(image: UIImage(cgImage: (result?.cgImage!)!), title: "AR-скриншот", text: self.dateManager.getCurrentDate())
            HapticsManager.shared.hapticFeedback()
        }
    }
    
    private func makeImage() {
        
        arView.isUserInteractionEnabled = false
        
        guard let url = URL(string: urls[index]) else {return}
        
        if checkURL() {
            URLSession.shared.dataTask(with: url) { data, error, _ in
                guard let data = data else {return}
                if let image = UIImage(data: data) {
                    if !self.images.contains(image) {
                        self.images[self.index] = image
                        self.checkVoiceCommandsOption()
                        DispatchQueue.main.async {
                            self.setUpNavigation()
                            self.refresh()
                            self.arView.isUserInteractionEnabled = true
                        }
                    }
                } else {
                    fatalError()
                }
            }.resume()
        } else {
            checkVoiceCommandsOption()
            setUpNavigation()
            refresh()
            arView.isUserInteractionEnabled = true
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
                print(self.index)
            }
            items.append(action)
        }
        
        return UIMenu(title: "Изображения", children: items)
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

// MARK: - ScreenClosedDelegate
extension NewsARViewController: ScreenClosedDelegate {
    
    func screenWasClosed() {
        runSession()
        checkVoiceCommandsOption()
        resetTorchButton()
    }
}
