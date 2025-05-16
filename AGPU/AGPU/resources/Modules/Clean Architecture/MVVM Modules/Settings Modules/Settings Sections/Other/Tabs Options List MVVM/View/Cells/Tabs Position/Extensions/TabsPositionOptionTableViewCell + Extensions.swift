//
//  TabsPositionOptionTableViewCell + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 29.04.2024.
//

import UIKit

// MARK: - SpringImageViewDelegate
extension TabsPositionOptionTableViewCell: SpringImageViewDelegate {
    
    func observeOption() {
        NotificationCenter.default.addObserver(forName: Notification.Name("option was selected"), object: nil, queue: .main) { _ in
            self.setPosition()
            self.displayPositionInfo()
        }
    }
    
    func imageWasTapped() {
        if counter < 3 {
            counter += 1
            displayPositionInfo()
        } else {
            counter = 0
            displayPositionInfo()
        }
    }
    
    func displayPositionInfo() {
        if counter >= 0 {
            TabsPositionOptionIcon.image = UIImage(named: numbers[counter])
            TabsPositionOptionName.text = tabs[counter].name
        }
    }
    
    func setPosition() {
        
        tabs = TabsList.tabs
        
        let position = settingsManager.getTabs()
        
        for tab in tabs {
            for savedTab in position {
                let index = tabs.firstIndex(of: tab)!
                tabs.swapAt(index, savedTab.position)
            }
        }
    }
}
