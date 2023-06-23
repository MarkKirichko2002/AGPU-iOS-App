//
//  MapRealisationsListViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 19.06.2023.
//

import UIKit

class MapRealisationsListViewController: UIViewController {
    
    private var tableView = UITableView()
    var realisations = ["Карта №1", "Карта №2"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
}
