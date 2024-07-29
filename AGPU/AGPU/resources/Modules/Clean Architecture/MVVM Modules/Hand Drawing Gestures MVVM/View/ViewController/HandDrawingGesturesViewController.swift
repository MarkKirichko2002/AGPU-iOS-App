//
//  HandDrawingGesturesViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 29.07.2024.
//

import UIKit
import SnapKit
import Vision

class HandDrawingGesturesViewController: UIViewController {

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
    
    private let NewsCategoryIcon: SpringImageView = {
        let image = SpringImageView()
        return image
    }()
    
    private let pageNumber: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let canvasView: CanvasView = {
       let view = CanvasView()
       return view
    }()
    
    private let recognizeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.setTitle("Распознать", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .black)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let selectButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.setTitle("Выбрать", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .black)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let clearButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.setTitle("Очистить", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .black)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let textRecognitionManager = TextRecognitionManager()
    
    var category: String = ""
    var page: Int = 0
    var newsPage: Int = 0
    var counter = 0
    
    init(category: String, page: Int) {
        self.category = category
        self.page = page
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textRecognitionManager.setupVision()
        textRecognitionManager.handler = { text in
            self.count(number: Int(text) ?? 0)
            DispatchQueue.main.async {
                self.pageNumber.text = "Страница: \(self.newsPage)"
            }
            self.clear()
        }
        setUpView()
    }
    
    private func count(number: Int) {
        counter += 1
        if counter == 1 {
            newsPage = newsPage + number
        } else if counter == 2 {
            newsPage = (newsPage * 10) + number
        } else if counter > 2 {
            print("хоре")
        }
    }
    
    private func setUpView() {
        view.backgroundColor = .systemBackground
        setUpCloseButton()
        setUpUI()
        setUpRecognizeButton()
        setUpSelectButton()
        setUpClearButton()
        currentCategory()
    }
    
    private func setUpCloseButton() {
        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(closeScreen), for: .touchUpInside)
        closeButton.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
            maker.left.equalToSuperview().inset(20)
        }
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
    }
    
    private func setUpRecognizeButton() {
        view.addSubview(recognizeButton)
        recognizeButton.addTarget(self, action: #selector(recognize), for: .touchUpInside)
        recognizeButton.snp.makeConstraints { maker in
            maker.top.equalTo(canvasView.snp.bottom).offset(50)
            maker.centerX.equalToSuperview()
        }
    }
    
    @objc private func recognize() {
        
        let image = UIImage(view: canvasView) // get UIImage from CanvasView
        let scaledImage = scaleImage(image: image, toSize: CGSize(width: 56, height: 56)) // scale the image to the required size of 28x28 for better recognition results
        
        let imageRequestHandler = VNImageRequestHandler(cgImage: scaledImage.cgImage!, options: [:]) // create a handler that should perform the vision request
        
        do {
            try imageRequestHandler.perform(textRecognitionManager.requests)
        } catch{
            print(error)
        }
    }
    
    private func setUpSelectButton() {
        view.addSubview(selectButton)
        selectButton.addTarget(self, action: #selector(selectValue), for: .touchUpInside)
        selectButton.snp.makeConstraints { maker in
            maker.top.equalTo(recognizeButton.snp.bottom).offset(25)
            maker.leading.equalTo(recognizeButton.snp.leading)
            maker.trailing.equalTo(recognizeButton.snp.trailing)
            maker.centerX.equalToSuperview()
        }
    }
    
    @objc private func selectValue() {
        NotificationCenter.default.post(name: Notification.Name("page"), object: newsPage)
        dismiss(animated: true)
    }
    
    private func setUpClearButton() {
        view.addSubview(clearButton)
        clearButton.addTarget(self, action: #selector(clear), for: .touchUpInside)
        clearButton.snp.makeConstraints { maker in
            maker.top.equalTo(selectButton.snp.bottom).offset(25)
            maker.leading.equalTo(recognizeButton.snp.leading)
            maker.trailing.equalTo(recognizeButton.snp.trailing)
            maker.centerX.equalToSuperview()
        }
    }
    
    @objc private func clear() {
        canvasView.clearCanvas()
    }
    
    private func setUpUI() {
        
        view.addSubviews(optionsList, NewsCategoryIcon, pageNumber, canvasView)
        
        optionsList.menu = setUpMenu()
        
        optionsList.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
            maker.right.equalToSuperview().inset(20)
        }
        
        NewsCategoryIcon.snp.makeConstraints { maker in
            maker.top.equalTo(closeButton.snp.bottom).offset(20)
            maker.centerX.equalToSuperview()
            maker.width.equalTo(150)
            maker.height.equalTo(150)
        }
        
        pageNumber.snp.makeConstraints { maker in
            maker.top.equalTo(NewsCategoryIcon.snp.bottom).offset(50)
            maker.centerX.equalToSuperview()
        }
        
        canvasView.snp.makeConstraints { maker in
            maker.top.equalTo(pageNumber.snp.bottom).offset(50)
            maker.width.equalTo(250)
            maker.height.equalTo(250)
            maker.centerX.equalToSuperview()
        }
    }
    
    private func setUpMenu()-> UIMenu {
        let resetAction = UIAction(title: "Сбросить") { _ in
            self.newsPage = 0
            self.counter = 0
            DispatchQueue.main.async {
                self.pageNumber.text = "Страница: \(self.newsPage)"
            }
            self.clear()
        }
        return UIMenu(title: "Опции", children: [resetAction])
    }
    
    private func currentCategory() {
        let newsCategory = NewsCategories.categories.first { $0.newsAbbreviation == category }!
        NewsCategoryIcon.image = UIImage(named: newsCategory.icon)
        pageNumber.text = "Страница: \(page)"
    }
    
    // scales any UIImage to a desired target size
    func scaleImage (image: UIImage, toSize size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
