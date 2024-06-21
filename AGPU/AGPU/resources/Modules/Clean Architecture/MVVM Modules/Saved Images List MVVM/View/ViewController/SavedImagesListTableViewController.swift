//
//  SavedImagesListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 08.05.2024.
//

import UIKit

protocol SavedImagesListTableViewControllerDelegate: AnyObject {
    func dataUpdated()
}

protocol SavedImagesListTableViewControllerARDelegate: AnyObject {
    func screenWasClosed()
    func ARImageWasSelected(image: UIImage)
}

class SavedImagesListTableViewController: UIViewController {

    // MARK: - сервисы
    let viewModel = SavedImagesListViewModel()
    
    // MARK: - UI
    let tableView = UITableView()
    private let noImagesLabel = UILabel()
    
    weak var delegate: SavedImagesListTableViewControllerDelegate?
    weak var ARDelegate: SavedImagesListTableViewControllerARDelegate?
    
    var isOption = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        setUpLabel()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        
        let titleView = CustomTitleView(image: "photo icon", title: "Изображения", frame: .zero)
        
        navigationItem.titleView = titleView
        
        if isOption {
            setUpCloseButton()
        } else {
            setUpBackButton()
        }
        
        setUpAddButton()
    }
    
    func setUpCloseButton() {
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .done, target: self, action: #selector(close))
        closeButton.tintColor = .label
        navigationItem.leftBarButtonItem = closeButton
    }
    
    @objc private func close() {
        ARDelegate?.screenWasClosed()
        dismiss(animated: true)
        HapticsManager.shared.hapticFeedback()
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
    
    func setUpAddButton() {
        let addButton = UIBarButtonItem(image: UIImage(named: "add"), style: .done, target: self, action: #selector(addButtonTapped))
        addButton.tintColor = .label
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func addButtonTapped() {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        self.present(vc, animated: true)
    }
    
    private func setUpTable() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SavedImageTableViewCell.self, forCellReuseIdentifier: SavedImageTableViewCell.identifier)
    }
    
    private func setUpLabel() {
        view.addSubview(noImagesLabel)
        noImagesLabel.text = "Нет изображений"
        noImagesLabel.font = .systemFont(ofSize: 18, weight: .medium)
        noImagesLabel.isHidden = true
        noImagesLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noImagesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noImagesLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.registerDataChangedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            if !self.viewModel.images.isEmpty {
                self.noImagesLabel.isHidden = true
            } else {
                self.noImagesLabel.isHidden = false
            }
            self.delegate?.dataUpdated()
        }
        viewModel.getImages()
    }
}
