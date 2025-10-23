//
//  TimeTableDatesListViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 26.06.2024.
//

import UIKit

final class TimeTableDatesListViewController: UIViewController {
    
    // MARK: - сервисы
    let imageSaver = ImageSaver()
    let viewModel: TimeTableDatesListViewModel
    let animation = AnimationClass()
    
    // MARK: - UI
    let tableView = UITableView()
    
    private let noPairsLabel = UILabel()
    
    private let spinner: SpringImageView = {
        let imageView = SpringImageView()
        imageView.image = UIImage(named: "clock")
        imageView.tintColor = .label
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var id: String = ""
    var subgroup: Int = 0
    var owner: String = ""
    var dates = [String]()
    
    // MARK: - Init
    init(id: String, subgroup: Int, owner: String, dates: [String]) {
        self.id = id
        self.subgroup = subgroup
        self.owner = owner
        self.dates = dates
        self.viewModel = TimeTableDatesListViewModel(id: id, owner: owner, dates: dates)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        setUpIndicatorView()
        setUpLabel()
        bindViewModel()
        imageSaver.registerImageHandler { title, message in
            self.showAlert(title: title, message: message, actions: [UIAlertAction(title: "ОК", style: .default)])
        }
    }
    
    private func setUpNavigation() {
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .plain, target: self, action: #selector(closeScreen))
        let sections = UIBarButtonItem(image: UIImage(named: "sections"), menu: setUpMenu())
        closeButton.tintColor = .label
        sections.tintColor = .label
        navigationItem.title = "Расписание"
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItem = sections
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
    }
    
    private func setUpMenu()-> UIMenu {
        
        let ARAction = UIAction(title: "AR режим") { _ in
            let vc = TimetableARViewController(id: self.id, subgroup: self.subgroup, date: self.dates[0], owner: self.owner)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.viewModel.createImage { image in
                vc.image = image
                self.present(navVC, animated: true)
            }
        }
        
        let pseudonymAction = UIAction(title: "Псевдонимы") { _ in
            let vc = TimetablePseudonymCategoriesListTableViewController()
            vc.delegate = self
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        let saveTimetable = UIAction(title: "Сохранить") { _ in
            self.showSaveImageAlert()
        }
        
        let share = UIAction(title: "Поделиться") { _ in
            self.shareImage()
        }
        
        return UIMenu(title: "Расписание", children: [
            ARAction,
            pseudonymAction,
            saveTimetable,
            share
        ])
    }
    
    @objc private func shareImage() {
        viewModel.createImage { image in
            self.ShareImage(image: image, title: self.id, text: self.viewModel.datesString())
            HapticsManager.shared.hapticFeedback()
        }
    }
    
    private func setUpTable() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: TimeTableTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TimeTableTableViewCell.identifier)
        tableView.separatorStyle = .none
    }
    
    private func setUpIndicatorView() {
        view.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        self.spinner.isHidden = false
        self.animation.startRotateAnimation(view: self.spinner)
    }
    
    private func setUpLabel() {
        view.addSubview(noPairsLabel)
        noPairsLabel.text = "Нет пар"
        noPairsLabel.font = .systemFont(ofSize: 18, weight: .medium)
        noPairsLabel.isHidden = true
        noPairsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noPairsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noPairsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.registerDataChangedHandler {
            DispatchQueue.main.async {
                self.spinner.isHidden = true
                self.animation.stopRotateAnimation(view: self.spinner)
                self.tableView.reloadData()
            }
            if !self.viewModel.timetable.isEmpty {
                self.noPairsLabel.isHidden = true
            } else {
                self.noPairsLabel.isHidden = false
            }
        }
        viewModel.getData()
    }
}
