//
//  FacultyCathedraListViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 25.07.2023.
//

import UIKit

protocol FacultyCathedraListViewModelProtocol {
    func cathedraListCount()-> Int
    func cathedraItem(index: Int)-> FacultyCathedraModel
    func SelectCathedra(index: Int)
    func isCathedraSelected(index: Int)-> UITableViewCell.AccessoryType
    func isCathedraSelectedColor(index: Int)-> UIColor
}
