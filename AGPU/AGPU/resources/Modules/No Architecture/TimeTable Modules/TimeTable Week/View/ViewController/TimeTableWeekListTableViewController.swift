//
//  TimeTableWeekListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 06.08.2023.
//

import UIKit

final class TimeTableWeekListTableViewController: UIViewController {
    
    var id: String = ""
    private var subgroup: Int = 0
    var owner: String = ""
    var week: WeekModel!
    var timetable = [TimeTable]()
    
    // MARK: - сервисы
    let service = TimeTableService()
    let dateManager = DateManager()
    
    // MARK: - UI
    let tableView = UITableView()
    private let spinner = UIActivityIndicatorView(style: .large)
    private let noTimeTableLabel = UILabel()
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Init
    init(id: String, subgroup: Int, week: WeekModel, owner: String) {
        self.id = id
        self.subgroup = subgroup
        self.week = week
        self.owner = owner
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
        setUpLabel()
        setUpIndicatorView()
        getTimeTable()
        setUpRefreshControl()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("прокрутка завершилась")
        HapticsManager.shared.hapticFeedback()
        tableView.isUserInteractionEnabled = true
    }
    
    private func setUpNavigation() {
        
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .label
        
        // поделиться
        let share = UIAction(title: "Поделиться") { _ in
            self.shareTimetable()
        }
        
        // сохранить расписание
        let saveTimetable = UIAction(title: "Сохранить") { _ in
            self.showSaveImageAlert()
        }
        
        let menu = UIMenu(title: "Расписание", children: [setUpDatesMenu(), share, saveTimetable])
        let options = UIBarButtonItem(image: UIImage(named: "sections"), menu: menu)
        options.tintColor = .label
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItem = options
        navigationItem.title = "с \(week.from) до \(week.to)"
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
    }
    
    private func setUpDatesMenu()-> UIMenu {
        
        let currentDay = dateManager.getCurrentDate()
        
        let actions = timetable.enumerated().map { (index: Int, date: TimeTable) -> UIAction in
            let currentDay = week.dayNames[currentDay]
            let day = week.dayNames[date.date]!
            let actionHandler: UIActionHandler = { [weak self] _ in
                self?.tableView.scrollToRow(at: IndexPath(row: 0, section: index), at: .top, animated: true)
            }
            return UIAction(title: week.dayNames[date.date]!, state: currentDay == day ? .on : .off, handler: actionHandler)
        }
        let datesList = UIMenu(title: "Дни недели", options: .singleSelection, children: actions)
        return datesList
    }
    
    private func setUpTable() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: TimeTableTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TimeTableTableViewCell.identifier)
        tableView.separatorStyle = .none
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
    
    private func setUpIndicatorView() {
        view.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        spinner.startAnimating()
    }
    
    private func getTimeTable() {
        self.spinner.startAnimating()
        self.noTimeTableLabel.isHidden = true
        self.timetable = []
        self.tableView.reloadData()
        service.getTimeTableWeek(id: id, startDate: week.from, endDate: week.to, owner: owner) { [weak self] result in
            switch result {
            case .success(let timetable):
                var arr = [TimeTable]()
                if !timetable.isEmpty {
                    for timetable in timetable {
                        let data = timetable.disciplines.filter { $0.subgroup == self?.subgroup || $0.subgroup == 0 || (self?.subgroup == 0 && ($0.subgroup == 1 || $0.subgroup == 2)) }
                        let timeTable = TimeTable(id: self?.id ?? "ВМ-ИВТ-2-1", date: timetable.date, disciplines: data)
                        if !timetable.disciplines.isEmpty {
                            arr.append(timeTable)
                        }
                    }
                    DispatchQueue.main.async {
                        self?.timetable = arr
                        self?.tableView.reloadData()
                        self?.spinner.stopAnimating()
                        self?.refreshControl.endRefreshing()
                        self?.noTimeTableLabel.isHidden = true
                        self?.setUpNavigation()
                        self?.scrollToCurrentDay()
                    }
                    
                } else {
                    self?.noTimeTableLabel.isHidden = false
                    self?.spinner.stopAnimating()
                    self?.refreshControl.endRefreshing()
                    self?.setUpNavigation()
                }
            case .failure(let error):
                self?.spinner.stopAnimating()
                self?.noTimeTableLabel.text = "Ошибка"
                self?.noTimeTableLabel.isHidden = false
                self?.refreshControl.endRefreshing()
                self?.setUpNavigation()
                print(error.localizedDescription)
            }
        }
    }
    
    @objc private func shareTimetable() {
        let emptyTimetable = [TimeTable(id: id, date: week.from, disciplines: [])]
        if !self.timetable.isEmpty {
            do {
                let json = try JSONEncoder().encode(timetable)
                service.getTimeTableWeekImage(json: json) { image in
                    self.ShareImage(image: image, title: self.id, text: "с \(self.week.from) \(self.week.to)")
                }
            } catch {
                print(error.localizedDescription)
            }
        } else {
            do {
                let json = try JSONEncoder().encode(emptyTimetable)
                service.getTimeTableWeekImage(json: json) { image in
                    self.ShareImage(image: image, title: self.id, text: "с \(self.week.from) \(self.week.to)")
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func setUpRefreshControl() {
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshTimetable), for: .valueChanged)
    }
    
    @objc private func refreshTimetable() {
        getTimeTable()
    }
    
    func scrollToCurrentDay() {
        let currentDate = dateManager.getCurrentDate()
        timetable.enumerated().forEach { (index: Int, timetable: TimeTable) in
            if timetable.date == currentDate {
                tableView.isUserInteractionEnabled = false
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                    DispatchQueue.main.async {
                        let indexPath = IndexPath(row: 0, section: index)
                        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                    }
                }
            }
        }
    }
    
    private func showSaveImageAlert() {
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { _ in
            do {
                let json = try JSONEncoder().encode(self.timetable)
                self.service.getTimeTableWeekImage(json: json) { image in
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
