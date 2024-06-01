//
//  CurrentDateTimeTableDayListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 01.11.2023.
//

import UIKit

class CurrentDateTimeTableDayListTableViewController: UIViewController {

    var timetable = TimeTable(id: "", date: "", disciplines: [])
    private var id: String = ""
    private var date: String = ""
    private var owner: String = ""
    
    private let service = TimeTableService()
    private let dateManager = DateManager()
    private let animation = AnimationClass()
    
    // MARK: - UI
    let tableView = UITableView()
    private let spinner: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "clock")
        imageView.tintColor = .label
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let noTimeTableLabel = UILabel()
    private let refresh = UIRefreshControl()
    
    // MARK: - Init
    init(id: String, date: String, owner: String) {
        self.id = id
        self.date = date
        self.owner = owner
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        setUpRefreshControl()
        setUpIndicatorView()
        setUpLabel()
        getRecentTimetable()
    }

    private func setUpNavigation() {
        navigationItem.title = "\(date) (\(id))"
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .plain, target: self, action: #selector(closeScreen))
        let shareButton = UIBarButtonItem(image: UIImage(named: "share"), style: .plain, target: self, action: #selector(shareImage))
        closeButton.tintColor = .label
        shareButton.tintColor = .label
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItem = shareButton
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
    }
    
    @objc private func shareImage() {
        do {
            let json = try JSONEncoder().encode(self.timetable)
            let dayOfWeek = self.dateManager.getCurrentDayOfWeek(date: self.date)
            self.service.getTimeTableDayImage(json: json) { image in
                self.ShareImage(image: image, title: self.id, text: "\(dayOfWeek) \(self.date)")
                HapticsManager.shared.hapticFeedback()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @objc private func refreshTimetable() {
        getRecentTimetable()
    }
    
    private func setUpIndicatorView() {
        view.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        self.spinner.isHidden = false
        self.animation.startRotateAnimation(view: self.spinner)
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
        tableView.addSubview(refresh)
        refresh.addTarget(self, action: #selector(refreshTimetable), for: .valueChanged)
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
    
    func getRecentTimetable() {
        self.spinner.isHidden = false
        self.animation.startRotateAnimation(view: self.spinner)
        self.noTimeTableLabel.isHidden = true
        self.timetable.disciplines = []
        self.tableView.reloadData()
        service.getTimeTableDay(id: id, date: date, owner: owner) { [weak self] result in
            switch result {
            case .success(let timetable):
                if !timetable.disciplines.isEmpty {
                    DispatchQueue.main.async {
                        self?.timetable = timetable
                        self?.tableView.reloadData()
                        self?.spinner.isHidden = true
                        self?.animation.stopRotateAnimation(view: self!.spinner)
                        self?.refresh.endRefreshing()
                        self?.noTimeTableLabel.isHidden = true
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.spinner.isHidden = true
                        self?.animation.stopRotateAnimation(view: self!.spinner)
                        self?.refresh.endRefreshing()
                        self?.noTimeTableLabel.isHidden = false
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.spinner.isHidden = true
                    self?.animation.stopRotateAnimation(view: self!.spinner)
                    self?.refresh.endRefreshing()
                    self?.noTimeTableLabel.text = "Ошибка"
                    self?.noTimeTableLabel.isHidden = false
                }
                print(error.localizedDescription)
            }
        }
    }
}
