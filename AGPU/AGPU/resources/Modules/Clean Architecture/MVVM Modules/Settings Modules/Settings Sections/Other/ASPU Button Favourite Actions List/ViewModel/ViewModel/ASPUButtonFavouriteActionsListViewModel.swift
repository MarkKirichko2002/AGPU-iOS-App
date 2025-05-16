//
//  ASPUButtonFavouriteActionsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 27.04.2024.
//

import Foundation

final class ASPUButtonFavouriteActionsListViewModel {
    
    var actions = [ASPUButtonActions]()
    var dataChangedHandler: (()->Void)?
    
}
