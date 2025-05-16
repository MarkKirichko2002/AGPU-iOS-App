//
//  MonthsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 06.05.2025.
//

import UIKit

enum Month: String, CaseIterable {
    case january = "Январь"
    case february = "Февраль"
    case march = "Март"
    case april = "Апрель"
    case may = "Май"
    case june = "Июнь"
    case july = "Июль"
    case august = "Август"
    case september = "Сентябрь"
    case october = "Октябрь"
    case november = "Ноябрь"
    case december = "Декабрь"
    case none = ""
    
    var number: String {
        switch self {
        case .january: return "01"
        case .february: return "02"
        case .march: return "03"
        case .april: return "04"
        case .may: return "05"
        case .june: return "06"
        case .july: return "07"
        case .august: return "08"
        case .september: return "09"
        case .october: return "10"
        case .november: return "11"
        case .december: return "12"
        case .none: return ""
        }
    }
}

protocol MonthsListTableViewControllerDelegate: AnyObject {
    func monthWasSelected(month: Month)
}

final class MonthsListTableViewController: UITableViewController {

    weak var delegate: MonthsListTableViewControllerDelegate?
    
    var month: Month
    
    init(month: Month) {
        self.month = month
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
    }
    
    private func setUpNavigation() {
        navigationItem.title = "Месяцы"
        setUpBackButton()
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
        navigationController?.popViewController(animated: true)
    }
    
    private func setUpTable() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectMonth(month: Month.allCases[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Month.allCases.count - 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let monthItem = Month.allCases[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.tintColor = .systemGreen
        cell.textLabel?.text = monthItem.rawValue
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        cell.textLabel?.textColor = monthItem == month ? .systemGreen : .label
        cell.accessoryType = monthItem == month ? .checkmark : .none
        return cell
    }
    
    func selectMonth(month: Month) {
        self.month = month
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
            self.delegate?.monthWasSelected(month: month)
            self.back()
        }
        HapticsManager.shared.hapticFeedback()
    }
}
