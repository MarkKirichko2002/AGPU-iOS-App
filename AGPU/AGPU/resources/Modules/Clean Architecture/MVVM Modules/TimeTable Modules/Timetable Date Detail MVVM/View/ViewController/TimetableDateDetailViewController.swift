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

final class TimetableDateDetailViewController: UIViewController {
    
    let viewModel: TimetableDateDetailViewModel
    let imageSaver = ImageSaver()
    weak var delegate: TimetableDateDetailViewControllerDelegate?
    
    var id: String = ""
    var subgroup: Int = 0
    var date: String = ""
    var owner: String = ""
    
    // MARK: - UI
    private var closeButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(named: "cross"), for: .normal)
        return button
    }()
    
    var optionsList: UIButton = {
        let button = UIButton()
        button.accessibilityIdentifier = "button"
        button.tintColor = .label
        button.showsMenuAsPrimaryAction = true
        button.setImage(UIImage(named: "sections"), for: .normal)
        return button
    }()
    
    let timetableImage: UIImageView = {
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
        button.layer.opacity = 0.5
        button.isEnabled = false
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .black)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    // MARK: - Init
    init(id: String, subgroup: Int, date: String, owner: String) {
        self.id = id
        self.subgroup = subgroup
        self.date = date
        self.owner = owner
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
        imageSaver.registerImageHandler { title, message in
            self.showAlert(title: title, message: message, actions: [UIAlertAction(title: "ОК", style: .default)])
        }
    }
    
    private func setUpView() {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(openMenuSettings))
        swipe.direction = .up
        self.view.addGestureRecognizer(swipe)
        view.backgroundColor = .systemBackground
        view.addSubviews(closeButton, optionsList, timetableImage, titleLabel, timetableDescription, selectDateButton)
        closeButton.addTarget(self, action: #selector(closeScreen), for: .touchUpInside)
        optionsList.menu = setUpTimetableMenu()
        selectDateButton.addTarget(self, action: #selector(selectDate), for: .touchUpInside)
        optionsList.isEnabled = false
        setUpTap()
    }
    
    @objc private func openMenuSettings(gesture: UIGestureRecognizer) {
        let vc = ScreenMenuOptionsListTableViewController(screen: .timetableDate)
        vc.delegate = self
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
        HapticsManager.shared.hapticFeedback()
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
    }
    
    @objc func share() {
        guard let image = viewModel.image else {return}
        self.ShareImage(image: image, title: id, text: viewModel.formattedDate())
        HapticsManager.shared.hapticFeedback()
    }
    
    private func setUpTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(openFullImage))
        timetableImage.addGestureRecognizer(tap)
    }
    
    @objc func openFullImage() {
        let vc = ZoomImageViewController(image: timetableImage.image ?? UIImage())
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
        HapticsManager.shared.hapticFeedback()
    }
    
    private func setUpConstraints() {
        
        optionsList.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
            maker.right.equalToSuperview().inset(20)
        }
        
        closeButton.snp.makeConstraints { maker in
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
            maker.width.equalTo(130)
            maker.height.equalTo(30)
            maker.centerX.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        viewModel.registerTimeTableHandler { [weak self] timetable in
            self?.optionsList.isEnabled = true
            self?.timetableImage.image = timetable.image
            self?.titleLabel.text = timetable.id
            self?.timetableDescription.text = timetable.description
            self?.timetableDescription.textColor =  self?.viewModel.textColor()
            self?.timetableImage.layer.borderColor =  self?.viewModel.textColor().cgColor
            self?.selectDateButton.layer.opacity = 1.0
            self?.selectDateButton.isEnabled = true
        }
        viewModel.getTimeTableForDay()
    }
    
    @objc private func selectDate() {
        
        selectDateButton.layer.opacity = 0.5
        selectDateButton.setTitle("Выбрано", for: .normal)
        optionsList.isEnabled = false
        closeButton.isEnabled = false
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [weak self] _ in
            guard let model = self?.viewModel.model else {return}
            self?.dismiss(animated: true)
            self?.delegate?.dateWasSelected(model: model)
        }
    }
    
    func openFilterOptionsList() {
        let vc = TimetableFilterCategoriesListTableViewController(date: date, type: viewModel.type, disciplines: viewModel.allDisciplines, building: viewModel.currentBuilding, time: nil)
        vc.delegate = self
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true)
    }
}

