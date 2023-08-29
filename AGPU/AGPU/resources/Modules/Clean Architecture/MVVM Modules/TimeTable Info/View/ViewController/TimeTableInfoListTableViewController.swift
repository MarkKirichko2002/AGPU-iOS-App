//
//  TimeTableInfoListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 28.08.2023.
//

import UIKit

class TimeTableInfoListTableViewController: UITableViewController {
    
    var discipline: Discipline
    private var timer: Timer?
    var info = [String]()
    
    // MARK: - Init
    init(discipline: Discipline) {
        self.discipline = discipline
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUpNavigation()
        SetUpTable()
        SetUpData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        StopTimer()
    }
    
    private func SetUpNavigation() {
        navigationItem.title = "Информация о паре"
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .black
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func closeScreen() {
        dismiss(animated: true)
    }
    
    private func SetUpTable() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func SetUpData() {
        let dates = discipline.time.components(separatedBy: "-")
        info.append("время начала: \(dates[0])")
        info.append("время окончания: \(dates[1])")
        info.append("название: \(discipline.name)")
        info.append("преподаватель: \(discipline.teacherName)")
        info.append("аудитория: \(discipline.audienceID)")
        info.append("тип пары: \(CurrentType(type: discipline.type))")
        info.append("до начала: \(CalculateTimeLeftForStart())")
        info.append("до окончания: \(CalculateTimeLeftForEnd())")
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        StartTimer()
    }
    
    private func CurrentType(type: PairType)-> String {
        switch type {
        case .lec:
            return "лекция"
        case .prac:
            return "практика"
        case .exam:
            return "экзамен"
        case .lab:
            return "лабораторная"
        case .hol:
            return "каникулы"
        case .cred:
            return ""
        case .fepo:
            return "ФЭПО"
        case .cons:
            return "консультация"
        case .none:
            return "неизвестно"
        }
    }
    
    private func StartTimer() {
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            
            let time = self.CalculateTimeLeftForStart()
            
            if !time.contains("время вышло") {
                DispatchQueue.main.async {
                    self.info[6] = "до начала: \(self.CalculateTimeLeftForStart())"
                    self.info[7] = "до окончания: еще не началась"
                    self.tableView.reloadData()
                }
            } else if time.contains("пара началась") {
                self.info[7] = "до окончания: \(self.CalculateTimeLeftForEnd())"
                self.tableView.reloadData()
            }
        }
    }
    
    private func StopTimer() {
        timer?.invalidate()
        print("Stopped")
    }
    
    private func CalculateTimeLeftForStart()-> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        
        let dates = discipline.time.components(separatedBy: "-")
        
        // Задайте начальную и конечную даты и времена
        let startDateString = DateManager().getCurrentTime()
        let endDateString = "\(dates[0]):00"
        
        let startDate = dateFormatter.date(from: startDateString)!
        let endDate = dateFormatter.date(from: endDateString)!
        
        // Рассчитайте разницу во времени между двумя датами
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month, .hour, .minute, .second], from: startDate, to: endDate)
        
        let remainingDays = components.day ?? 0
        let remainingMonths = components.month ?? 0
        let remainingHours = components.hour ?? 0
        let remainingMinutes = components.minute ?? 0
        let remainingSeconds = components.second ?? 0
        
        if remainingHours >= 0 && remainingMinutes > 0 && remainingDays > 0 && remainingMonths > 0  {
            return "\(remainingHours) часов \(remainingMinutes) минут \(remainingSeconds) секунд"
        }
        
        if remainingMinutes == 0 {
            return "пара началась"
        }
        
        if remainingDays < 0 && remainingHours < 0 && remainingMinutes < 0 {
            return "время вышло"
        }
        
        return "время вышло"
    }
    
    private func CalculateTimeLeftForEnd()-> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        
        let dates = discipline.time.components(separatedBy: "-")
        
        // Задайте начальную и конечную даты и времена
        let startDateString = DateManager().getCurrentTime()
        let endDateString = "\(dates[1]):00"
        
        let startDate = dateFormatter.date(from: startDateString)!
        let endDate = dateFormatter.date(from: endDateString)!
        
        // Рассчитайте разницу во времени между двумя датами
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: startDate, to: endDate)
        
        let remainingDays = components.day ?? 0
        let remainingMonths = components.month ?? 0
        let remainingHours = components.hour ?? 0
        let remainingMinutes = components.minute ?? 0
        let remainingSeconds = components.second ?? 0
        
        if remainingHours >= 0 && remainingMinutes > 0 && remainingDays > 0 && remainingMonths > 0  {
            return "\(remainingHours) часов \(remainingMinutes) минут \(remainingSeconds) секунд"
        } else {
            StopTimer()
            return "пара закончилась"
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return info.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = info[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        return cell
    }
}
