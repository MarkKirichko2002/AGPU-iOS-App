//
//  SettingsListViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 20.06.2023.
//

import UIKit

final class SettingsListViewController: UIViewController {
    
    // MARK: - сервисы
    @objc let viewModel = SettingsListViewModel()
    
    // MARK: - UI
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        let titleView = CustomTitleView(image: "settings", title: "Настройки", frame: .zero)
        navigationItem.titleView = titleView
    }
    
    private func setUpTable() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        // MARK: - Секция "Основное"
        // Your Status
        tableView.register(UINib(nibName: YourStatusOptionTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: YourStatusOptionTableViewCell.identifier)
        // Selected Faculty
        tableView.register(UINib(nibName: SelectedFacultyOptionTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: SelectedFacultyOptionTableViewCell.identifier)
        // Adaptive News
        tableView.register(UINib(nibName: AdaptiveNewsOptionTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: AdaptiveNewsOptionTableViewCell.identifier)
        // Advanced Timetable
        tableView.register(UINib(nibName: TimetableOptionTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TimetableOptionTableViewCell.identifier)
        // MARK: - Секция "Другие опции"
        // Shake To Recall
        tableView.register(UINib(nibName: ShakeToRecallOptionTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ShakeToRecallOptionTableViewCell.identifier)
        // Only Timetable
        tableView.register(UINib(nibName: OnlyTimetableOptionTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: OnlyTimetableOptionTableViewCell.identifier)
        // Personalized App Icons
        tableView.register(UINib(nibName: AppIconTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: AppIconTableViewCell.identifier)
        // Splash Screen
        tableView.register(UINib(nibName: SplashScreenOptionTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: SplashScreenOptionTableViewCell.identifier)
        // Темы приложения
        tableView.register(UINib(nibName: AppThemesTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: AppThemesTableViewCell.identifier)
        // MARK: - О приложении
        // Фишки приложения
        tableView.register(UINib(nibName: AppFeaturesTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: AppFeaturesTableViewCell.identifier)
        // Погода
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func bindViewModel() {
        viewModel.observation = observe(\.viewModel.isChanged) { _, _ in
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
        viewModel.observeOptionSelection()
    }
}
