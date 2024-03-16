//
//  TimetableDateDetailViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 24.02.2024.
//

import UIKit
import SnapKit

protocol TimetableDateDetailViewControllerDelegate: AnyObject {
    func dateWasSelected(date: String)
}

class TimetableDateDetailViewController: UIViewController {
    
    let viewModel: TimetableDateDetailViewModel
    weak var delegate: TimetableDateDetailViewControllerDelegate?
    var date: String = ""
    
    // MARK: - UI
    private var closeButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(named: "cross"), for: .normal)
        return button
    }()
    
    private let timetableImage: UIImageView = {
        let image = UIImageView()
        image.isUserInteractionEnabled = true
        image.backgroundColor = .label
        return image
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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bindViewModel()
    }
    
    private func setUpView() {
        view.backgroundColor = .systemBackground
        view.addSubviews(closeButton, timetableImage, timetableDescription, selectDateButton)
        closeButton.addTarget(self, action: #selector(closeScreen), for: .touchUpInside)
        selectDateButton.addTarget(self, action: #selector(selectDate), for: .touchUpInside)
        setUpTap()
        setUpPinchZoom()
    }
    
    @objc private func closeScreen() {
        dismiss(animated: true)
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
            maker.top.equalToSuperview().inset(60)
            maker.right.equalToSuperview().inset(20)
        }
        
        timetableImage.snp.makeConstraints { maker in
            maker.top.equalTo(closeButton.snp.bottom).offset(20)
            maker.centerX.equalToSuperview()
            maker.width.equalTo(250)
            maker.height.equalTo(250)
        }
        
        timetableDescription.snp.makeConstraints { maker in
            maker.top.equalTo(timetableImage.snp.bottom).offset(50)
            maker.centerX.equalToSuperview()
        }
        
        selectDateButton.snp.makeConstraints { maker in
            maker.top.equalTo(timetableDescription.snp.bottom).offset(50)
            maker.centerX.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        viewModel.getTimeTableForDay()
        self.timetableDescription.textColor = self.viewModel.textColor()
        viewModel.registerTimeTableHandler { [weak self] timetable in
            self?.timetableImage.image = timetable.image
            self?.timetableDescription.text = timetable.description
        }
    }
    
    @objc private func selectDate() {
        
        selectDateButton.layer.opacity = 0.5
        selectDateButton.setTitle("Выбрано", for: .normal)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [weak self] _ in
            self?.dismiss(animated: true)
            self?.delegate?.dateWasSelected(date: self?.date ?? "")
        }
    }
}
