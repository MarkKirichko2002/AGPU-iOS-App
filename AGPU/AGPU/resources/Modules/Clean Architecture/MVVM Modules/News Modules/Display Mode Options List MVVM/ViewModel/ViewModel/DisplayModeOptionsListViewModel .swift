//
//  DisplayModeOptionsListViewModel .swift
//  AGPU
//
//  Created by Марк Киричко on 23.04.2024.
//

import Foundation

class DisplayModeOptionsListViewModel {
    
    var option = DisplayModes.grid
    var optionSelectedHandler: (()->Void)?
    
    // MARK: - Init
    init(option: DisplayModes) {
        self.option = option
    }
}
