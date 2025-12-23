//
//  PairInfoTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 23.10.2023.
//

import UIKit

final class PairInfoTableViewController: UITableViewController {
    
    private var viewModel: PairInfoViewModel
    
    // MARK: - Init
    init(pair: Discipline, id: String, date: String) {
        self.viewModel = PairInfoViewModel(pair: pair, id: id, date: date)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.startTimer()
        viewModel.checkVoiceCommandsOption()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.stopTimer()
        viewModel.stopUpdatingLocation()
        viewModel.cancelRecognition()
    }
    
    private func setUpNavigation() {
        let titleView = CustomTitleView(image: viewModel.getFacultyIcon(group: viewModel.id), title: "Информация о паре", frame: .zero)
        titleView.imageView.tintColor = viewModel.currentColor
        titleView.label.textColor = viewModel.currentColor
        navigationItem.titleView = titleView
        setUpCloseButton()
        setUpMenu()
    }
    
    func setUpCloseButton() {
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .done, target: self, action: #selector(close))
        closeButton.tintColor = viewModel.currentColor
        navigationItem.leftBarButtonItem = closeButton
    }
    
    @objc private func close() {
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
    }
    
    private func setUpMenu() {
        let menu = UIBarButtonItem(image: UIImage(named: "sections"), menu: createMenu())
        menu.tintColor = viewModel.currentColor
        navigationItem.rightBarButtonItem = menu
    }
    
    func createMenu()-> UIMenu {
        let transpotyType = viewModel.createTransportTypeMenu()
        let voiceCommands = UIAction(title: "Голосовые команды") { _ in
            let vc = VoiceCommandsListTableViewController(type: .pairInfo)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        let copyAction = UIAction(title: "Скопировать") { [weak self] _ in
            DispatchQueue.main.async {
                self?.setUpCancelButton()
                self?.setUpCopyButton()
                self?.viewModel.stopTimer()
                self?.viewModel.stopUpdatingLocation()
                self?.tableView.isEditing = true
            }
        }
        return UIMenu(title: "Информация о паре", children: [transpotyType, voiceCommands, copyAction])
    }
    
    private func setUpTable() {
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func setUpCopyButton() {
        let moveButton = UIBarButtonItem(title: "Копировать", style: .done, target: self, action: #selector(copyInfo))
        moveButton.tintColor = viewModel.currentColor
        navigationItem.rightBarButtonItem = moveButton
    }
    
    @objc private func copyInfo() {
        viewModel.copyPairInfoText()
        cancelCopying()
    }
    
    func setUpCancelButton() {
        let moveButton = UIBarButtonItem(title: "Отмена", style: .done, target: self, action: #selector(cancelCopying))
        moveButton.tintColor = viewModel.currentColor
        navigationItem.leftBarButtonItem = moveButton
    }
    
    @objc private func cancelCopying() {
        for i in 0..<viewModel.pairInfo.count {
            tableView.deselectRow(at: IndexPath(row: i, section: 0), animated: true)
        }
        viewModel.resetSelectedInfo()
        setUpCloseButton()
        setUpMenu()
        viewModel.checkCurrentTime()
        tableView.isEditing = false
    }
    
    private func bindViewModel() {
        viewModel.registerDataChangedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        viewModel.registerColorChangedHandler { color in
            UIView.animate(withDuration: 0.5) {
                self.tableView.backgroundColor = color
                self.setUpNavigation()
            }
        }
        viewModel.registerTransportTypeHandler {
            DispatchQueue.main.async {
                self.setUpNavigation()
            }
        }
        viewModel.alertHandler = { isPresent, title, message in
            if isPresent {
                let goToSettings = UIAlertAction(title: "Перейти в настройки", style: .default) { _ in
                    self.openSettings()
                }
                let cancel = UIAlertAction(title: "Отмена", style: .cancel) { _ in}
                self.showAlert(title: title, message: message, actions: [goToSettings, cancel])
            }
        }
        viewModel.setUpData()
    }
    
    private func goToCorpDetail() {
        let storyboard = UIStoryboard(name: "AGPUBuildingDetailViewController", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "AGPUBuildingDetailViewController") as? AGPUBuildingDetailViewController {
            vc.annotation = viewModel.currentBuilding().pin
            vc.id = UserDefaults.standard.object(forKey: "group") as? String ?? "ВМ-ИВТ-4-1"
            vc.owner = UserDefaults.standard.string(forKey: "recentOwner") ?? "GROUP"
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self.present(navVC, animated: true)
                HapticsManager.shared.hapticFeedback()
            }
        }
    }
    
    private func goToDisciplineInfo() {
        let vc = AIInfoViewController(text: "напиши для чего эта дисциплина: \(viewModel.returnOriginalPairName())?")
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true)
        HapticsManager.shared.hapticFeedback()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            viewModel.selectPairInfoPart(index: indexPath.row)
        } else {
            switch indexPath.row {
            case 1:
                goToDisciplineInfo()
            case 10:
                goToCorpDetail()
            default:
                break
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            viewModel.deSelectPairInfoPart(index: indexPath.row)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.pairInfo.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let info = viewModel.pairInfo
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = selectedView
        cell.textLabel?.text = info[indexPath.row]
        cell.textLabel?.textColor = viewModel.isCurrentWord(index: indexPath.row)
        cell.backgroundColor = .clear
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        cell.textLabel?.numberOfLines = 0
        return cell
    }
}
