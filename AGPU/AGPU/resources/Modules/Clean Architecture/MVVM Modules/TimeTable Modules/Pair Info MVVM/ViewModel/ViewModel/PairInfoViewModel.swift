//
//  PairInfoViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 23.10.2023.
//

import UIKit
import MapKit

final class PairInfoViewModel {
    
    var pairInfo = [String]()
    
    var backgroundColor = UIColor.systemBackground
    var currentColor = UIColor.label
    
    var pair: Discipline!
    var id: String = ""
    var date: String = ""
    
    var timer: Timer?
    var sound = UserDefaults.standard.object(forKey: "timetable sound") as? String ?? "clock_sound"
    var selectedType = MKDirectionsTransportType.walking
    
    var currentIndex: Int = -1
    
    var dataChangedHandler: (()->Void)?
    var alertHandler: ((Bool, String, String)->Void)?
    var colorHandler: ((UIColor)->Void)?
    var transportTypeHandler: (()->Void)?
    
    // MARK: - Init
    init(pair: Discipline, id: String, date: String) {
        self.pair = pair
        self.id = id
        self.date = date
    }
    
    // MARK: - сервисы
    let dateManager = DateManager()
    let locationManager = LocationManager()
    let settingsManager = SettingsManager()
    let speechRecognitionManager = SpeechRecognitionManager()
    let timetablePseudonymManager = TimetablePseudonymManager()
    
}
