//
//  TimetableDateDetailViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 24.02.2024.
//

import UIKit
import SnapKit

protocol TimetableDateDetailViewControllerDelegate: AnyObject {
    func dateWasSelected(model: TimeTableChangesModel)
}

class TimetableDateDetailViewController: UIViewController {
    
    let viewModel: TimetableDateDetailViewModel
    weak var delegate: TimetableDateDetailViewControllerDelegate?
    var id: String = ""
    var date: String = ""
    
    // MARK: - UI
    private var closeButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(named: "cross"), for: .normal)
        return button
    }()
    
    private var optionsList: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.showsMenuAsPrimaryAction = true
        button.setImage(UIImage(named: "sections"), for: .normal)
        return button
    }()
    
    private let timetableImage: UIImageView = {
        let image = UIImageView()
        image.isUserInteractionEnabled = true
        image.clipsToBounds = true
        image.layer.cornerRadius = 8
        image.layer.borderWidth = 2
        image.layer.borderColor = UIColor.label.cgColor
        return image
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Загрузка..."
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let timetableDescription: UILabel = {
        let label = UILabel()
        label.text = "Загрузка..."
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let selectDateButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.setTitle("Выбрать дату", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .black)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    // MARK: - Init
    init(id: String, date: String, owner: String) {
        self.id = id
        self.date = date
        self.viewModel = TimetableDateDetailViewModel(id: id, date: date, owner: owner)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpConstraints()
        bindViewModel()
    }
    
    private func setUpView() {
        view.backgroundColor = .systemBackground
        view.addSubviews(closeButton, optionsList, timetableImage, titleLabel, timetableDescription, selectDateButton)
        closeButton.addTarget(self, action: #selector(closeScreen), for: .touchUpInside)
        optionsList.menu = setUpMenu()
        selectDateButton.addTarget(self, action: #selector(selectDate), for: .touchUpInside)
        setUpTap()
        setUpPinchZoom()
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
    }
    
    private func setUpMenu()-> UIMenu {
        
        let searchAction = UIAction(title: "Поиск") { _ in
            let vc = TimeTableSearchListTableViewController()
            vc.delegate = self
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        let ARAction = UIAction(title: "AR режим") { _ in
            let vc = ARViewController()
            vc.image = self.timetableImage.image ?? UIImage()
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        let groupsList = UIAction(title: "Группы") { _ in
            let vc = AllGroupsListTableViewController(group: self.viewModel.id)
            vc.delegate = self
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        let subGroupsList = UIAction(title: "Подгруппы") { _ in
            let vc = SubGroupsListTableViewController(subgroup: self.viewModel.subgroup, disciplines: self.viewModel.allDisciplines)
            vc.delegate = self
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        let favouritesList = UIAction(title: "Избранное") { _ in
            let vc = TimeTableFavouriteItemsListTableViewController()
            vc.delegate = self
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        let filterAction = UIAction(title: "Фильтрация") { _ in
            let vc = PairTypesListTableViewController(date: self.date, type: self.viewModel.type, disciplines: self.viewModel.allDisciplines)
            vc.delegate = self
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        let saveTimetable = UIAction(title: "Сохранить") { _ in
            self.showSaveImageAlert()
        }
        
        let shareAction = UIAction(title: "Поделиться") { _ in
            self.share()
        }
        let menu = UIMenu(title: date, children: [
            searchAction,
            ARAction,
            groupsList,
            subGroupsList,
            favouritesList,
            filterAction,
            saveTimetable,
            shareAction
        ])
        return menu
    }
    
    @objc private func share() {
        guard let image = viewModel.image else {return}
        self.ShareImage(image: image, title: id, text: viewModel.formattedDate())
        HapticsManager.shared.hapticFeedback()
    }
    
    private func setUpTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(transformToStandard))
        timetableImage.addGestureRecognizer(tap)
    }
    
    private func setUpPinchZoom() {
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinch(_:)))
        timetableImage.addGestureRecognizer(pinch)
    }
    
    @objc func pinch(_ gesture: UIPinchGestureRecognizer) {
        if gesture.state == .changed {
            let scale = gesture.scale
            if scale < 1.3 && scale > 0.9 {
                UIView.animate(withDuration: 0.5) {
                    self.timetableImage.transform = CGAffineTransform(scaleX: scale, y: scale)
                }
            }
        }
    }
    
    @objc func transformToStandard() {
        UIView.animate(withDuration: 0.5) {
            self.timetableImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    private func setUpConstraints() {
        
        closeButton.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
            maker.right.equalToSuperview().inset(20)
        }
        
        optionsList.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
            maker.left.equalToSuperview().inset(20)
        }
        
        timetableImage.snp.makeConstraints { maker in
            maker.top.equalTo(optionsList.snp.bottom).offset(20)
            maker.centerX.equalToSuperview()
            maker.width.equalTo(250)
            maker.height.equalTo(250)
        }
        
        titleLabel.snp.makeConstraints { maker in
            maker.top.equalTo(timetableImage.snp.bottom).offset(50)
            maker.centerX.equalToSuperview()
        }
        
        timetableDescription.snp.makeConstraints { maker in
            maker.top.equalTo(titleLabel.snp.bottom).offset(50)
            maker.centerX.equalToSuperview()
        }
        
        selectDateButton.snp.makeConstraints { maker in
            maker.top.equalTo(timetableDescription.snp.bottom).offset(50)
            maker.centerX.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        viewModel.registerTimeTableHandler { [weak self] timetable in
            self?.timetableImage.image = timetable.image
            self?.titleLabel.text = timetable.id
            self?.timetableDescription.text = timetable.description
            self?.timetableDescription.textColor =  self?.viewModel.textColor()
            self?.timetableImage.layer.borderColor =  self?.viewModel.textColor().cgColor
        }
        viewModel.getTimeTableForDay()
    }
    
    @objc private func selectDate() {
        
        selectDateButton.layer.opacity = 0.5
        selectDateButton.setTitle("Выбрано", for: .normal)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [weak self] _ in
            guard let model = self?.viewModel.model else {return}
            self?.dismiss(animated: true)
            self?.delegate?.dateWasSelected(model: model)
        }
    }
}
