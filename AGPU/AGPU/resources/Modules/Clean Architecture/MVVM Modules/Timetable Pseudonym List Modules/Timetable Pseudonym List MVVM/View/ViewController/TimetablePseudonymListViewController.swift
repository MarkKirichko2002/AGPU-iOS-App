//
//  TimetablePseudonymListViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 14.10.2025.
//

import UIKit

protocol TimetablePseudonymListViewControllerDelegate: AnyObject {
    func listWasChanged()
}

final class TimetablePseudonymListViewController: UIViewController {
    
    // MARK: - сервисы
    let viewModel: TimetablePseudonymListViewModel
    
    // MARK: - UI
    let tableView = UITableView()
    let noAbbreviationsLabel = UILabel()
    
    weak var delegate: TimetablePseudonymListViewControllerDelegate?
    
    init(category: TimetablePseudonymCategories) {
        self.viewModel = TimetablePseudonymListViewModel(category: category)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        setUpLabel()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        let titleView = CustomTitleView(image: viewModel.category.icon, title: viewModel.category.rawValue, frame: .zero)
        navigationItem.titleView = titleView
        setUpBackButton()
        setUpEditButton(title: "Править")
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
    
    func setUpEditButton(title: String) {
        let moveButton = UIBarButtonItem(title: title, style: .done, target: self, action: #selector(moveActions))
        moveButton.tintColor = .label
        navigationItem.rightBarButtonItem = moveButton
    }
    
    @objc func moveActions() {
        if !viewModel.pseudonyms.isEmpty {
            if tableView.isEditing {
                setUpEditButton(title: "Править")
                tableView.isEditing = false
            } else {
                setUpEditButton(title: "Готово")
                tableView.isEditing = true
            }
        }
    }
    
    private func setUpTable() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.frame = view.bounds
    }
    
    private func setUpLabel() {
        view.addSubview(noAbbreviationsLabel)
        noAbbreviationsLabel.text = "Нет псевдонимов"
        noAbbreviationsLabel.font = .systemFont(ofSize: 18, weight: .medium)
        noAbbreviationsLabel.isHidden = true
        noAbbreviationsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noAbbreviationsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noAbbreviationsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.registerDataChangedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            if !self.viewModel.pseudonyms.isEmpty {
                self.noAbbreviationsLabel.isHidden = true
            } else {
                self.noAbbreviationsLabel.isHidden = false
            }
        }
        viewModel.registerItemChangedHandler { index in
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .left)
            }
            self.delegate?.listWasChanged()
        }
        viewModel.getPseudonyms()
    }
}
