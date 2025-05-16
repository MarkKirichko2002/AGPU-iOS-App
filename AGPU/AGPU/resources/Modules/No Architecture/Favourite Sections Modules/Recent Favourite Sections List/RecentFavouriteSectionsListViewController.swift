//
//  RecentFavouriteSectionsListViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 24.02.2025.
//

import UIKit

final class RecentFavouriteSectionsListViewController: UIViewController {

    var sections = [ForEveryStatusModel]()
    
    // MARK: - сервисы
    let settingsManager = SettingsManager()
    
    let refreshControll = UIRefreshControl()
    let noSectionsLabel = UILabel()
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        setUpLabel()
        getData()
    }
    
    func setUpNavigation() {
        let titleView = CustomTitleView(image: "time.past", title: "Недавние", frame: .zero)
        navigationItem.titleView = titleView
        setUpCloseButton()
        setUpEditButton(title: "Править")
    }
    
    func setUpCloseButton() {
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .done, target: self, action: #selector(close))
        closeButton.tintColor = .label
        navigationItem.leftBarButtonItem = closeButton
    }
    
    @objc private func close() {
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
    }
    
    func setUpEditButton(title: String) {
        let moveButton = UIBarButtonItem(title: title, style: .done, target: self, action: #selector(moveActions))
        moveButton.tintColor = .label
        navigationItem.rightBarButtonItem = moveButton
    }
    
    func startEdit() {
        if !sections.isEmpty {
            tableView.isEditing = true
            setUpEditButton(title: "Готово")
        }
    }
    
    @objc func moveActions() {
        if !sections.isEmpty {
            if tableView.isEditing {
                setUpEditButton(title: "Править")
                tableView.isEditing = false
            } else {
                setUpEditButton(title: "Готово")
                tableView.isEditing = true
            }
        }
    }
    
    func setUpTable() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ForEveryStatusTableViewCell.self, forCellReuseIdentifier: ForEveryStatusTableViewCell.identifier)
    }
    
    private func setUpLabel() {
        view.addSubview(noSectionsLabel)
        noSectionsLabel.text = "Нет разделов"
        noSectionsLabel.font = .systemFont(ofSize: 18, weight: .medium)
        noSectionsLabel.isHidden = true
        noSectionsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noSectionsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noSectionsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func getData() {
        DispatchQueue.main.async {
            self.sections = self.loadRecentSections()
            self.tableView.reloadData()
            self.check()
        }
    }
    
    @objc func getRecentData() {
        let recentItems = loadRecentSections()
        if !recentItems.isEmpty {
            DispatchQueue.main.async {
                self.sections = recentItems
                self.tableView.reloadData()
                self.check()
                self.saveSections(sections: self.sections)
            }
        } else {
            showAlert(title: "Список пуст", message: "нет недавних разделов", actions: [UIAlertAction(title: "ОК", style: .default)])
        }
        refreshControll.endRefreshing()
    }
    
    func check() {
        if sections.isEmpty {
            noSectionsLabel.isHidden = false
        } else {
            noSectionsLabel.isHidden = true
        }
    }
    
    func loadRecentSections()-> [ForEveryStatusModel] {
        var data = [ForEveryStatusModel]()
        if let result = UserDefaults.standard.object(forKey: "recent sections") as? Data {
            do {
                data = try JSONDecoder().decode([ForEveryStatusModel].self, from: result)
            } catch {
                print(error)
            }
        }
        return data
    }
    
    func deleteAction(section: ForEveryStatusModel) {
        
        var sections = loadRecentSections()
        
        if let index = sections.firstIndex(where: { $0 == section }) {
            sections.remove(at: index)
        }
        
        if sections.isEmpty {
            setUpEditButton(title: "Править")
        }
        
        HapticsManager.shared.hapticFeedback()
        saveSections(sections: sections)
    }
    
    func saveSections(sections: [ForEveryStatusModel]) {
        do {
            let arr = try JSONEncoder().encode(sections)
            UserDefaults.standard.setValue(arr, forKey: "recent sections")
            getData()
        } catch {
            print(error)
        }
    }
    
    func updateSections(_ index: Int, _ index2: Int) {
        let section = sections.remove(at: index)
        sections.insert(section, at: index2)
        saveSections(sections: sections)
    }
}

// MARK: - UITableViewDelegate
extension RecentFavouriteSectionsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteAction(section: sections[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if tableView.isEditing {
            updateSections(sourceIndexPath.row, destinationIndexPath.row)
        }
    }
}

// MARK: - UITableViewDataSource
extension RecentFavouriteSectionsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ForEveryStatusTableViewCell.identifier, for: indexPath) as? ForEveryStatusTableViewCell else {return UITableViewCell()}
        cell.configure(for: sections[indexPath.row])
        return cell
    }
}
