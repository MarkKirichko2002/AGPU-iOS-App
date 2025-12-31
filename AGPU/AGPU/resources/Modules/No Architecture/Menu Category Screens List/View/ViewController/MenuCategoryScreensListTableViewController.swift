//
//  MenuCategoryScreensListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 31.12.2025.
//

import UIKit

final class MenuCategoryScreensListTableViewController: UITableViewController {

    var category: MenuScreensCategoryModel
    
    init(category: MenuScreensCategoryModel) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
    }
    
    private func setUpNavigation() {
        let titleView = CustomTitleView(image: category.icon, title: category.name, frame: .zero)
        navigationItem.titleView = titleView
        setUpBackButton()
    }
    
    func setUpBackButton() {
        
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        let backButton = UIBarButtonItem(customView: button)
        
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setUpTable() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ScreenMenuOptionsListTableViewController(screen: category.screens[indexPath.row])
        vc.isSettings = true
        navigationController?.pushViewController(vc, animated: true)
        HapticsManager.shared.hapticFeedback()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.screens.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let screen = category.screens[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = screen.title
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .black)
        return cell
    }
}
