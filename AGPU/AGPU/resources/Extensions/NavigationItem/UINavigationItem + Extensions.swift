//
//  UINavigationItem + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 02.03.2025.
//

import UIKit

extension UINavigationItem {
    
    func toggleRefreshButtonFromRight(on: Bool) {
        guard let next = self.rightBarButtonItems?.first(where: { $0.accessibilityIdentifier == "refresh button" }) else {return}
        next.isEnabled = on
    }
    
    func toggleRefreshButtonFromLeft(on: Bool) {
        guard let next = self.leftBarButtonItems?.first(where: { $0.accessibilityIdentifier == "refresh button" }) else {return}
        next.isEnabled = on
    }
    
    func toggleMenuButton(on: Bool) {
        guard let menu = self.rightBarButtonItems?.first(where: { $0.accessibilityIdentifier == "menu" }) else {return}
        menu.isEnabled = on
    }
}
