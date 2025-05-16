//
//  NearBuildingViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 28.11.2024.
//

import UIKit

protocol NearBuildingViewControllerDelegate: AnyObject {
    func audienceSelected(audience: String)
}

final class NearBuildingViewController: UIViewController {
    
    // MARK: - сервисы
    private var viewModel = NearBuildingViewModel()
    
    var info: BuildingInfo
    var isAction = false
    var isTab = false
    
    weak var delegate: NearBuildingViewControllerDelegate?
    weak var screenDelegate: ScreenClosedDelegate?
    
    // MARK: - UI
    private var closeButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(named: "cross"), for: .normal)
        return button
    }()
    
    private var optionsList: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.showsMenuAsPrimaryAction = true
        button.setImage(UIImage(named: "sections"), for: .normal)
        return button
    }()
    
    private let buildingImage: UIImageView = {
        let image = UIImageView()
        image.isUserInteractionEnabled = true
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        image.layer.borderWidth = 2
        image.layer.borderColor = UIColor.label.cgColor
        return image
    }()
    
    private let buildingName: UILabel = {
        let label = UILabel()
        label.text = "Название корпуса"
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let buildingDescription: UILabel = {
        let label = UILabel()
        label.text = "Описание"
        label.textColor = .label
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let findBuildingButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.setTitle("Найти", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .black)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let showBuildingButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.setTitle("Показать", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .black)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    init(info: BuildingInfo) {
        self.info = info
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpConstraints()
        checkToStartFinding()
        bindViewModel()
    }
    
    private func setUpView() {
        view.backgroundColor = .systemBackground
        setUpNavigation()
        setUpTap()
    }
    
    private func setUpNavigation() {
        view.addSubviews(closeButton, optionsList, buildingImage, buildingName, buildingDescription, findBuildingButton, showBuildingButton)
        closeButton.addTarget(self, action: #selector(closeScreen), for: .touchUpInside)
        optionsList.menu = makeMenu()
        findBuildingButton.addTarget(self, action: #selector(startFinding), for: .touchUpInside)
        showBuildingButton.addTarget(self, action: #selector(showInfo), for: .touchUpInside)
        if isTab {
            closeButton.isHidden = true
        }
    }
    
    @objc private func closeScreen() {
        screenDelegate?.screenWasClosed()
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
    }
    
    @objc private func startFinding() {
        changeUI(name: "Загрузка...", description: "Загрузка...")
        deactiveButton()
        viewModel.checkLocationAuthorizationStatus()
    }
    
    @objc private func startSearching() {
        let vc = TimeTableSearchListTableViewController()
        vc.delegate = self
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
        HapticsManager.shared.hapticFeedback()
    }
    
    @objc private func showInfo() {
        switch info {
        case .map:
            if let building = viewModel.getCurrentBuilding() {
                openMap(building: building)
            } else {
                self.showAlert(title: "Нет здания", message: "нужно сначала найти", actions: [UIAlertAction(title: "ОК", style: .default)])
            }
        case .audiences:
            if let building = viewModel.getCurrentBuilding() {
                let vc = AudenciesListTableViewController(name: building.name, audencies: building.audiences)
                vc.isInfo = true
                vc.delegate = self
                let navVC = UINavigationController(rootViewController: vc)
                navVC.modalPresentationStyle = .fullScreen
                present(navVC, animated: true)
                HapticsManager.shared.hapticFeedback()
            } else {
                self.showAlert(title: "Нет здания", message: "нужно сначала найти", actions: [UIAlertAction(title: "ОК", style: .default)])
            }
        }
    }
    
    private func setUpTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(openFullImage))
        buildingImage.addGestureRecognizer(tap)
    }
    
    @objc func openFullImage() {
        let vc = ZoomImageViewController(image: buildingImage.image ?? UIImage())
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
        HapticsManager.shared.hapticFeedback()
    }
    
    private func makeMenu()-> UIMenu {
        switch viewModel.selectedSearchType {
        case .audience:
            return makeAudienceMenu()
        case .distance:
            return makeDistanceMenu()
        }
    }
    
    private func makeDistanceMenu()-> UIMenu {
        let typeAction = viewModel.createTransportTypeMenu()
        let metresAction = viewModel.createMetresMenu()
        let searchTypeAction = viewModel.createSearchTypeMenu()
        let shareAction = UIAction(title: "Поделиться") { _ in
            self.shareBuilding()
        }
        let menu = UIMenu(title: "Нужное здание", children: [
            typeAction,
            metresAction,
            searchTypeAction,
            shareAction
        ])
        return menu
    }
    
    private func makeAudienceMenu()-> UIMenu {
        let searchTypeAction = viewModel.createSearchTypeMenu()
        let shareAction = UIAction(title: "Поделиться") { _ in
            self.shareBuilding()
        }
        let menu = UIMenu(title: "Нужное здание", children: [
            searchTypeAction,
            shareAction
        ])
        return menu
    }
    
    func shareBuilding() {
        if let building = self.viewModel.getCurrentBuilding() {
            let vc = ShareLocationAppsViewController(annotation: building.pin)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        } else {
            self.showAlert(title: "Нет здания", message: "нужно сначала найти", actions: [UIAlertAction(title: "ОК", style: .default)])
        }
    }
    
    private func setUpConstraints() {
        
        optionsList.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
            maker.right.equalToSuperview().inset(20)
        }
        
        closeButton.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
            maker.left.equalToSuperview().inset(20)
        }
        
        buildingImage.snp.makeConstraints { maker in
            maker.top.equalTo(optionsList.snp.bottom).offset(20)
            maker.centerX.equalToSuperview()
            maker.width.equalTo(200)
            maker.height.equalTo(200)
        }
        
        buildingName.snp.makeConstraints { maker in
            maker.top.equalTo(buildingImage.snp.bottom).offset(50)
            maker.centerX.equalToSuperview()
        }
        
        buildingDescription.snp.makeConstraints { maker in
            maker.top.equalTo(buildingName.snp.bottom).offset(50)
            maker.left.equalToSuperview().inset(30)
            maker.right.equalToSuperview().inset(30)
            maker.centerX.equalToSuperview()
        }
        
        findBuildingButton.snp.makeConstraints { maker in
            maker.top.equalTo(buildingDescription.snp.bottom).offset(50)
            maker.width.equalTo(120)
            maker.height.equalTo(30)
            maker.centerX.equalToSuperview()
        }
        
        showBuildingButton.snp.makeConstraints { maker in
            maker.top.equalTo(findBuildingButton.snp.bottom).offset(20)
            maker.width.equalTo(120)
            maker.height.equalTo(30)
            maker.centerX.equalToSuperview()
        }
    }
    
    private func checkToStartFinding() {
        if isAction {
            startFinding()
        }
    }
    
    private func bindViewModel() {
        viewModel.alertHandler = { bool in
            if bool {
                let goToSettings = UIAlertAction(title: "Перейти в настройки", style: .default) { _ in
                    self.openSettings()
                }
                let cancel = UIAlertAction(title: "Отмена", style: .cancel) { _ in
                    self.navigationController?.popViewController(animated: true)
                }
                self.showAlert(title: self.viewModel.createAlertMessage().0, message: self.viewModel.createAlertMessage().1, actions: [goToSettings, cancel])
            }
        }
        viewModel.registerBuildingHandler { building in
            self.updateUI(building: building)
            self.activeButton()
            HapticsManager.shared.hapticFeedback()
        }
        
        viewModel.registerNoBuildingHandler { title, message in
            self.showAlert(title: title, message: message, actions: [UIAlertAction(title: "ОК", style: .default) {_ in self.changeUI(name: "Название корпуса", description: "Описание")}])
            self.activeButton()
            HapticsManager.shared.hapticFeedback()
        }
        
        viewModel.registerMetresHandler {
            DispatchQueue.main.async {
                self.optionsList.menu = self.makeMenu()
            }
        }
        
        viewModel.registerTransportTypeHandler {
            DispatchQueue.main.async {
                self.optionsList.menu = self.makeMenu()
            }
        }
        
        viewModel.registerSearchTypeHandler {
            DispatchQueue.main.async {
                self.optionsList.menu = self.makeMenu()
                self.updateFindButton()
            }
        }
    }
    
    private func updateFindButton() {
        switch viewModel.selectedSearchType {
        case .audience:
            findBuildingButton.setTitle("Поиск", for: .normal)
            findBuildingButton.removeTarget(nil, action: nil, for: .allEvents)
            findBuildingButton.addTarget(self, action: #selector(startSearching), for: .touchUpInside)
        case .distance:
            findBuildingButton.setTitle("Найти", for: .normal)
            findBuildingButton.removeTarget(nil, action: nil, for: .allEvents)
            findBuildingButton.addTarget(self, action: #selector(startFinding), for: .touchUpInside)
        }
    }
    
    private func updateUI(building: AGPUBuildingModel) {
        buildingImage.image = UIImage(named: building.image)
        buildingName.text = building.name
        buildingDescription.text = building.pin.subtitle!!
    }
    
    private func changeUI(name: String, description: String) {
        buildingImage.image = nil
        buildingName.text = name
        buildingDescription.text = description
    }
    
    private func deactiveButton() {
        findBuildingButton.layer.opacity = 0.5
        findBuildingButton.setTitle("Поиск...", for: .normal)
        findBuildingButton.isEnabled = false
    }
    
    private func activeButton() {
        findBuildingButton.layer.opacity = 1.0
        findBuildingButton.setTitle("Найти", for: .normal)
        findBuildingButton.isEnabled = true
    }
    
    private func openMap(building: AGPUBuildingModel) {
        let vc = ASPUBuildingMapViewController(building: building)
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true)
        HapticsManager.shared.hapticFeedback()
    }
}

// MARK: - AudenciesListTableViewControllerDelegate
extension NearBuildingViewController: AudenciesListTableViewControllerDelegate {
    
    func audienceSelected(audience: String) {
        delegate?.audienceSelected(audience: audience)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.dismiss(animated: true)
        }
    }
}

// MARK: - TimeTableSearchListTableViewControllerDelegate
extension NearBuildingViewController: TimeTableSearchListTableViewControllerDelegate {
    
    func itemWasSelected(result: SearchTimetableModel) {
        if viewModel.checkInputText(text: result.name) {
            if let building = viewModel.currentBuilding {
                updateUI(building: building)
            }
        } else {
            self.showAlert(title: "Нет здания", message: "это не аудитория", actions: [UIAlertAction(title: "ОК", style: .default)])
        }
    }
}
