//
//  TimeTableContainerViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 08.07.2025.
//

import UIKit

final class TimeTableContainerViewController: UIViewController {

    enum MenuState {
        case opened
        case closed
    }
    
    private var menuState: MenuState = .closed
    
    let timetableDayVC = TimeTableDayListTableViewController()
    var menuVC = TimetableMenuWeekDaysListViewController(id: "", currentDate: "", owner: "", week: WeekModel(id: 0, from: "", to: "", dayNames: [:]), edge: .all)
    var navVC: UINavigationController?
    var week = WeekModel(id: 0, from: "", to: "", dayNames: [:])
    var position = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        addChildVCs()
    }
    
    private func addChildVCs() {
        // Menu
        menuVC.delegate = self
        let menuNavVC = UINavigationController(rootViewController: menuVC)
        addChild(menuNavVC)
        view.addSubview(menuNavVC.view)
        menuNavVC.didMove(toParent: self)
        
        // Timetable Day
        timetableDayVC.delegate = self
        let navVC = UINavigationController(rootViewController: timetableDayVC)
        addChild(navVC)
        view.addSubview(navVC.view)
        navVC.didMove(toParent: self)
        self.navVC = navVC
    }
}

extension TimeTableContainerViewController: TimeTableDayListTableViewControllerDelegate {
    
    func didSwipeLeftEdge() {
        position = self.timetableDayVC.view.frame.width
        menuVC.currentWeek = timetableDayVC.currentWeek
        menuVC.edge = UIRectEdge.right
        toggleMenu()
    }
    
    func didSwipeRightEdge() {
        position = -(self.timetableDayVC.view.frame.width)
        menuVC.currentWeek = timetableDayVC.nextWeek()
        menuVC.edge = UIRectEdge.left
        toggleMenu()
    }
    
    func weekWasChanged(week: WeekModel) {
        self.week = week
        self.menuVC.id = timetableDayVC.id
        self.menuVC.currentDate = timetableDayVC.date
        self.menuVC.owner = timetableDayVC.owner
        self.menuVC.currentWeek = week
    }
    
    func toggleMenu() {
        switch menuState {
        case .closed:
            self.navVC?.view.frame.origin.x = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut) {
                
                self.navVC?.view.frame.origin.x = self.position
                
            } completion: { [weak self] done in
                if done {
                    self?.menuState = .opened
                }
            }
        case .opened:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut) {
                
                self.navVC?.view.frame.origin.x = 0
                
            } completion: { [weak self] done in
                if done {
                    self?.menuState = .closed
                }
            }
        }
    }
}

extension TimeTableContainerViewController: TimetableMenuWeekDaysListViewControllerDelegate {
    
    func dayWasSelected(day: DayModel) {
        timetableDayVC.getTimeTable(id: timetableDayVC.id, date: day.date, owner: timetableDayVC.owner) {
            self.toggleMenu()
        }
    }
    
    func menuWasSwiped() {
        toggleMenu()
    }
}
