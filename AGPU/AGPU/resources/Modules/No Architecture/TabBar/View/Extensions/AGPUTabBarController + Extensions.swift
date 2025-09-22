//
//  AGPUTabBarController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 18.11.2023.
//

import UIKit
import MapKit

extension AGPUTabBarController: ASPUButtonFavouriteActionsListTableViewControllerDelegate {

    func actionWasSelected(action: ASPUButtonActions) {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            self.handleAction(action: action)
        }
    }
    
    func handleAction(action: ASPUButtonActions) {
        switch action {
        case .speechRecognition:
            ASPUButton.removeTarget(nil, action: nil, for: .allEvents)
            ASPUButton.addTarget(self, action: #selector(openVoiceCommands), for: .touchUpInside)
            openVoiceCommands(isAction: false)
        case .timetableWeeks:
            ASPUButton.removeTarget(nil, action: nil, for: .allEvents)
            ASPUButton.addTarget(self, action: #selector(openFavouritesList), for: .touchUpInside)
            openWeeksTimetable()
        case .campusMap:
            ASPUButton.removeTarget(nil, action: nil, for: .allEvents)
            ASPUButton.addTarget(self, action: #selector(openFavouritesList), for: .touchUpInside)
            openCampusMap()
        case .studyPlan:
            ASPUButton.removeTarget(nil, action: nil, for: .allEvents)
            ASPUButton.addTarget(self, action: #selector(openFavouritesList), for: .touchUpInside)
            openStudyPlan()
        case .profile:
            ASPUButton.removeTarget(nil, action: nil, for: .allEvents)
            ASPUButton.addTarget(self, action: #selector(openFavouritesList), for: .touchUpInside)
            openProfile()
        case .manual:
            ASPUButton.removeTarget(nil, action: nil, for: .allEvents)
            ASPUButton.addTarget(self, action: #selector(openFavouritesList), for: .touchUpInside)
            openManual()
        case .sections:
            ASPUButton.removeTarget(nil, action: nil, for: .allEvents)
            ASPUButton.addTarget(self, action: #selector(openFavouritesList), for: .touchUpInside)
            openSectionsList()
        case .recent:
            ASPUButton.removeTarget(nil, action: nil, for: .allEvents)
            ASPUButton.addTarget(self, action: #selector(openFavouritesList), for: .touchUpInside)
            openRecentMoments()
        case .weather:
            ASPUButton.removeTarget(nil, action: nil, for: .allEvents)
            ASPUButton.addTarget(self, action: #selector(openFavouritesList), for: .touchUpInside)
            openWeatherVC()
        case .things:
            ASPUButton.removeTarget(nil, action: nil, for: .allEvents)
            ASPUButton.addTarget(self, action: #selector(openFavouritesList), for: .touchUpInside)
            openThingsCategoriesList()
        case .whatsNew:
            ASPUButton.removeTarget(nil, action: nil, for: .allEvents)
            ASPUButton.addTarget(self, action: #selector(openFavouritesList), for: .touchUpInside)
            openWhatsNew()
        case .nearestBuilding:
            ASPUButton.removeTarget(nil, action: nil, for: .allEvents)
            ASPUButton.addTarget(self, action: #selector(openFavouritesList), for: .touchUpInside)
            showNearestBuilding(isAction: false)
        case .appThemes:
            ASPUButton.removeTarget(nil, action: nil, for: .allEvents)
            ASPUButton.addTarget(self, action: #selector(openFavouritesList), for: .touchUpInside)
            openAppThemes()
        case .appShortcuts:
            ASPUButton.removeTarget(nil, action: nil, for: .allEvents)
            ASPUButton.addTarget(self, action: #selector(openFavouritesList), for: .touchUpInside)
            openAppShortcuts()
        case .favourite:
            break
        }
    }
    
    // изменение ASPU Button
    func updateASPUButton(icon: String) {
        let option = settingsManager.checkASPUButtonAnimationOption()
        DispatchQueue.main.async {
            if !self.ASPUButton.isHidden {
                self.ASPUButton.setImage(UIImage(named: icon), for: .normal)
                switch option {
                case .spring:
                    self.animation.springAnimation(view: self.ASPUButton)
                    HapticsManager.shared.hapticFeedback()
                case .flipFromTop:
                    self.animation.flipAnimation(view: self.ASPUButton, option: .transitionFlipFromTop) {
                        HapticsManager.shared.hapticFeedback()
                    }
                case .flipFromRight:
                    self.animation.flipAnimation(view: self.ASPUButton, option: .transitionFlipFromRight) {
                        HapticsManager.shared.hapticFeedback()
                    }
                case .flipFromLeft:
                    self.animation.flipAnimation(view: self.ASPUButton, option: .transitionFlipFromLeft) {
                        HapticsManager.shared.hapticFeedback()
                    }
                case .flipFromBottom:
                    self.animation.flipAnimation(view: self.ASPUButton, option: .transitionFlipFromBottom) {
                        HapticsManager.shared.hapticFeedback()
                    }
                case .none:
                    HapticsManager.shared.hapticFeedback()
                }
            }
        }
    }
}

// MARK: - UIContextMenuInteractionDelegate
extension AGPUTabBarController: UIContextMenuInteractionDelegate {
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint)-> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil,
                                          actionProvider: {
                _ in
            
            return self.checkTab(view: interaction.view)
        })
    }
    
    func checkTab(view: UIView?)-> UIMenu? {
        let title = view?.accessibilityIdentifier
        let savedActions = settingsManager.getTabOptions(title: title!)
        let variant = settingsManager.checkOnlyMainOption()
        if variant == .custom {
            if !savedActions.isEmpty || title == "web sections" || title == "maps" || title == "weeks" || title == "weather" || title == "building" {
                return makeMenu(view: view)
            } else {
                let vc = HintViewController(info: "Нужно добавить действия для вкладки \"\(title!.getCurrentTabName())\" в настройках панели вкладок.")
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
        } else {
            return makeMenu(view: view)
        }
        return nil
    }
    
    func makeMenu(view: UIView?)-> UIMenu? {
        let title = view?.accessibilityIdentifier
        let main = settingsManager.checkOnlyMainOption()
        if main == .custom {
            return makeCustomContextMenu(title: title!)
        } else {
            return makeContextMenu(title: title!)
        }
    }
    
    func makeCustomContextMenu(title: String)-> UIMenu {
        let savedFont = settingsManager.getTabFont(title: title)
        let savedColor = settingsManager.getTabsColor()
        let savedActions = settingsManager.getTabOptions(title: title)
        var actions = [UIAction]()
        if title == "web sections" {
            actions = makeSectionsOptions()
        } else if title == "maps" {
            actions = makeMapsOptions()
        } else if title == "weeks" {
            actions = makeWeeksOptions()
        } else if title == "weather" {
            actions = makeWeatherOptions()
        } else if title == "building" {
            actions = makeBuildingOptions()
        } else {
            actions = savedActions.map { findAction(category: title, action: $0) }
        }
        if savedFont != .none {
            let font = UIFont(name: savedFont.rawValue, size: 15)!
            actions.forEach { $0.setValue(NSAttributedString(string: $0.title, attributes: [.font: font, .foregroundColor: savedColor.color]), forKey: "attributedTitle") }
            actions.forEach { $0.image = $0.image?.withTintColor(savedColor.color, renderingMode: .automatic)}
        }
        return UIMenu(title: title.getCurrentTabName(), children: actions)
    }
    
    func makeContextMenu(title: String)-> UIMenu? {
        if title == "news" {
            return UIMenu(title: "Новости", children: makeNewsOptions())
        } else if title == "timetable" {
            return UIMenu(title: "Расписание", children: makeTimetableOptions())
        } else if title == "maps" {
            return UIMenu(title: "Карты", children: makeMapsOptions())
        } else if title == "settings" {
            return UIMenu(title: "Настройки", children: makeSettingsOptions())
        } else if title == "web sections" {
            return UIMenu(title: "Разделы сайта", children: makeSectionsOptions())
        }
        return nil
    }
}

// MARK: - ScreenClosedDelegate
extension AGPUTabBarController: ScreenClosedDelegate {
    
    func screenWasClosed() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            self.updateASPUButton(icon: self.settingsManager.checkCurrentIcon())
        }
    }
}

extension AGPUTabBarController {
    
    func makeNewsOptions()-> [UIAction] {
        
        let todayNews = UIAction(title: "Новости за сегодня", image: UIImage(named: "calendar")) { _ in
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                self.newsVC.showWhatsNewVC()
            }
        }
        
        let categoriesAction = UIAction(title: "Список категорий", image: UIImage(named: "mail")) { _ in
            if let index = self.tabBar.subviews.firstIndex(where: { $0.accessibilityIdentifier == "news"}) {
                self.selectedIndex = index - 1
                UserDefaults.standard.setValue(self.selectedIndex, forKey: "index")
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                    self.newsVC.openNewsCategoriesList()
                }
            }
        }
        
        let pagesAction = UIAction(title: "Список страниц", image: UIImage(named: "number")) { _ in
            if let index = self.tabBar.subviews.firstIndex(where: { $0.accessibilityIdentifier == "news"}) {
                self.selectedIndex = index - 1
                UserDefaults.standard.setValue(self.selectedIndex, forKey: "index")
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                    self.newsVC.openNewsPagesList()
                }
            }
        }
        
        let randomAction = UIAction(title: "Рандомайзер", image: UIImage(named: "dice")) { _ in
            if let index = self.tabBar.subviews.firstIndex(where: { $0.accessibilityIdentifier == "news"}) {
                self.selectedIndex = index - 1
                UserDefaults.standard.setValue(self.selectedIndex, forKey: "index")
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                    self.newsVC.openRandom()
                }
            }
        }
        
        let filterAction = UIAction(title: "Фильтрация", image: UIImage(named: "filter")) { _ in
            if let index = self.tabBar.subviews.firstIndex(where: { $0.accessibilityIdentifier == "news"}) {
                self.selectedIndex = index - 1
                UserDefaults.standard.setValue(self.selectedIndex, forKey: "index")
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                    self.newsVC.openFilterOptionsList()
                }
            }
        }
        return [todayNews, categoriesAction, pagesAction, randomAction, filterAction]
    }
    
    func makeFavouriteOptions()-> [UIAction] {
        
        let addSection = UIAction(title: "Добавить раздел", image: UIImage(named: "add")) { _ in
            if let index = self.tabBar.subviews.firstIndex(where: { $0.accessibilityIdentifier == "sections"}) {
                self.selectedIndex = index - 1
                UserDefaults.standard.setValue(self.selectedIndex, forKey: "index")
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                    self.sectionsListVC.addButtonTapped()
                }
            }
        }
        
        let changeSections = UIAction(title: "Изменить порядок", image: UIImage(named: "number")) { _ in
            if let index = self.tabBar.subviews.firstIndex(where: { $0.accessibilityIdentifier == "sections"}) {
                self.selectedIndex = index - 1
                UserDefaults.standard.setValue(self.selectedIndex, forKey: "index")
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                    self.sectionsListVC.startEdit()
                }
            }
        }
        return [addSection, changeSections]
    }
    
    func makeTimetableOptions()-> [UIAction] {
        
        let calendar = UIAction(title: "Календарь", image: UIImage(named: "calendar")) { _ in
            if let index = self.tabBar.subviews.firstIndex(where: { $0.accessibilityIdentifier == "timetable"}) {
                self.selectedIndex = index - 1
                UserDefaults.standard.setValue(self.selectedIndex, forKey: "index")
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                    self.timetableContainerVC.timetableDayVC.openCalendar()
                }
            }
        }
        
        let weeksList = UIAction(title: "Список недель", image: UIImage(named: "clock")) { _ in
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                let vc = AllWeeksListTableViewController(id: self.settingsManager.getSavedID(), subgroup: self.settingsManager.getSavedSubgroup(), owner: self.settingsManager.getSavedOwner())
                let navVC = UINavigationController(rootViewController: vc)
                navVC.modalPresentationStyle = .fullScreen
                self.present(navVC, animated: true)
            }
        }
        
        let daysList = UIAction(title: "Список дней", image: UIImage(named: "sections")) { _ in
            if let index = self.tabBar.subviews.firstIndex(where: { $0.accessibilityIdentifier == "timetable"}) {
                self.selectedIndex = index - 1
                UserDefaults.standard.setValue(self.selectedIndex, forKey: "index")
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                    self.timetableContainerVC.timetableDayVC.openDaysList()
                }
            }
        }
        
        let favouritesList = UIAction(title: "Избранное", image: UIImage(named: "star")) { _ in
            if let index = self.tabBar.subviews.firstIndex(where: { $0.accessibilityIdentifier == "timetable"}) {
                self.selectedIndex = index - 1
                UserDefaults.standard.setValue(self.selectedIndex, forKey: "index")
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                    self.timetableContainerVC.timetableDayVC.openFavouritesList()
                }
            }
        }
        
        let searchAction = UIAction(title: "Поиск", image: UIImage(named: "search")) { _ in
            if let index = self.tabBar.subviews.firstIndex(where: { $0.accessibilityIdentifier == "timetable"}) {
                self.selectedIndex = index - 1
                UserDefaults.standard.setValue(self.selectedIndex, forKey: "index")
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                    self.timetableContainerVC.timetableDayVC.openSearch()
                }
            }
        }
        
        return [calendar, weeksList, daysList, favouritesList, searchAction]
    }
    
    func makeMapsOptions()-> [UIAction] {
        let nearBuilding = UIAction(title: "Нужное здание", image: UIImage(named: "marker")) { _ in
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                let vc = NearBuildingViewController(info: .map)
                vc.screenDelegate = self
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
        }
        return [nearBuilding]
    }
    
    func makeSettingsOptions()-> [UIAction] {
        let newsOptions = UIAction(title: "Новости", image: UIImage(named: "mail")) { _ in
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                self.settingsVC.openNewsSettings()
            }
        }
        let timetableOptions = UIAction(title: "Расписание", image: UIImage(named: "time icon")) { _ in
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                self.settingsVC.openTimetableSettings()
            }
        }
        let tabsOptions = UIAction(title: "Панель вкладок", image: UIImage(named: "applicant")) { _ in
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                self.settingsVC.openTabBarSettings()
            }
        }
        let themesAction = UIAction(title: "Темы приложения", image: UIImage(named: "theme")) { _ in
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                self.settingsVC.openAppThemes()
            }
        }
        let aspuButton = UIAction(title: "АГПУ кнопка", image: UIImage(named: "button")) { _ in
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                self.settingsVC.openASPUButtonSettings()
            }
        }
        
        let shortcutAction = UIAction(title: "Шорткаты приложения", image: UIImage(named: "sections")) { _ in
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                self.settingsVC.openAppShortcuts()
            }
        }
        return [newsOptions, timetableOptions, tabsOptions, themesAction, aspuButton, shortcutAction]
    }
    
    func makeSectionsOptions()-> [UIAction] {
        let actions = AGPUSections.sections.map { section in
            UIAction(title: section.name, image: UIImage(named: section.icon)) { _ in
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                    self.goToWeb(url: section.url, image: section.icon, title: section.name, isSheet: false, isNotify: false)
                }
          }
        }
        return actions
    }
    
    func makeWeeksOptions()-> [UIAction] {
        let refresh = UIAction(title: "Обновить", image: UIImage(named: "refresh")) { _ in
            if let index = self.tabBar.subviews.firstIndex(where: { $0.accessibilityIdentifier == "weeks"}) {
                self.selectedIndex = index - 1
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                    ((self.viewControllers?[2] as? UINavigationController)?.viewControllers.first as? AllWeeksListTableViewController)?.refreshWeeks()
                }
            }
        }
        return [refresh]
    }
    
    func makeWeatherOptions()-> [UIAction] {
        let refresh = UIAction(title: "Обновить", image: UIImage(named: "refresh")) { _ in
            if let index = self.tabBar.subviews.firstIndex(where: { $0.accessibilityIdentifier == "weather"}) {
                self.selectedIndex = index - 1
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                    ((self.viewControllers?[2] as? UINavigationController)?.viewControllers.first as? LocationWeatherDetailViewController)?.refreshWeather()
                }
            }
        }
        return [refresh]
    }
    
    func makeBuildingOptions()-> [UIAction] {
        let refresh = UIAction(title: "Поделиться", image: UIImage(named: "share")) { _ in
            if let index = self.tabBar.subviews.firstIndex(where: { $0.accessibilityIdentifier == "building"}) {
                self.selectedIndex = index - 1
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                    (self.viewControllers?[2] as? NearBuildingViewController)?.shareBuilding()
                }
            }
        }
        return [refresh]
    }
    
    func findAction(category: String, action: TabOptionModel)-> UIAction  {
        let originalActions = TabOptionsSections.sections.first { $0.title == category }!
        let searchAction = originalActions.options.first(where: { $0.id == action.id })!
        let allActions = makeNewsOptions() + makeFavouriteOptions() + makeTimetableOptions() + makeSettingsOptions() + makeSectionsOptions()
        let item = allActions.first { $0.title == searchAction.title }!
        item.title = action.title
        return item
    }
    
    // MARK: - Action To Get
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if !self.tabBar.isHidden {
            checkActionToControl()
        }
    }
    
    @objc func openRecentMoments() {
       let vc = RecentMomentsListTableViewController()
       if !ASPUButton.isHidden {
            vc.isNotify = true
            vc.delegate = self
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.updateASPUButton(icon: "time.past")
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                self.present(navVC, animated: true)
            }
        } else {
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
   }
   
   @objc func openWeatherVC() {
       let annotation = MKPointAnnotation()
       annotation.title = "Армавир"
       annotation.coordinate = CLLocationCoordinate2D(latitude: 44.9892, longitude: 41.1234)
       let vc = LocationWeatherDetailViewController(annotation: annotation)
       vc.isNotify = true
       vc.delegate = self
       let navVC = UINavigationController(rootViewController: vc)
       navVC.modalPresentationStyle = .fullScreen
       if !ASPUButton.isHidden {
           self.updateASPUButton(icon: "sun")
           Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
               self.present(navVC, animated: true)
           }
       } else {
           self.present(navVC, animated: true)
       }
   }
   
   @objc func openWhatsNew() {
       let vc = TodayNewsListTableViewController()
       let navVC = UINavigationController(rootViewController: vc)
       let style = UserDefaults.loadData(type: ScreenPresentationStyles.self, key: "screen presentation style") ?? .notShow
       switch style {
       case .fullScreen:
           navVC.modalPresentationStyle = .fullScreen
           if !ASPUButton.isHidden {
               vc.isNotify = true
               vc.delegate = self
               self.updateASPUButton(icon: "question")
               Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                   self.present(navVC, animated: true)
               }
           } else {
               self.present(navVC, animated: true)
           }
       case .sheet:
           navVC.modalPresentationStyle = .pageSheet
           if !ASPUButton.isHidden {
               vc.isNotify = true
               vc.delegate = self
               self.updateASPUButton(icon: "question")
               Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                   self.present(navVC, animated: true)
               }
           } else {
               self.present(navVC, animated: true)
           }
       case .notShow:
           let vc = HintViewController(info: "Чтобы увидеть экран, нужно выбрать его отображение в настройках опции \"Наглядные изменения\"")
           vc.modalPresentationStyle = .fullScreen
           if !ASPUButton.isHidden {
               vc.isNotify = true
               vc.delegate = self
               self.updateASPUButton(icon: "info icon")
               Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                   self.present(navVC, animated: true)
               }
           } else {
               self.present(navVC, animated: true)
           }
       }
   }
   
   @objc func showNearestBuilding(isAction: Bool) {
       let vc = NearBuildingViewController(info: .map)
       vc.isAction = isAction
       vc.screenDelegate = self
       vc.modalPresentationStyle = .fullScreen
       if !ASPUButton.isHidden {
           self.updateASPUButton(icon: "marker icon")
           Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
               self.present(vc, animated: true)
           }
       } else {
           self.present(vc, animated: true)
       }
   }
   
   @objc func openVoiceCommands(isAction: Bool) {
       let vc = VoiceCommandsViewController()
       vc.isAction = isAction
       vc.delegate = self
       vc.modalPresentationStyle = .fullScreen
       if !ASPUButton.isHidden {
           self.updateASPUButton(icon: "microphone")
           Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
               self.present(vc, animated: true)
           }
       } else {
           self.present(vc, animated: true)
       }
   }
   
   @objc func openAppThemes() {
       let vc = AppThemesListTableViewController()
       vc.modalPresentationStyle = .fullScreen
       vc.delegate = self
       let navVC = UINavigationController(rootViewController: vc)
       navVC.modalPresentationStyle = .fullScreen
       if !ASPUButton.isHidden {
           self.updateASPUButton(icon: "theme")
           Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
               self.present(navVC, animated: true)
           }
       } else {
           self.present(navVC, animated: true)
       }
   }
   
   @objc func openAppShortcuts() {
       let vc = FavouriteShortcutsListTableViewController()
       vc.modalPresentationStyle = .fullScreen
       vc.screenDelegate = self
       let navVC = UINavigationController(rootViewController: vc)
       navVC.modalPresentationStyle = .fullScreen
       if !ASPUButton.isHidden {
           self.updateASPUButton(icon: "sections icon")
           Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
               self.present(navVC, animated: true)
           }
       } else {
           self.present(navVC, animated: true)
       }
   }
   
   @objc func openWeeksTimetable() {
       let id = UserDefaults.standard.string(forKey: "group") ?? "ВМ-ИВТ-4-1"
       let subgroup = UserDefaults.standard.integer(forKey: "subgroup")
       let owner = UserDefaults.standard.string(forKey: "recentOwner") ?? "GROUP"
       let vc = AllWeeksListTableViewController(id: id, subgroup: subgroup, owner: owner)
       vc.isNotify = true
       vc.screenDelegate = self
       let navVC = UINavigationController(rootViewController: vc)
       navVC.modalPresentationStyle = .fullScreen
       if !ASPUButton.isHidden {
           self.updateASPUButton(icon: "clock")
           Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
               self.present(navVC, animated: true)
           }
       } else {
           self.present(navVC, animated: true)
       }
   }
   
   @objc func openCampusMap() {
       let vc = AGPUBuildingsMapViewController()
       vc.isAction = true
       vc.isNotify = true
       vc.delegate = self
       let navVC = UINavigationController(rootViewController: vc)
       navVC.modalPresentationStyle = .fullScreen
       if !ASPUButton.isHidden {
           self.updateASPUButton(icon: "map icon")
           Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
               self.present(navVC, animated: true)
           }
       } else {
           self.present(navVC, animated: true)
       }
   }
    
    func openTimetableSearch() {
        let index = tabBar.subviews.firstIndex { $0.accessibilityIdentifier == "timetable" } ?? 0
        selectedIndex = index - 1
        UserDefaults.standard.setValue(selectedIndex, forKey: "index")
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            self.timetableContainerVC.timetableDayVC.openSearch()
        }
    }
    
    func openScheduleDaysVC() {
        let index = tabBar.subviews.firstIndex { $0.accessibilityIdentifier == "timetable" } ?? 0
        selectedIndex = index - 1
        UserDefaults.standard.setValue(selectedIndex, forKey: "index")
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            self.timetableContainerVC.timetableDayVC.openDaysList()
        }
    }
    
    func openCalendarVC() {
        let index = tabBar.subviews.firstIndex { $0.accessibilityIdentifier == "timetable" } ?? 0
        selectedIndex = index - 1
        UserDefaults.standard.setValue(selectedIndex, forKey: "index")
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            self.timetableContainerVC.timetableDayVC.openCalendar()
        }
    }
   
   @objc func openStudyPlan() {
       self.updateASPUButton(icon: "student")
       Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
           self.openWeb(url: "http://plany.agpu.net/Plans/", image: "student", title: "Учебный план", delegate: self)
       }
   }
   
   @objc func openProfile() {
       self.updateASPUButton(icon: "profile icon")
       Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
           self.openWeb(url: "http://plany.agpu.net/WebApp/#/", image: "profile icon", title: "ЭИОС", delegate: self)
       }
   }
   
   @objc func openManual() {
       if let cathedra = UserDefaults.loadData(type: FacultyCathedraModel.self, key: "cathedra") {
           self.updateASPUButton(icon: "book")
           Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
               self.openWeb(url: cathedra.manualUrl, image: "book", title: "Метод. материалы", delegate: self)
           }
       } else {
           self.showHintAlert(type: .manuals, isNotify: true, delegate: self)
           HapticsManager.shared.hapticFeedback()
       }
   }
   
   @objc func openSectionsList() {
       let vc = ASPUWebsiteSectionsListViewController()
       vc.isAction = true
       vc.delegate = self
       let navVC = UINavigationController(rootViewController: vc)
       navVC.modalPresentationStyle = .fullScreen
       if !ASPUButton.isHidden {
           self.updateASPUButton(icon: "online")
           Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
               self.present(navVC, animated: true)
           }
       } else {
           present(navVC, animated: true)
       }
   }
   
   @objc func openFavouritesList() {
       let vc = ASPUButtonFavouriteActionsListTableViewController()
       vc.delegate = self
       vc.screenDelegate = self
       let navVC = UINavigationController(rootViewController: vc)
       navVC.modalPresentationStyle = .fullScreen
       if !ASPUButton.isHidden {
           self.updateASPUButton(icon: "star")
           Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
               self.present(navVC, animated: true)
           }
       } else {
           self.present(navVC, animated: true)
       }
   }
   
   @objc func openThingsCategoriesList() {
       let vc = ThingsCategoriesListTableViewController()
       vc.isAction = true
       vc.delegate = self
       let navVC = UINavigationController(rootViewController: vc)
       navVC.modalPresentationStyle = .fullScreen
       if !ASPUButton.isHidden {
           self.updateASPUButton(icon: "exclamation")
           Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
               self.present(navVC, animated: true)
           }
       } else {
           self.present(navVC, animated: true)
       }
   }
}
