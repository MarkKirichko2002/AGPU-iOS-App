//
//  FavouriteSectionsListViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 23.09.2024.
//

import UIKit
import MapKit

final class FavouriteSectionsListViewController: UIViewController {
    
    var sections = [ForEveryStatusModel]()
    var currentSection = ForEveryStatusModel(id: 0, image: Data(), name: "")
    var buttonSettingsManager: ButtonSettingsManager?
    
    // MARK: - сервисы
    let settingsManager = SettingsManager()
    
    let refreshControl = UIRefreshControl()
    let noSectionsLabel = UILabel()
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        setUpRefreshControl()
        setUpLabel()
        createFloatingButton()
        observeFloatingButton()
        getData()
        setUpButtonSettings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        buttonSettingsManager?.checkTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        buttonSettingsManager?.stopTimer()
    }
    
    func setUpNavigation() {
        let titleView = CustomTitleView(image: "sections icon", title: "Разделы", frame: .zero)
        navigationItem.titleView = titleView
        setUpEditButton(title: "Править")
        setUpAddButton()
    }
    
    func setUpAddButton() {
        let addButton = UIBarButtonItem(image: UIImage(named: "add"), style: .done, target: self, action: #selector(addButtonTapped))
        addButton.tintColor = .label
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func addButtonTapped() {
        let vc = AllSectionsListTableViewController()
        vc.delegate = self
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setUpEditButton(title: String) {
        let moveButton = UIBarButtonItem(title: title, style: .done, target: self, action: #selector(moveActions))
        moveButton.tintColor = .label
        navigationItem.leftBarButtonItem = moveButton
    }
    
    func startEdit() {
        if !sections.isEmpty {
            tableView.isEditing = true
            setUpEditButton(title: "Готово")
        }
    }
    
    @objc func moveActions() {
        if !sections.isEmpty {
            if tableView.isEditing {
                setUpEditButton(title: "Править")
                tableView.isEditing = false
            } else {
                setUpEditButton(title: "Готово")
                tableView.isEditing = true
            }
        }
    }
    
    func setUpTable() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ForEveryStatusTableViewCell.self, forCellReuseIdentifier: ForEveryStatusTableViewCell.identifier)
    }
    
    private func setUpLabel() {
        view.addSubview(noSectionsLabel)
        noSectionsLabel.text = "Нет разделов"
        noSectionsLabel.font = .systemFont(ofSize: 18, weight: .medium)
        noSectionsLabel.isHidden = true
        noSectionsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noSectionsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noSectionsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func observeFloatingButton() {
        NotificationCenter.default.addObserver(forName: Notification.Name("floating button favourites sections"), object: nil, queue: .main) { _ in
            self.resetFloatingButton()
        }
    }
    
    private func resetFloatingButton() {
        if let button = view.subviews.first(where: { $0.accessibilityIdentifier == "floating button" }) {
            button.removeFromSuperview()
            createFloatingButton()
        } else {
            createFloatingButton()
        }
    }
    
    private func createFloatingButton() {
        if settingsManager.loadASPUButtonScreens().contains(ASPUButtonScreens.favouriteSections) {
            setUpFloatingButton()
        }
    }
    
    private func setUpFloatingButton() {
        let navigationButton = UIButton()
        navigationButton.tintColor = .label
        navigationButton.setImage(UIImage(named: "aspu logo"), for: .normal)
        navigationButton.accessibilityIdentifier = "floating button"
        navigationButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationButton)
        NSLayoutConstraint.activate([
            navigationButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -tabBarController!.tabBar.frame.height-17),
            navigationButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30.0),
            navigationButton.widthAnchor.constraint(equalToConstant: 70.0),
            navigationButton.heightAnchor.constraint(equalToConstant: 70.0)
        ])
        navigationButton.addTarget(self, action: #selector(openRecentSections), for: .touchUpInside)
    }
    
    @objc private func openRecentSections() {
        let vc = RecentFavouriteSectionsListViewController()
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
    
    private func setUpRefreshControl() {
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(getRecentData), for: .valueChanged)
    }
    
    func getData() {
        DispatchQueue.main.async {
            self.sections = self.loadSections()
            self.tableView.reloadData()
            self.check()
        }
    }
    
    func updateData(section: ForEveryStatusModel) {
        let indexPath = IndexPath(row: self.sections.firstIndex(where: { $0.id == section.id })!, section: 0)
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [indexPath], with: .left)
        }
    }
    
    @objc func getRecentData() {
        let recentItems = loadRecentSections()
        if !recentItems.isEmpty {
            DispatchQueue.main.async {
                self.sections = recentItems
                self.tableView.reloadData()
                self.check()
                self.saveSections(sections: self.sections)
                self.refreshControl.endRefreshing()
            }
        } else {
            showAlert(title: "Список пуст", message: "нет недавних разделов", actions: [UIAlertAction(title: "ОК", style: .default) { _ in self.refreshControl.endRefreshing()}])
        }
    }
    
    func check() {
        if sections.isEmpty {
            noSectionsLabel.isHidden = false
        } else {
            noSectionsLabel.isHidden = true
        }
    }
    
    func loadSections()-> [ForEveryStatusModel] {
        var data = [ForEveryStatusModel]()
        if let result = UserDefaults.standard.object(forKey: "sections") as? Data {
            do {
                data = try JSONDecoder().decode([ForEveryStatusModel].self, from: result)
            } catch {
                print(error)
            }
        }
        return data
    }
    
    func loadRecentSections()-> [ForEveryStatusModel] {
        var data = [ForEveryStatusModel]()
        if let result = UserDefaults.standard.object(forKey: "recent sections") as? Data {
            do {
                data = try JSONDecoder().decode([ForEveryStatusModel].self, from: result)
            } catch {
                print(error)
            }
        }
        return data
    }
    
    func deleteAction(section: ForEveryStatusModel) {
        
        var sections = loadSections()
        
        if let index = sections.firstIndex(where: { $0 == section }) {
            sections.remove(at: index)
        }
        
        if sections.isEmpty {
            setUpEditButton(title: "Править")
        }
        
        HapticsManager.shared.hapticFeedback()
        saveSections(sections: sections)
    }
    
    func saveSections(sections: [ForEveryStatusModel]) {
        do {
            let arr = try JSONEncoder().encode(sections)
            UserDefaults.standard.setValue(arr, forKey: "sections")
            getData()
        } catch {
            print(error)
        }
    }
    
    func saveChanges(section: ForEveryStatusModel) {
        do {
            let arr = try JSONEncoder().encode(sections)
            UserDefaults.standard.setValue(arr, forKey: "sections")
            updateData(section: section)
        } catch {
            print(error)
        }
    }
    
    func updateSections(_ index: Int, _ index2: Int) {
        let section = sections.remove(at: index)
        sections.insert(section, at: index2)
        saveSections(sections: sections)
    }
    
    private func setUpButtonSettings() {
        self.buttonSettingsManager = ButtonSettingsManager(screen: .favouriteSections, view: self.view)
    }
}

// MARK: - UITableViewDelegate
extension FavouriteSectionsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let section = sections[indexPath.row]
        
        switch section.id {
            
        case 1:
            if let cell = tableView.cellForRow(at: indexPath) as? ForEveryStatusTableViewCell {
                cell.didTapCell(indexPath: indexPath) {
                    self.goToWeb(url: "http://plany.agpu.net/WebApp/#/", image: "online", title: "ЭИОС", isSheet: false, isNotify: false)
                }
            }
            
        case 2:
            if let cell = tableView.cellForRow(at: indexPath) as? ForEveryStatusTableViewCell {
                cell.didTapCell(indexPath: indexPath) {
                    let vc = AGPUBuildingsMapViewController()
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
        case 3:
            if let cell = tableView.cellForRow(at: indexPath) as? ForEveryStatusTableViewCell {
                cell.didTapCell(indexPath: indexPath) {
                    let annotation = MKPointAnnotation()
                    annotation.title = "Армавир"
                    annotation.coordinate = CLLocationCoordinate2D(latitude: 44.9892, longitude: 41.1234)
                    let vc = LocationWeatherDetailViewController(annotation: annotation)
                    vc.isSection = true
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
        case 4:
            if let cell = tableView.cellForRow(at: indexPath) as? ForEveryStatusTableViewCell {
                cell.didTapCell(indexPath: indexPath) {
                    let vc = AGPUFacultiesListTableViewController()
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
        case 5:
            if let cell = tableView.cellForRow(at: indexPath) as? ForEveryStatusTableViewCell {
                cell.didTapCell(indexPath: indexPath) {
                    let vc = ASPUWebsiteSectionsListViewController()
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
        case 6:
            if let cell = tableView.cellForRow(at: indexPath) as? ForEveryStatusTableViewCell {
                cell.didTapCell(indexPath: indexPath) {
                    if let cathedra = UserDefaults.loadData(type: FacultyCathedraModel.self, key: "cathedra") {
                        self.goToWeb(url: cathedra.manualUrl, image: "online", title: "Метод. материалы", isSheet: false, isNotify: false)
                    } else {
                        self.showHintAlert(type: .manuals, isNotify: false, delegate: nil)
                        HapticsManager.shared.hapticFeedback()
                    }
                }
            }
            
        case 7:
            if let cell = tableView.cellForRow(at: indexPath) as? ForEveryStatusTableViewCell {
                cell.didTapCell(indexPath: indexPath) {
                    let vc = AGPUWallpapersListViewController()
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
        case 8:
            if let cell = tableView.cellForRow(at: indexPath) as? ForEveryStatusTableViewCell {
                cell.didTapCell(indexPath: indexPath) {
                    let vc = DocumentsListTableViewController()
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
        case 9:
            if let cell = tableView.cellForRow(at: indexPath) as? ForEveryStatusTableViewCell {
                cell.didTapCell(indexPath: indexPath) {
                    let vc = SavedImagesListTableViewController()
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
        case 10:
            if let cell = tableView.cellForRow(at: indexPath) as? ForEveryStatusTableViewCell {
                cell.didTapCell(indexPath: indexPath) {
                    let vc = SavedVideosListTableViewController()
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
        case 11:
            if let cell = tableView.cellForRow(at: indexPath) as? ForEveryStatusTableViewCell {
                cell.didTapCell(indexPath: indexPath) {
                    let vc = ContactsListTableViewController()
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
        case 12:
            if let cell = tableView.cellForRow(at: indexPath) as? ForEveryStatusTableViewCell {
                cell.didTapCell(indexPath: indexPath) {
                    let vc = TimeTableFavouriteItemsListTableViewController()
                    vc.isSettings = true
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
        case 13:
            if let cell = tableView.cellForRow(at: indexPath) as? ForEveryStatusTableViewCell {
                cell.didTapCell(indexPath: indexPath) {
                    let vc = SavedWebPagesListTableViewController()
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            
            let item = self.sections[indexPath.row]
            
            let editAction = UIAction(title: "Редактировать", image: UIImage(named: "edit")) { _ in
                self.showEditAlert(section: item)
            }
            
            return UIMenu(title: self.templateName(section: item), children: [
                editAction
            ])
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteAction(section: sections[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if tableView.isEditing {
            updateSections(sourceIndexPath.row, destinationIndexPath.row)
        }
    }
}

extension FavouriteSectionsListViewController: FavouriteTitlesListTableViewControllerDelegate {
    
    func titleWasSelected(title: String) {
        print(currentSection)
        print(title)
        editText(section: currentSection, text: title)
    }
}

// MARK: - UITableViewDataSource
extension FavouriteSectionsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ForEveryStatusTableViewCell.identifier, for: indexPath) as? ForEveryStatusTableViewCell else {return UITableViewCell()}
        cell.configure(for: sections[indexPath.row])
        return cell
    }
}

// MARK: - AllSectionsListTableViewControllerDelegate
extension FavouriteSectionsListViewController: AllSectionsListTableViewControllerDelegate {
    
    func sectionWasAdded() {
        getData()
        setUpEditButton(title: "Править")
        tableView.isEditing = false
    }
}

// MARK: - UIScrollViewDelegate
extension FavouriteSectionsListViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        buttonSettingsManager?.handleScroll()
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension FavouriteSectionsListViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {return}
        print("фотка выбрана")
        editImage(section: currentSection, image: imageData)
        self.dismiss(animated: true)
    }
}


extension FavouriteSectionsListViewController {
    
    func showEditAlert(section: ForEveryStatusModel) {
        let alertVC = UIAlertController(title: "Раздел \"\(templateName(section: section))\"", message: "Что нужно изменить?", preferredStyle: .alert)
        let editTitle = UIAlertAction(title: "Название", style: .default) { _ in
            self.showEditTitleAlert(section: section)
        }
        let editImage = UIAlertAction(title: "Изображение", style: .default) { _ in
            self.currentSection = section
            self.showEditImageAlert(section: section)
        }
        let cancel = UIAlertAction(title: "Отмена", style: .destructive)
        
        alertVC.addAction(editTitle)
        alertVC.addAction(editImage)
        alertVC.addAction(cancel)
        
        SpeechSynthesizerManager.shared.checkIsSaying(text: "\(alertVC.title ?? "") \(alertVC.message ?? "")")
        present(alertVC, animated: true)
    }
    
    func templateName(section: ForEveryStatusModel)-> String {
        return Sections.list.first { $0.id == section.id }!.name
    }
    
    func showEditTitleAlert(section: ForEveryStatusModel) {
        
        let alertVC = UIAlertController(title: createEditTitleAlertMessage().0, message: createEditTitleAlertMessage().1, preferredStyle: .alert)
        
        alertVC.addTextField { (textField) in
            textField.placeholder = "Название"
            textField.text = section.name
        }
        
        let switchAction = UIAlertAction(title: "Заменить", style: .default) { _ in
            let vc = FavouriteTitlesListTableViewController(name: self.templateName(section: section))
            vc.delegate = self
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.currentSection = section
            self.present(navVC, animated: true)
        }
        
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { _ in
            if let name = alertVC.textFields![0].text {
                if !name.isEmpty {
                    self.editText(section: section, text: name)
                }
            }
        }
        
        let reset = UIAlertAction(title: "Сбросить", style: .destructive) { _ in
            self.resetTitle(section: section)
        }
        
        let cancel = UIAlertAction(title: "Отмена", style: .default)
        
        alertVC.addAction(saveAction)
        alertVC.addAction(switchAction)
        alertVC.addAction(reset)
        alertVC.addAction(cancel)
        
        SpeechSynthesizerManager.shared.checkIsSaying(text: "\(alertVC.title ?? "") \(alertVC.message ?? "")")
        present(alertVC, animated: true)
    }
    
    func showEditImageAlert(section: ForEveryStatusModel) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        self.present(vc, animated: true)
    }
    
    func editImage(section: ForEveryStatusModel, image: Data) {
        let index = sections.firstIndex(of: section) ?? 0
        sections[index].image = image
        saveChanges(section: section)
    }
    
    func editText(section: ForEveryStatusModel, text: String) {
        let index = sections.firstIndex(of: section) ?? 0
        if sections[index].name != text {
            sections[index].name = text
            saveChanges(section: section)
        }
    }
    
    func resetTitle(section: ForEveryStatusModel) {
        let searchSection = Sections.list.first { $0.id == section.id }!
        let index = sections.firstIndex(of: section) ?? 0
        if sections[index].name != searchSection.name {
            sections[index].name = searchSection.name
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                self.saveChanges(section: section)
            }
        }
    }
    
    func createEditTitleAlertMessage()-> (String, String) {
        let style = settingsManager.getSavedCommunicationStyle()
        let name = UserDefaults.standard.string(forKey: "name") ?? ""
        switch style {
        case .formal:
            return ("Изменить название", "\(!name.isEmpty ? "\(name) Вы точно хотите изменить" : "Вы точно хотите изменить") название раздела?")
        case .informal:
            return ("Изменить название", "\(!name.isEmpty ? "\(name) ты точно хочешь изменить" : "Ты точно хочешь изменить") название раздела?")
        }
    }
}
