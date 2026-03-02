//
//  AGPUBuildingsMapViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 23.07.2023.
//

import MapKit

// MARK: - AGPUBuildingsMapViewModelProtocol
extension AGPUBuildingsMapViewModel: AGPUBuildingsMapViewModelProtocol {
    
    func setUpBuildings() {
        filterBuildings()
        setUpBuildingsPseudonym()
    }
    
    func filterBuildings() {
        arr = AGPUBuildingPins.pins
        let selectedBuildings = settingsManager.loadBuildings()
        if !selectedBuildings.isEmpty {
            arr = arr.filter { selectedBuildings.contains($0.title!) }
        }
    }
    
    func setUpBuildingsPseudonym() {
        let data = settingsManager.loadTimetablePseudonyms(category: PseudonymCategories.buildings.rawValue)
        for i in 0..<arr.count {
            if let item = data.first(where: { $0.originalName == arr[i].title }) {
                arr[i].title = item.pseudonym
            }
        }
    }
    
    func checkLocationAuthorizationStatus() {
        locationManager.checkLocationAuthorization { isAuthorized in
            if isAuthorized {
                self.getLocation()
            } else {
                self.alertHandler?(true)
            }
        }
    }
    
    func getLocation() {
        
        locationManager.getLocations()
        
        locationManager.registerLocationHandler { location in
            
            let coordinate = CLLocationCoordinate2D(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude
            )
            
            let span = MKCoordinateSpan(
                latitudeDelta: 0.1,
                longitudeDelta: 0.1
            )
            
            let region = MKCoordinateRegion(
                center: coordinate,
                span: span
            )
            self.setUpBuildings()
            self.currentLocation(coordinate: coordinate)
            let location = LocationModel(region: region, pins: self.arr)
            self.location = coordinate
            self.locationHandler?(location)
        }
    }
    
    func currentLocation(coordinate: CLLocationCoordinate2D) {
        // текущая геопозиция
        let currentpin = CustomAnnotation(coordinate: coordinate, title: "Вы", subtitle: "")
        if !arr.contains(where: { $0.title == "Вы" }) {
            arr.insert(currentpin, at: 0)
        }
    }
    
    func currentLocationPin()-> MKAnnotation {
        let building = arr.first { $0.title == "Вы" }!
        return building
    }
    
    func defaultLocation()-> MKCoordinateRegion {
        let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
        let region = MKCoordinateRegion(center: arr[index].coordinate, span: span)
        return region
    }
    
    func nextLocation()-> MKCoordinateRegion? {
        if index < arr.count - 1 {
            index += 1
            let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
            let region = MKCoordinateRegion(center: arr[index].coordinate, span: span)
            return region
        }
        return nil
    }
    
    func pastLocation()-> MKCoordinateRegion? {
        if index > 0 {
            index -= 1
            let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
            let region = MKCoordinateRegion(center: arr[index].coordinate, span: span)
            return region
        }
        return nil
    }
    
    func isRecording()-> Bool {
        let screens = settingsManager.loadScreens(way: differentWays.voiceCommands)
        return screens.contains(appScreens.mapCorps)
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
                self.alertMicHandler?(true, self.createMicAlertMessage().0, self.createMicAlertMessage().1)
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
        getCurrentLocation(text: text)
        searchBuildindWithVoice(text: text)
        navigationBetweenBuildings(text: text)
    }
    
    private func getCurrentLocation(text: String) {
        if text.lowercased().contains("текущ") {
            resetSpeechRecognition()
            index = 0
            self.voiceChoiceHandler?(currentLocationPin())
        }
    }
    
    private func searchBuildindWithVoice(text: String) {
        for building in AGPUBuildings.buildings {
            if building.voiceCommands.contains(where: { text.lowercased().range(of: $0.lowercased()) != nil }) {
                resetSpeechRecognition()
                index = arr.firstIndex(where: { $0.title! == building.name }) ?? 0
                print(index)
                self.voiceChoiceHandler?(building.pin)
            }
        }
    }
    
    private func navigationBetweenBuildings(text: String) {
        
        if text.lowercased().contains("вперёд") || text.lowercased().contains("вперед") {
            resetSpeechRecognition()
            guard let region = nextLocation() else {return}
            let annotation = MKPointAnnotation()
            annotation.coordinate = region.center
            self.voiceChoiceHandler?(annotation)
        }
        
        if text.lowercased().contains("назад") || text.lowercased().contains("обратно") {
            resetSpeechRecognition()
            guard let region = pastLocation() else {return}
            let annotation = MKPointAnnotation()
            annotation.coordinate = region.center
            self.voiceChoiceHandler?(annotation)
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
    
    func createAlertMessage()-> (String, String) {
        let style = settingsManager.getSavedCommunicationStyle()
        switch style {
        case .formal:
            return ("Геопозиция выключена", "Хотите включить в настройках?")
        case .informal:
            return ("Геопозиция выключена", "Хочешь включить в настройках?")
        }
    }
    
    func makeNavigationTitle()-> String {
        if faculty != nil {
            return "Кафедра \(faculty?.abbreviation ?? "") №\(index)"
        } else {
            return "\(arr[index].title! ?? "") (\(index)/\(arr.count - 1))"
        }
    }
    
    func registerLocationHandler(block: @escaping(LocationModel)->Void) {
        self.locationHandler = block
    }
    
    func registerChoiceHandler(block: @escaping(Bool, MKAnnotation)->Void) {
        self.choiceHandler = block
    }
    
    func registerVoiceChoiceHandler(block: @escaping(MKAnnotation)->Void) {
        self.voiceChoiceHandler = block
    }
}
