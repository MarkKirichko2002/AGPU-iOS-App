//
//  LocationWeatherDetailViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 13.02.2024.
//

import UIKit
import Combine
import MapKit

private extension String  {
    static let refreshIcon = "refresh"
    static let crossIcon = "cross"
    static let optionsIcon = "sections"
    static let navigationTitle = "Погода"
    static let menuTitle = "Погода"
    static let celsiusActionTitle = "Градусы в Цельсии"
    static let fahrenheitActionTitle = "Градусы в Фаренгейте"
    static let calvinActionTitle = "Градусы в Кельвинах"
}

private extension CGFloat {
    static let heightForRowInFirstSection = 200.0
    static let heightForRowInSecondSection = 100.0
    static let heightForRowInThirdSection = 100.0
}

private extension Int {
    static let numberOfSections = 3
    static let numberOfRowsInFirstSection = 1
    static let numberOfRowsInSecondSection = 1
}

class LocationWeatherDetailViewController: UITableViewController {
    
    private var viewModel: LocationWeatherDetailViewModel
    var cancellable: AnyCancellable?
    
    init(annotation: MKAnnotation) {
        self.viewModel = LocationWeatherDetailViewModel(annotation: annotation)
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
    
    private func setUpNavigation() {
        let refreshButton = UIBarButtonItem(image: UIImage(named: String.refreshIcon), style: .plain, target: self, action: #selector(refreshWeather))
        refreshButton.tintColor = .label
        let closeButton = UIBarButtonItem(image: UIImage(named: String.crossIcon), style: .plain, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .label
        let options = UIBarButtonItem(image: UIImage(named: String.optionsIcon), menu: setUpMenu())
        options.tintColor = .label
        navigationItem.rightBarButtonItem = options
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.title = String.navigationTitle
    }
    
    private func setUpMenu()-> UIMenu {
        let celsiusAction = UIAction(title: String.celsiusActionTitle, state: .on) { _ in
            self.viewModel.convertToCelsius()
        }
        let fahrenheitAction = UIAction(title: String.fahrenheitActionTitle) { _ in
            self.viewModel.convertToFahrenheit()
        }
        let calvinAction = UIAction(title: String.calvinActionTitle) { _ in
            self.viewModel.convertToCalvin()
        }
        
        let menu = UIMenu(title: String.menuTitle, options: .singleSelection, children: [celsiusAction, fahrenheitAction, calvinAction])
        return menu
    }
    
    @objc private func refreshWeather() {
        viewModel.refresh()
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        self.dismiss(animated: true)
    }
    
    private func setUpTable() {
        tableView.register(CurrentWeatherTableViewCell.self, forCellReuseIdentifier: CurrentWeatherTableViewCell.identifier)
        tableView.register(HourlyWeatherTableViewCell.self, forCellReuseIdentifier: HourlyWeatherTableViewCell.identifier)
        tableView.register(DailyWeatherTableViewCell.self, forCellReuseIdentifier: DailyWeatherTableViewCell.identifier)
    }
    
    private func bindViewModel() {
        viewModel.getWeather()
        cancellable = viewModel.$isFetched.sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return CGFloat.heightForRowInFirstSection
        case 1:
            return CGFloat.heightForRowInSecondSection
        default:
            return CGFloat.heightForRowInThirdSection
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Int.numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return Int.numberOfRowsInFirstSection
        case 1:
            return Int.numberOfRowsInSecondSection
        default:
            return viewModel.dailyWeather.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrentWeatherTableViewCell.identifier, for: indexPath) as? CurrentWeatherTableViewCell else {return UITableViewCell()}
            if let weather = viewModel.currentWeather {
                cell.configure(weather: weather)
            }
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HourlyWeatherTableViewCell.identifier, for: indexPath) as? HourlyWeatherTableViewCell else {return UITableViewCell()}
            cell.configure(with: viewModel.hourlyWeather)
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DailyWeatherTableViewCell.identifier, for: indexPath) as? DailyWeatherTableViewCell else {return UITableViewCell()}
            cell.configure(with: viewModel.dailyWeather[indexPath.row])
            return cell
        default:
            return UITableViewCell()
        }
    }
}
