//
//  ButtonSettingsViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 12.06.2025.
//

import UIKit

final class ButtonSettingsManager {

    var timer: Timer?
    var screen: ASPUButtonScreens
    var view: UIView
    
    // MARK: - сервисы
    private let settingsManager = SettingsManager()
    
    init(screen: ASPUButtonScreens, view: UIView) {
        self.screen = screen
        self.view = view
    }
    
    func checkTimer() {
        let time = settingsManager.loadASPUButtonTime(title: screen.notificationName)
        let screens = settingsManager.loadASPUButtonScreens()
        if screens.contains(screen) && time > 0 {
            runTimer()
        }
    }
    
    func runTimer() {
        let time = settingsManager.loadASPUButtonTime(title: screen.notificationName)
        timer = Timer.scheduledTimer(withTimeInterval: Double(time), repeats: false) { _ in
            if let button = self.view.subviews.first(where: { $0.accessibilityIdentifier == "floating button" }) {
                self.checkButton(button: button)
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
    
    func checkButton(button: UIView) {
        switch screen {
        case .timetableDay:
            checkTimetableButton(button: button)
        case .timetableWeek:
            checkTimetableButton(button: button)
        case .newsList:
            checkMenuButton(button: button)
        case .newsWebPage:
            checkMenuButton(button: button)
        case .favouriteSections:
            button.isHidden = true
        }
    }
    
    func checkTimetableButton(button: UIView) {
        if let button = (button as? UIButton) {
            if (button.imageView?.image ?? UIImage()) == UIImage(named: "cross icon")! {
                self.runTimer()
            } else {
                button.isHidden = true
            }
        }
    }
    
    func checkMenuButton(button: UIView) {
        if (button as? UIButton)!.isHeld {
            self.runTimer()
        } else {
            button.isHidden = true
        }
    }
    
    func handleScroll() {
        if let button = self.view.subviews.first(where: { $0.accessibilityIdentifier == "floating button" }) {
            button.isHidden = false
        }
        stopTimer()
        checkTimer()
    }
}
