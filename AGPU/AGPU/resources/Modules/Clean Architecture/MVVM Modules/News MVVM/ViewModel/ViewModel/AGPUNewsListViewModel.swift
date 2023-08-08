//
//  AGPUNewsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 08.08.2023.
//

import Foundation

class AGPUNewsListViewModel {
    
    // MARK: - сервисы
    let newsService = AGPUNewsService()
    
    var news = [NewsModel]()
    
    var dataChangedHandler: ((AGPUFacultyModel)->Void)?
   
    var faculty: AGPUFacultyModel?
}
