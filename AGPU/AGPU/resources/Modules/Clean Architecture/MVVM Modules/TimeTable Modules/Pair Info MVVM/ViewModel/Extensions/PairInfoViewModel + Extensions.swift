//
//  PairInfoViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 23.10.2023.
//

import MapKit
import UIKit

// MARK: - PairInfoViewModelProtocol
extension PairInfoViewModel: PairInfoViewModelProtocol {
    
    func setUpData() {
        pair.time = timetablePseudonymManager.returnOriginalTime(time: pair.time)
        let startTime = getStartTime()
        let endTime = getEndTime()
        let pairType = pair.type.title
        let subGroup = checkSubGroup(subgroup: pair.subgroup)
        pairInfo.append("Дата: \(date)")
        pairInfo.append("Дисциплина: \(timetablePseudonymManager.returnOriginalDisciplineName(name: pair.name))")
        pairInfo.append("Начало: \(startTime)")
        pairInfo.append("Конец: \(endTime)")
        pairInfo.append("Преподаватель: \(timetablePseudonymManager.returnOriginalTeacherName(name: pair.teacherName))")
        pairInfo.append("Группа: \(timetablePseudonymManager.returnOriginalGroupName(group: pair.groupName))")
        pairInfo.append(subGroup)
        pairInfo.append("Тип пары: \(pairType)")
        pairInfo.append("Аудитория: \(timetablePseudonymManager.returnOriginalAudienceName(audience: pair.audienceID))")
        pairInfo.append("Вычисляем время...")
        pairInfo.append("Вычисляем растояние...")
        pairInfo.append("Вычисляем время прибытия...")
        dataChangedHandler?()
        checkCurrentTime()
        checkLocationAuthorizationStatus()
    }
    
    func getFacultyIcon(group: String)-> String {
        let group = FacultyGroups.groups.first { $0.groups.contains { $0 == group } }
        if let faculty = AGPUFaculties.faculties.first(where: { $0.name == group?.facultyName.removeLastWords() }) {
            print(faculty)
            return faculty.icon
        }
        return "info"
    }
    
    func getStartTime()-> String {
        let times = pair.time.components(separatedBy: "-")
        let startTime = times[0] + ":00"
        return startTime
    }
    
    func getEndTime()-> String {
        let times = pair.time.components(separatedBy: "-")
        let startTime = times[1] + ":00"
        return startTime
    }
    
    func checkSubGroup(subgroup: Int)-> String {
        if subgroup == 0 && !pair.name.contains("Дисциплина по выбору") &&
            pair.type != .exam {
            return "Подгруппа: общая пара"
        } else if pair.name.contains("Дисциплина по выбору") {
            return "Подгруппа: отсутствует"
        } else if pair.type == .exam {
            return "Какая подгруппа? Это экзамен!"
        } else {
            return "Подгруппа: \(subgroup)"
        }
    }
    
    func startTimer() {
        //timer?.fire()
        checkCurrentTime()
    }
    
    func stopTimer() {
        print("timer stopped")
        timer?.invalidate()
        AudioPlayerClass.shared.stopSound()
    }
    
    func checkCurrentTime() {
        // текущая дата
        let currentDate = dateManager.getCurrentDate()
        // начало пары
        let startTime = getStartTime()
        // конец пары
        let endTime = getEndTime()
        // текущее время
        let currentTime = dateManager.getCurrentTime(isFullFormat: true)
        // сравнение двух дат
        let dateComparisonResult = dateManager.compareDates(date1: currentDate, date2: date)
        // сравнение текущего времени и времени начала пары
        let timeComparisonResult = dateManager.compareTimes(time1: currentTime, time2: startTime)
        // сравнение текущего времени и времени окончания пары
        let timeComparisonResult2 = dateManager.compareTimes(time1: currentTime, time2: endTime)
        
        // если даты равны и текущее время меньше времени начала пары
        if dateComparisonResult == .orderedSame && timeComparisonResult == .orderedAscending {
            getTimeLeftToStart()
        }
        
        // если даты равны и текущее время меньше времени окончания пары
        else if dateComparisonResult == .orderedSame && timeComparisonResult2 == .orderedAscending {
            getTimeLeftToEnd()
        }
        
        // если даты равны и текущее время больше времени окончания пары
        else if dateComparisonResult == .orderedSame && timeComparisonResult2 == .orderedDescending {
            getTimeEnded()
        }
        
        // если текущая дата меньше другой
        else if dateComparisonResult == .orderedAscending {
            getTimeLeftToStartInFuture()
        }
        
        // если текущая дата больше другой
        else if dateComparisonResult == .orderedDescending {
            getTimeEnded()
        } else {
            getTimeLeftToStart()
        }
    }
    
    // время до начала пары
    func getTimeLeftToStart() {
        
        let calendar = Calendar.current
        
        let times = getStartTime().components(separatedBy: ":")
        
        let startHour = times[0]
        let endHour = times[1]
        
        var components = DateComponents()
        components.hour = Int(startHour)
        components.minute = Int(endHour)
        
        AudioPlayerClass.shared.stopSound()
        playTimetableSound(sound: sound, isPlaying: true)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            
            let currentDate = Date()
            
            if let startDate = calendar.date(bySettingHour: components.hour!, minute: components.minute!, second: 0, of: currentDate) {
                
                let difference = calendar.dateComponents([.hour, .minute, .second], from: currentDate, to: startDate)
                
                if let hours = difference.hour, let minutes = difference.minute, let seconds = difference.second {
                    if hours <= 0 && minutes <= 0 && seconds <= 0 {
                        self.stopTimer()
                        self.getTimeLeftToEnd()
                        AudioPlayerClass.shared.stopSound()
                        self.playTimetableSound(sound: "ring", isPlaying: false)
                    } else {
                        self.pairInfo[9] = "До начала: \(hours) часов \(minutes) минут \(seconds) секунд"
                        self.checkColor(color: .systemBackground)
                        self.dataChangedHandler?()
                    }
                } else {
                    print("Ошибка")
                }
            } else {
                print("Ошибка при установке времени начала пары")
            }
        }
    }
    
    // время до конца пары
    func getTimeLeftToEnd() {
        
        let calendar = Calendar.current
        
        let times = getEndTime().components(separatedBy: ":")
        
        let startHour = times[0]
        let endHour = times[1]
        
        var components = DateComponents()
        components.hour = Int(startHour)
        components.minute = Int(endHour)
        
        AudioPlayerClass.shared.stopSound()
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
            self.playTimetableSound(sound: self.sound, isPlaying: true)
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            
            let currentDate = Date()
            
            if let startDate = calendar.date(bySettingHour: components.hour!, minute: components.minute!, second: 0, of: currentDate) {
                
                let difference = calendar.dateComponents([.hour, .minute, .second], from: currentDate, to: startDate)
                
                if let hours = difference.hour, let minutes = difference.minute, let seconds = difference.second {
                    
                    if hours >= 0 && minutes >= 0 && seconds >= 0 {
                        self.pairInfo[9] = "До конца пары: \(hours) часов \(minutes) минут \(seconds) секунд"
                        self.checkColor(color: self.pair.type.color)
                        self.dataChangedHandler?()
                    } else if hours <= 0 && minutes <= 0 && seconds <= 0 {
                        self.pairInfo[9] = "Пара закончилась"
                        self.checkColor(color: .gray)
                        self.dataChangedHandler?()
                        self.stopTimer()
                        self.getTimeEnded()
                        AudioPlayerClass.shared.stopSound()
                        self.playTimetableSound(sound: "ring", isPlaying: false)
                    }
                } else {
                    print("Ошибка")
                }
            } else {
                print("Ошибка при установке времени начала пары")
            }
        }
    }
    
    // время до начала пары в будущем
    func getTimeLeftToStartInFuture() {
        
        let calendar = Calendar.current
        
        AudioPlayerClass.shared.stopSound()
        playTimetableSound(sound: sound, isPlaying: true)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            
            let times = self.dateManager.getCurrentTime(isFullFormat: true)
            
            let startTimes = self.getStartTime().components(separatedBy: ":")
            let startHour = startTimes[0]
            let endHour = startTimes[1]
            
            let dates = self.date.components(separatedBy: ".")
            var components = DateComponents()
            components.day = Int(dates[0])
            components.month = Int(dates[1])
            components.year = Int(dates[2])
            
            let currentDate = self.dateManager.getCurrentDate() + " \(times)"
            let startDate = calendar.date(from: components)!
            let startDateString = self.dateManager.getFormattedDate(date: startDate) + " \(startHour):\(endHour):00"
            
            print(currentDate)
            print(startDateString)
            
            let info = self.dateManager.getInfoFromDates(date: currentDate, date2: startDateString)
            
            self.pairInfo[9] = "Осталось: \(abs(info.day ?? 0)) дней \(abs(info.hour ?? 0)) часов \(abs(info.minute ?? 0)) минут \(abs(info.second ?? 0)) секунд"
            self.checkColor(color: .systemBackground)
            self.dataChangedHandler?()
        }
    }
    
    // время после окончания пары
    func getTimeEnded() {
        
        let calendar = Calendar.current
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            
            let times = self.dateManager.getCurrentTime(isFullFormat: true)
            
            let startTimes = self.getEndTime().components(separatedBy: ":")
            let startHour = startTimes[0]
            let endHour = startTimes[1]
            
            let dates = self.date.components(separatedBy: ".")
            var components = DateComponents()
            components.day = Int(dates[0])
            components.month = Int(dates[1])
            components.year = Int(dates[2])
            
            let currentDate = self.dateManager.getCurrentDate() + " \(times)"
            let startDate = calendar.date(from: components)!
            let startDateString = self.dateManager.getFormattedDate(date: startDate) + " \(startHour):\(endHour):00"
            
            print(currentDate)
            print(startDateString)
            
            let info = self.dateManager.getInfoFromDates(date: currentDate, date2: startDateString)
            
            self.pairInfo[9] = "Прошло с окончания: \(abs(info.day ?? 0)) дней \(abs(info.hour ?? 0)) часов \(abs(info.minute ?? 0)) минут \(abs(info.second ?? 0)) секунд"
            self.checkColor(color: .gray)
            self.dataChangedHandler?()
        }
    }
    
    func checkLocationAuthorizationStatus() {
        locationManager.checkLocationAuthorization { isAuthorized in
            if isAuthorized {
                self.getLocation()
            } else {
                self.alertHandler?(true, self.createLocationAlertMessage().0, self.createLocationAlertMessage().1)
            }
        }
    }
    
    func playTimetableSound(sound: String, isPlaying: Bool) {
        if !isRecording() {
            AudioPlayerClass.shared.playSound(sound: sound, isPlaying: isPlaying)
        }
    }
    
    func getLocation() {
        
        pairInfo[10] = "Вычисляем растояние..."
        pairInfo[11] = "Вычисляем время прибытия..."
        
        locationManager.isUpdates = true
        locationManager.getLocations()
        
        locationManager.registerLocationHandler { location in
            
            // текущий корпус
            let currentBuilding = self.currentBuilding()
            
            self.locationManager.getDistance(source: location.coordinate, destination: currentBuilding.pin.coordinate) { km, m, time in
                self.pairInfo[10] = self.convertDistanceToString(km: km, m: m)
                self.pairInfo[11] = self.convertTimeToString(time: time)
                self.dataChangedHandler?()
            } errorHandler: { _ in
                self.pairInfo[10] = "Не получилось вычислить расстояние"
                self.pairInfo[11] = "Не получилось вычислить время"
            }
        }
    }
    
    func convertDistanceToString(km: Int, m: Int)-> String {
        if km == 0 && m <= 100 {
            return "Рядом (\(km) км \(m) м)"
        } else if km == 0 && m == 0 {
            return "На месте"
        } else {
            return "До корпуса \"\(currentBuilding().name)\" осталось: \(km) км \(m) м"
        }
    }
    
    func convertTimeToString(time: [Int])-> String {
        let timeString = "\(time[0]):\(time[1])"
        return "Время прибытия в корпус: \(time[0]) часов \(time[1]) минут (\(self.dateManager.addingTime(addTime: timeString)))"
    }
    
    func currentBuilding()-> AGPUBuildingModel {
        for building in AGPUBuildings.buildings {
            for audience in building.audiences {
                if audience == pair.audienceID {
                    return building
                }
            }
        }
        return AGPUBuildings.buildings[0]
    }
    
    func stopUpdatingLocation() {
        locationManager.manager.stopUpdatingLocation()
    }
    
    func createLocationAlertMessage()-> (String, String) {
        let style = settingsManager.getSavedCommunicationStyle()
        switch style {
        case .formal:
            return ("Геопозиция выключена", "Хотите включить в настройках?")
        case .informal:
            return ("Геопозиция выключена", "Хочешь включить в настройках?")
        }
    }
    
    func checkColor(color: UIColor) {
        if color == UIColor.systemBackground {
            currentColor = .label
        } else {
            currentColor = .black
        }
        if backgroundColor != color {
            backgroundColor = color
            colorHandler?(color)
        }
    }
    
    func createTransportTypeMenu()-> UIMenu {
        let walking = UIAction(title: "Пешком", state: selectedType == .walking ? .on : .off) { item in
            self.selectedType = MKDirectionsTransportType.walking
            self.locationManager.type = self.selectedType
            self.getLocation()
            self.transportTypeHandler?()
        }
        let auto = UIAction(title: "Автомобиль", state: selectedType == .automobile ? .on : .off) { _ in
            self.selectedType = MKDirectionsTransportType.automobile
            self.locationManager.type = self.selectedType
            self.getLocation()
            self.transportTypeHandler?()
        }
        return UIMenu(title: "Тип транспорта", children: [walking, auto])
    }
    
    func isRecording()-> Bool {
        let screens = settingsManager.loadSpeechScreens()
        return screens.contains(SpeechScreens.pairInfo)
    }
    
    func checkVoiceCommandsOption() {
        if isRecording() {
            startRecognize()
        }
    }
    
    func resetSpeechRecognition() {
        if isRecording() {
            cancelRecognition()
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                self.startRecognize()
            }
        }
    }
    
    func cancelRecognition() {
        if isRecording() {
            speechRecognitionManager.cancelSpeechRecognition()
        }
    }
    
    private func startRecognize() {
        speechRecognitionManager.requestSpeechAndMicrophonePermission()
        speechRecognitionManager.registerSpeechAuthorizationHandler { auth in
            switch auth {
            case .notDetermined:
                print("Разрешение на распознавание речи еще не было получено.")
            case .denied:
                self.alertHandler?(true, self.createMicAlertMessage().0, self.createMicAlertMessage().1)
                print("Доступ к распознаванию речи был отклонен.")
            case .restricted:
                print("Функциональность распознавания речи ограничена.")
            case .authorized:
                print("Разрешение на распознавание речи получено.")
                self.speechRecognitionManager.startRecognize()
            @unknown default:
                print("неизвестно")
            }
        }
        speechRecognitionManager.registerSpeechRecognitionHandler { text in
            self.voiceCommands(text: text)
        }
    }
    
    private func voiceCommands(text: String) {
        
        if text.lowercased().contains("все") || text.lowercased().contains("всё")  {
            resetSpeechRecognition()
            currentIndex = -1
            dataChangedHandler?()
        }
        
        if text.lowercased().contains("дат") || text.lowercased().contains("да т")  {
            resetSpeechRecognition()
            currentIndex = 0
            dataChangedHandler?()
        }
        
        if text.lowercased().contains("название") || text.lowercased().contains("дисциплина")  {
            resetSpeechRecognition()
            currentIndex = 1
            dataChangedHandler?()
        }
        
        if text.lowercased().contains("начало") || text.lowercased().contains("начин") {
            resetSpeechRecognition()
            currentIndex = 2
            dataChangedHandler?()
        }
        
        if text.lowercased().contains("конец") || text.lowercased().contains("заканчи") {
            resetSpeechRecognition()
            currentIndex = 3
            dataChangedHandler?()
        }
        
        if text.lowercased().contains("препод") {
            resetSpeechRecognition()
            currentIndex = 4
            dataChangedHandler?()
        }
        
        if text.lowercased().contains("подгруп") {
            resetSpeechRecognition()
            currentIndex = 6
            dataChangedHandler?()
        } else if text.lowercased().contains("груп") {
            resetSpeechRecognition()
            currentIndex = 5
            dataChangedHandler?()
        }
        
        if text.lowercased().contains("тип") {
            resetSpeechRecognition()
            currentIndex = 7
            dataChangedHandler?()
        }
        
        if text.lowercased().contains("аудитори") {
            resetSpeechRecognition()
            currentIndex = 8
            dataChangedHandler?()
        }
        
        if text.lowercased().contains("осталось") {
            resetSpeechRecognition()
            currentIndex = 9
            dataChangedHandler?()
        }
        
        if text.lowercased().contains("расстояни") {
            resetSpeechRecognition()
            currentIndex = 10
            dataChangedHandler?()
        }
        
        if text.lowercased().contains("прибыти") {
            resetSpeechRecognition()
            currentIndex = 11
            dataChangedHandler?()
        }
        
        if text.lowercased().contains("копир") {
            resetSpeechRecognition()
            copyPairInfoText()
        }
    }
    
    func isCurrentWord(index: Int)-> UIColor {
        if currentIndex != -1 {
            return pairInfo[index] == pairInfo[currentIndex] ? currentColor : backgroundColor
        } else {
            return currentColor
        }
    }
    
    func createMicAlertMessage()-> (String, String) {
        let style = settingsManager.getSavedCommunicationStyle()
        let name = UserDefaults.standard.string(forKey: "name") ?? ""
        switch style {
        case .formal:
            return ("Микрофон выключен", "\(!name.isEmpty ? "\(name) хотите" : "Хотите") включить в настройках?")
        case .informal:
            return ("Микрофон выключен", "\(!name.isEmpty ? "\(name) хочешь" : "Хочешь") врубить в настройках?")
        }
    }
    
    func copyPairInfoText() {
        UIPasteboard.general.string = configurePairInfoText()
    }
    
    func configurePairInfoText()-> String {
        var str = ""
        for item in pairInfo {
            str += "\(item)\n"
        }
        return str
    }
    
    func registerColorChangedHandler(block: @escaping(UIColor)->Void) {
        self.colorHandler = block
    }
    
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
    
    func registerTransportTypeHandler(block: @escaping()->Void) {
        self.transportTypeHandler = block
    }
}
