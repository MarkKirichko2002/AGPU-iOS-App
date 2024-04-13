//
//  ShareLocationAppsViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 03.03.2024.
//

import UIKit
import MapKit

class ShareLocationAppsViewController: UIViewController {
    
    // MARK: - UI
    private var closeButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(named: "cross"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let QuestionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Для какого приложения поделиться локацией?"
        label.font = .systemFont(ofSize: 18, weight: .black)
        label.textColor = .label
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let locationName: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let AppleMapsStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let AppleMapsButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.textAlignment = .center
        button.setImage(UIImage(named: "apple maps"), for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let AppleMapsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "Apple Maps"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let GoogleMapsStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let GoogleMapsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "google maps"), for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let GoogleMapsLabel: UILabel = {
        let label = UILabel()
        label.text = "Google Maps"
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let YandexMapsStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let YandexMapsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "yandex maps"), for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let YandexMapsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "Яндекс Карты"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var annotation: MKAnnotation
    
    // MARK: - Init
    init(annotation: MKAnnotation) {
        self.annotation = annotation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        view.backgroundColor = .systemBackground
        view.addSubviews(closeButton, QuestionLabel, locationName, AppleMapsButton, AppleMapsLabel, AppleMapsStack, GoogleMapsButton, GoogleMapsLabel, GoogleMapsStack, YandexMapsButton, YandexMapsLabel, YandexMapsStack)
        locationName.text = annotation.title!!
        makeConstraints()
    }
    
    private func setUpButtons() {
        closeButton.addTarget(self, action: #selector(closeScreen), for: .touchUpInside)
        AppleMapsButton.addTarget(self, action: #selector(shareLocationWithAppleMaps), for: .touchUpInside)
        GoogleMapsButton.addTarget(self, action: #selector(shareLocationWithGoogleMaps), for: .touchUpInside)
        YandexMapsButton.addTarget(self, action: #selector(shareLocationWithYandexMaps), for: .touchUpInside)
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
    }
    
    private func setUpLabels() {
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(shareLocationWithAppleMaps))
        AppleMapsLabel.addGestureRecognizer(tap1)
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(shareLocationWithGoogleMaps))
        GoogleMapsLabel.addGestureRecognizer(tap2)
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(shareLocationWithYandexMaps))
        YandexMapsLabel.addGestureRecognizer(tap3)
    }
    
    private func makeConstraints() {
        
        AppleMapsStack.addArrangedSubview(AppleMapsButton)
        AppleMapsStack.addArrangedSubview(AppleMapsLabel)
        
        GoogleMapsStack.addArrangedSubview(GoogleMapsButton)
        GoogleMapsStack.addArrangedSubview(GoogleMapsLabel)
        
        YandexMapsStack.addArrangedSubview(YandexMapsButton)
        YandexMapsStack.addArrangedSubview(YandexMapsLabel)
        
        NSLayoutConstraint.activate([
            
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            closeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            
            QuestionLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 30),
            QuestionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            QuestionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            
            locationName.topAnchor.constraint(equalTo: QuestionLabel.topAnchor, constant: 80),
            locationName.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            locationName.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            
            AppleMapsStack.topAnchor.constraint(equalTo: locationName.bottomAnchor, constant: 80),
            AppleMapsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            AppleMapsButton.widthAnchor.constraint(equalToConstant: 70),
            AppleMapsButton.heightAnchor.constraint(equalToConstant: 70),
            
            GoogleMapsStack.topAnchor.constraint(equalTo: AppleMapsButton.bottomAnchor, constant: 30),
            GoogleMapsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            GoogleMapsButton.widthAnchor.constraint(equalToConstant: 70),
            GoogleMapsButton.heightAnchor.constraint(equalToConstant: 70),
            
            YandexMapsStack.topAnchor.constraint(equalTo: GoogleMapsButton.bottomAnchor, constant: 30),
            YandexMapsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            YandexMapsButton.widthAnchor.constraint(equalToConstant: 70),
            YandexMapsButton.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    @objc private func shareLocationWithAppleMaps() {
        let title = annotation.title!! + " (Apple Maps)"
        let url = "http://maps.apple.com/?q=\(annotation.coordinate.latitude),\(annotation.coordinate.longitude)"
        shareInfo(image: UIImage(named: "map icon")!, title: title, text: "\(title)-\(url)")
    }
    
    @objc private func shareLocationWithGoogleMaps() {
        let title = annotation.title!! + " (Google Maps)"
        let url = "https://www.google.com/maps/search/?api=1&query=\(annotation.coordinate.latitude),\(annotation.coordinate.longitude)"
        shareInfo(image: UIImage(named: "map icon")!, title: title, text: "\(title)-\(url)")
    }
    
    @objc private func shareLocationWithYandexMaps() {
        let title = annotation.title!! + " (Яндекс Карты)"
        let url = "https://maps.yandex.ru/?pt=\(annotation.coordinate.latitude),\(annotation.coordinate.longitude)&z=14"
        shareInfo(image: UIImage(named: "map icon")!, title: title, text: "\(title)-\(url)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpButtons()
        setUpLabels()
    }
}
