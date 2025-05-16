//
//  AllGroupsListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 04.08.2023.
//

import UIKit

protocol AllGroupsListTableViewControllerDelegate: AnyObject {
    func groupWasSelected(group: String)
}

final class AllGroupsListTableViewController: UIViewController {
    
    // MARK: - UI
    private let spinner: SpringImageView = {
        let imageView = SpringImageView()
        imageView.image = UIImage(named: "clock")
        imageView.tintColor = .label
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UINib(nibName: FacultyGroupTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: FacultyGroupTableViewCell.identifier)
        return tableView
    }()
    
    // MARK: - сервисы
    private var viewModel: AllGroupsListViewModel!
    private var animation = AnimationClass()
    
    private var group: String = ""
    weak var delegate: AllGroupsListTableViewControllerDelegate?
    
    // MARK: - Init
    init(group: String) {
        self.group = group
        self.viewModel = AllGroupsListViewModel(group: group)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTable()
        setUpIndicatorView()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        
        let titleView = CustomTitleView(image: "group", title: "Список групп", frame: .zero)
        
        let closebutton = UIBarButtonItem(image: UIImage(named: "cross"), style: .plain, target: self, action: #selector(closeScreen))
        closebutton.tintColor = .label
        let menu = viewModel.makeGroupsMenu()
        
        let sections = UIBarButtonItem(image: UIImage(named: "sections"), menu: menu)
        sections.accessibilityIdentifier =  "sections"
        sections.tintColor = .label
        
        navigationItem.titleView = titleView
        navigationItem.leftBarButtonItem = closebutton
        navigationItem.rightBarButtonItem = sections
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        self.dismiss(animated: true)
    }
    
    private func setUpIndicatorView() {
        view.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        self.spinner.isHidden = false
        self.animation.startRotateAnimation(view: self.spinner)
    }
    
    private func setUpTable() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func bindViewModel() {
        
        viewModel.registerScrollHandler { section, index in
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: index, section: section)
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
        
        viewModel.registerDataChangedHandler {
            DispatchQueue.main.async {
                self.setUpNavigation()
                self.spinner.isHidden = true
                self.animation.stopRotateAnimation(view: self.spinner)
                self.tableView.reloadData()
                self.tableView.isUserInteractionEnabled = false
                self.viewModel.scrollToSelectedGroup()
            }
        }
        
        viewModel.registerGroupSelectedHandler {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                self.dismiss(animated: true)
            }
        }
        
        viewModel.getGroups()
    }
    
    func checkScrollPosition() {
        if let indexPath = tableView.indexPathForRow(at: CGPoint(x: 0, y: tableView.contentOffset.y + 200)) {
            viewModel.group = viewModel.groups[indexPath.section].groups[0]
            navigationItem.rightBarButtonItems?.first(where: { $0.accessibilityIdentifier == "sections"})?.menu = viewModel.makeGroupsMenu()
        }
    }
}

// MARK: - UIScrollViewDelegate
extension AllGroupsListTableViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if tableView.isUserInteractionEnabled {
            checkScrollPosition()
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("прокрутка завершилась")
        HapticsManager.shared.hapticFeedback()
        tableView.isUserInteractionEnabled = true
    }
}

// MARK: - UITableViewDelegate
extension AllGroupsListTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 25))
        header.backgroundColor = .systemBackground
        header.layer.borderWidth = 3
        header.layer.borderColor = UIColor.label.cgColor
        header.layer.cornerRadius = 10
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        header.addSubview(label)
        label.text = viewModel.groups[section].facultyName.abbreviation()
        label.textColor = .label
        label.font = .systemFont(ofSize: 17, weight: .black)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: header.topAnchor, constant: 10),
            label.leftAnchor.constraint(equalTo: header.leftAnchor, constant: 20),
            label.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -10),
        ])
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectGroup(section: indexPath.section, index: indexPath.row)
        delegate?.groupWasSelected(group: viewModel.groupItem(section: indexPath.section, index: indexPath.row))
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension AllGroupsListTableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfGroupSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.groups[section].groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let groupSection = viewModel.groupSectionItem(section: indexPath.section)
        let group = viewModel.groupItem(section: indexPath.section, index: indexPath.row)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FacultyGroupTableViewCell.identifier, for: indexPath) as? FacultyGroupTableViewCell else {return UITableViewCell()}
        cell.tintColor = .systemGreen
        cell.GroupName.textColor = viewModel.isGroupSelected(section: indexPath.section, index: indexPath.row) ? .systemGreen : .label
        cell.accessoryType = viewModel.isGroupSelected(section: indexPath.section, index: indexPath.row) ? .checkmark : .none
        cell.configure(facultyIcon: self.viewModel.currentFacultyIcon(section: indexPath.section, abbreviation: groupSection.facultyName.abbreviation()), group: group)
        return cell
    }
}
