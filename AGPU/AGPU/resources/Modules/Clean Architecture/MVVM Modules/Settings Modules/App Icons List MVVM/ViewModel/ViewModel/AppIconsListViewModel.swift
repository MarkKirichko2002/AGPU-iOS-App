//
//  AppIconsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 10.10.2023.
//

import Foundation

class AppIconsListViewModel {
    
    var faculty: AGPUFacultyModel?
    
    var dataChangedHandler: (()->Void)?
    var iconSelectedHandler: (()->Void)?
    var alertHandler: ((String, String)->Void)?
    
}
