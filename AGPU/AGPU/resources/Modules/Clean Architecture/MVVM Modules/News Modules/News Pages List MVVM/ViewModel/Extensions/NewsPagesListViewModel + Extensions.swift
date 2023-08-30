//
//  NewsPagesListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 20.08.2023.
//

import Foundation

// MARK: - NewsPagesListViewModelProtocol
extension NewsPagesListViewModel: NewsPagesListViewModelProtocol {
    
    func setUpData() {
        let countPages = self.countPages
        for i in 1...countPages {
            pages.append(i)
        }
        self.dataChangedHandler?()
    }
    
    func registerPageSelectedHandler(block: @escaping((String)->Void)) {
        self.pageSelectedHandler = block
    }
    
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
    
    func pageItem(index: Int)-> String {
        let page = "страница \(pages[index])"
        return page
    }
    
    func numberOfPagesInSection()-> Int {
        return pages.count
    }
    
    func chooseNewsPage(index: Int) {
        let page = pages[index]
        if currentPage != page {
            NotificationCenter.default.post(name: Notification.Name("page"), object: page)
            currentPage = page
            self.dataChangedHandler?()
            self.pageSelectedHandler?("Выбрана страница \(page)")
            HapticsManager.shared.HapticFeedback()
        } else {
            self.pageSelectedHandler?("Страница \(page) уже выбрана")
        }
    }
    
    func isCurrentPage(index: Int)-> Bool {
        let page = pages[index]
        if page == currentPage {
            return true
        } else {
            return false
        }
    }
}
