//
//  TimeTableDayListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 12.07.2023.
//

import UIKit

final class TimeTableDayListTableViewController: UIViewController {
    
    var group = ""
    var subgroup = 0
    var date = ""
    var allDisciplines: [Discipline] = []
    var type: PairType = .all
    
    var timetable: TimeTable?
    
    // MARK: - сервисы
    let service = TimeTableService()
    let dateManager = DateManager()
    
    // MARK: - UI
    let tableView = UITableView()
    private let spinner = UIActivityIndicatorView(style: .large)
    private let noTimeTableLabel = UILabel()
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
        setUpNavigation()
        setUpTable()
        setUpRefreshControl()
        setUpIndicatorView()
        setUpLabel()
        getTimeTable(group: group, date: date)
        observeGroupChange()
        observeSubGroupChange()
        observeCalendar()
        observePairType()
    }
    
    private func setUpData() {
        self.group = UserDefaults.standard.string(forKey: "group") ?? "ВМ-ИВТ-2-1"
        self.subgroup = UserDefaults.standard.object(forKey: "subgroup") as? Int ?? 0
        self.type = UserDefaults.loadData(type: PairType.self, key: "type") ?? .all
        date = dateManager.getCurrentDate()
    }
     
    private func setUpNavigation() {
        
        let dayOfWeek = dateManager.getCurrentDayOfWeek(date: date)
        
        navigationItem.title = "Сегодня: \(dayOfWeek) \(date) "
        
        // список групп
        let groupList = UIAction(title: "Группы") { _ in
            let vc = AllGroupsListTableViewController(group: self.group)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        // список подгрупп
        let subGroupsList = UIAction(title: "Подгруппы") { _ in
            let vc = SubGroupsListTableViewController(subgroup: self.subgroup, disciplines: self.allDisciplines)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        // день
        let days = UIAction(title: "День") { _ in
            let vc = DaysListTableViewController(group: self.group, currentDate: self.date)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        // календарь
        let calendar = UIAction(title: "Календарь") { _ in
            let vc = CalendarViewController(group: self.group, date: self.date)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        // недели
        let weeks = UIAction(title: "Недели") { _ in
            let vc = AllWeeksListTableViewController(group: self.group, subgroup: self.subgroup)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        // список типов пар
        let pairTypesList = UIAction(title: "Типы пары") { _ in
            let vc = PairTypesListTableViewController(type: self.type)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        // сохранить расписание
        let saveTimetable = UIAction(title: "Сохранить") { _ in
            self.showSaveImageAlert()
        }
        
        // поделиться расписанием
        let shareTimeTable = UIAction(title: "Поделиться") { _ in
            do {
                let json = try JSONEncoder().encode(self.timetable)
                let dayOfWeek = self.dateManager.getCurrentDayOfWeek(date: self.date)
                self.service.getTimeTableDayImage(json: json) { image in
                    self.ShareImage(image: image, title: self.group, text: "\(dayOfWeek) \(self.date)")
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
        let menu = UIMenu(title: "Расписание", children: [
            groupList,
            subGroupsList,
            days,
            calendar,
            weeks,
            pairTypesList,
            saveTimetable,
            shareTimeTable
        ])
        
        let options = UIBarButtonItem(image: UIImage(named: "sections"), menu: menu)
        options.tintColor = .label
        
        let refreshButton = UIBarButtonItem(image: UIImage(named: "refresh"), style: .plain, target: self, action: #selector(refreshTimetable))
        refreshButton.tintColor = .label
        
        navigationItem.leftBarButtonItem = refreshButton
        navigationItem.rightBarButtonItem = options
    }
    
    @objc private func refreshTimetable() {
        self.type = .all
        self.subgroup = 0
        getTimeTable(group: group, date: date)
        NotificationCenter.default.post(name: Notification.Name("refreshed"), object: nil)
    }
    
    private func setUpIndicatorView() {
        view.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        spinner.startAnimating()
    }
    
    private func setUpTable() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: TimeTableTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TimeTableTableViewCell.identifier)
        tableView.separatorStyle = .none
    }
    
    private func setUpRefreshControl() {
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshTimetable), for: .valueChanged)
    }
    
    private func setUpLabel() {
        view.addSubview(noTimeTableLabel)
        noTimeTableLabel.text = "Нет расписания"
        noTimeTableLabel.font = .systemFont(ofSize: 18, weight: .medium)
        noTimeTableLabel.isHidden = true
        noTimeTableLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noTimeTableLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noTimeTableLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func getTimeTable(group: String, date: String) {
        UserDefaults.standard.setValue(group, forKey: "recentGroup")
        UserDefaults.standard.setValue(date, forKey: "recentDate")
        self.spinner.startAnimating()
        self.noTimeTableLabel.isHidden = true
        self.timetable?.disciplines = []
        self.tableView.reloadData()
        service.getTimeTableDay(groupId: group, date: date) { [weak self] result in
            switch result {
            case .success(let timetable):
                self?.timetable = timetable
                self?.allDisciplines = timetable.disciplines
                if !timetable.disciplines.isEmpty {
                    let data = timetable.disciplines.filter { $0.subgroup == self?.subgroup || $0.subgroup == 0 || (self?.subgroup == 0 && ($0.subgroup == 1 || $0.subgroup == 2)) }
                    if self?.type != .all {
                        self?.timetable?.disciplines = data.filter {$0.type == self?.type}
                    }
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                        self?.spinner.stopAnimating()
                        self?.refreshControl.endRefreshing()
                        self?.noTimeTableLabel.isHidden = true
                    }
                } else {
                    self?.spinner.stopAnimating()
                    self?.refreshControl.endRefreshing()
                    self?.noTimeTableLabel.isHidden = false
                }
            case .failure(let error):
                self?.spinner.stopAnimating()
                self?.refreshControl.endRefreshing()
                self?.noTimeTableLabel.text = "Ошибка"
                self?.noTimeTableLabel.isHidden = false
                print(error.localizedDescription)
            }
        }
    }
    
    private func observeGroupChange() {
        
        NotificationCenter.default.addObserver(forName: Notification.Name("group changed"), object: nil, queue: .main) { notification in
            let group = notification.object as? String ?? "ВМ-ИВТ-2-1"
            self.getTimeTable(group: group, date: self.date)
            self.group = group
            print(self.group)
        }
    }
    
    private func observeSubGroupChange() {
        
        NotificationCenter.default.addObserver(forName: Notification.Name("subgroup changed"), object: nil, queue: .main) { notification in
            
            if let subgroup = notification.object as? Int {
                
                self.subgroup = subgroup
                
                if self.allDisciplines.isEmpty {
                    self.allDisciplines = self.timetable!.disciplines
                }
                
                let filteredDisciplines = self.allDisciplines.filter { $0.subgroup == subgroup }
                
                self.type = filteredDisciplines.first?.type ?? .all
                
                self.timetable?.disciplines = filteredDisciplines
                self.tableView.reloadData()
            }
        }
    }
    
    private func observeCalendar() {
        
        NotificationCenter.default.addObserver(forName: Notification.Name("DateWasSelected"), object: nil, queue: .main) { notification in
            if let date = notification.object as? String {
                let dayOfWeek = self.dateManager.getCurrentDayOfWeek(date: date)
                self.date = date
                self.type = .all
                self.subgroup = 0
                self.getTimeTable(group: self.group, date: date)
                self.navigationItem.title = "\(dayOfWeek) \(date) "
            }
        }
    }
    
    private func observePairType() {
        
        NotificationCenter.default.addObserver(forName: Notification.Name("TypeWasSelected"), object: nil, queue: .main) { [weak self] notification in
            
            guard let type = notification.object as? PairType, let self = self, let timetable = self.timetable else { return }
            
            self.type = type
            
            if type == .all {
                
                if self.allDisciplines.isEmpty {
                    self.allDisciplines = timetable.disciplines
                }
                
                self.timetable?.disciplines = self.allDisciplines
                self.subgroup = 0
                self.tableView.reloadData()
                
            } else {
                
                if self.allDisciplines.isEmpty {
                    self.allDisciplines = timetable.disciplines
                }
                
                if let type = notification.object as? PairType {
                    let filteredDisciplines = self.allDisciplines.filter { $0.type == type }
                    if filteredDisciplines.isEmpty {
                        self.subgroup = 0
                    }
                    self.timetable?.disciplines = filteredDisciplines
                    
                    if filteredDisciplines.first?.type == .lab {
                        self.subgroup = 0
                    } else {
                        self.subgroup = filteredDisciplines.first?.subgroup ?? 0
                    }
                    
                    self.tableView.reloadData()
                    
                } else {
                    self.timetable?.disciplines = self.allDisciplines
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    private func showSaveImageAlert() {
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { _ in
            do {
                let json = try JSONEncoder().encode(self.timetable)
                self.service.getTimeTableDayImage(json: json) { image in
                    let imageSaver = ImageSaver()
                    imageSaver.writeToPhotoAlbum(image: image)
                    self.showImageSavedAlert()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        let cancel = UIAlertAction(title: "Отмена", style: .destructive) { _ in}
        self.showAlert(title: "Сохранить расписание?", message: "Вы хотите сохранить изображение расписания в фото?", actions: [saveAction, cancel])
    }
    
    private func showImageSavedAlert() {
        let ok = UIAlertAction(title: "ОК", style: .default) { _ in}
        self.showAlert(title: "Расписание сохранено!", message: "Изображение расписания успешно сохранено в фото", actions: [ok])
    }
}
