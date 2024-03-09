//
//  FacultyCathedraListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 24.07.2023.
//

import UIKit

class FacultyCathedraListTableViewController: UITableViewController {
    
    var faculty: AGPUFacultyModel
    var isSettings = false
    
    @objc private let viewModel: FacultyCathedraListViewModel!
    
    // MARK: - Init
    init(faculty: AGPUFacultyModel, isSettings: Bool) {
        self.faculty = faculty
        self.isSettings = isSettings
        self.viewModel = FacultyCathedraListViewModel(faculty: faculty)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        tableView.register(UINib(nibName: FacultyCathedraTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: FacultyCathedraTableViewCell.identifier)
        bindViewModel()
    }
    
    private func setUpNavigation() {
        
        let titleView = CustomTitleView(image: "\(faculty.icon)", title: "Кафедры \(faculty.abbreviation)", frame: .zero)
    
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        let backButton = UIBarButtonItem(customView: button)
        
        navigationItem.titleView = titleView
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
        
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
    
    private func bindViewModel() {
        viewModel.observation = observe(\.viewModel.isChanged) { _, _ in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil,
                                          actionProvider: {
            _ in
            
            let infoAction = UIAction(title: "Узнать больше", image: UIImage(named: "info")) { _ in
                self.goToWeb(url: self.faculty.cathedra[indexPath.row].url, image: "info", title: "Кафедра \(self.faculty.abbreviation)", isSheet: false)
            }
            
            let staffInfoAction = UIAction(title: "Состав кафедры", image: UIImage(named: "group")) { _ in
                self.goToWeb(url: self.faculty.cathedra[indexPath.row].staffUrl, image: "group", title: "Состав кафедры", isSheet: false)
            }
            
            let additionalEducationAction = UIAction(title: "Дополнительное образование", image: UIImage(named: "plus")) { _ in
                self.goToWeb(url: self.faculty.cathedra[indexPath.row].additionalEducationUrl, image: "plus", title: "Доп. образование", isSheet: false)
            }
            
            let manualAction = UIAction(title: "Методические материалы", image: UIImage(named: "manual")) { _ in
                self.goToWeb(url: self.faculty.cathedra[indexPath.row].manualUrl, image: "manual", title: "Метод. материалы", isSheet: false)
            }
            
            let emailAction = UIAction(title: "Написать", image: UIImage(named: "mail")) { _ in
                self.showEmailComposer(email: self.faculty.cathedra[indexPath.row].email)
            }
            
            let mapAction = UIAction(title: "Найти кафедру", image: UIImage(named: "map icon")) { _ in
                let vc = AGPUCurrentCathedraMapViewController(cathedra: self.faculty.cathedra[indexPath.row])
                let navVC = UINavigationController(rootViewController: vc)
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                    navVC.modalPresentationStyle = .fullScreen
                    self.present(navVC, animated: true)
                }
            }
            
            let shareAction = UIAction(title: "Поделиться", image: UIImage(named: "share")) { _ in
                self.shareInfo(image: UIImage(named: self.faculty.icon)!, title: self.faculty.abbreviation, text: self.faculty.cathedra[indexPath.row].url)
            }
            
            return UIMenu(title: self.faculty.cathedra[indexPath.row].name, children: [
                infoAction,
                staffInfoAction,
                emailAction,
                mapAction,
                additionalEducationAction,
                manualAction,
                shareAction
            ])
        })
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSettings {
            viewModel.selectCathedra(index: indexPath.row)
        } else {
            showHintAlert(type: .cathedra)
            HapticsManager.shared.hapticFeedback()
        }
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faculty.cathedra.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FacultyCathedraTableViewCell.identifier, for: indexPath) as? FacultyCathedraTableViewCell else {return UITableViewCell()}
        cell.tintColor = .systemGreen
        cell.accessoryType = viewModel.isCathedraSelected(index: indexPath.row) ? .checkmark : .none
        cell.CathedraName.textColor = viewModel.isCathedraSelected(index: indexPath.row) ? .systemGreen : .label
        cell.configure(cathedra: faculty.cathedra[indexPath.row], faculty: faculty)
        return cell
    }
}
