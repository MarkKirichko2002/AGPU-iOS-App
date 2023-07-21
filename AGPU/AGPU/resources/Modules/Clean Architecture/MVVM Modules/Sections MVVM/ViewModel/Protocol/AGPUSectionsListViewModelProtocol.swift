//
//  AGPUSectionsListViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 21.07.2023.
//

import Foundation

protocol AGPUSectionsListViewModelProtocol {
    func ObserveScroll(completion: @escaping(Int)->Void)
}
