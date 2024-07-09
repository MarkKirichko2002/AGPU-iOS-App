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
    
    var isSection = false
    
    // MARK: - UI
    let refresh = UIRefreshControl()
    
    // MARK: - Init
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
        setUpRefreshControl()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        if isSection {
            setUpBackButton()
        } else {
            setUpCloseButton()
        }
        let options = UIBarButtonItem(image: UIImage(named: String.optionsIcon), menu: setUpMenu())
        options.tintColor = .label
        navigationItem.rightBarButtonItem = options
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
        
        let unitsMenu = UIMenu(title: "Единицы", options: .singleSelection, children: [celsiusAction, fahrenheitAction, calvinAction])
        
        let openVC = UIAction(title: "Что нового?") { _ in
            self.showChangesVC()
        }
        
        let shareAction = UIAction(title: "Поделиться") { _ in
            guard let weather = self.viewModel.weather else {return}
            self.shareInfo(image: UIImage(named: "sun")!, title: "Погода", text: self.viewModel.textForMessageToShare())
        }
        
        let other = UIMenu(title: "Другое", children: [openVC, shareAction])
        
        let menu = UIMenu(title: String.menuTitle, children: [unitsMenu, other])
        return menu
    }
    
    func setUpCloseButton() {
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .done, target: self, action: #selector(close))
        closeButton.tintColor = .label
        navigationItem.leftBarButtonItem = closeButton
    }
    
    func setUpBackButton() {
        
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        let backButton = UIBarButtonItem(customView: button)
        
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func back() {
        sendScreenWasClosedNotification()
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func close() {
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
    }
    
    private func setUpTable() {
        tableView.register(CurrentWeatherTableViewCell.self, forCellReuseIdentifier: CurrentWeatherTableViewCell.identifier)
        tableView.register(HourlyWeatherTableViewCell.self, forCellReuseIdentifier: HourlyWeatherTableViewCell.identifier)
        tableView.register(DailyWeatherTableViewCell.self, forCellReuseIdentifier: DailyWeatherTableViewCell.identifier)
    }
    
    private func setUpRefreshControl() {
        tableView.addSubview(refresh)
        refresh.addTarget(self, action: #selector(refreshWeather), for: .valueChanged)
    }
    
    @objc private func refreshWeather() {
        viewModel.refresh()
        refresh.endRefreshing()
    }
    
    private func bindViewModel() {
        viewModel.getWeather()
        cancellable = viewModel.$isFetched.sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        viewModel.registerIsWeatherChangedHandler {
            DispatchQueue.main.async {
                self.showChangesVC()
            }
        }
    }
    
    private func showChangesVC() {
        guard let weather = viewModel.weather else {return}
        guard let savedWeather = viewModel.getData() else {return}
        let model = WeatherChangesModel(date: viewModel.getCurrentDate(), weather: weather)
        let vc = WeatherChangesViewController(pastWeather: savedWeather, currentWeather: model)
        let style = UserDefaults.loadData(type: ScreenPresentationStyles.self, key: "screen presentation style") ?? .notShow
        switch style {
        case .fullScreen:
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        case .sheet:
            vc.modalPresentationStyle = .pageSheet
            present(vc, animated: true)
        case .notShow:
            let vc = HintViewController(info: "Чтобы увидеть экран, выберите его отображение в настройках опции \"Наглядные изменения\"")
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
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
