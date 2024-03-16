//
//  NewsCategoriesRandomizerViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 16.03.2024.
//

import UIKit
import SnapKit

class NewsCategoriesRandomizerViewController: UIViewController {
    
    // MARK: - UI
    private var closeButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(named: "cross"), for: .normal)
        return button
    }()
    
    private let NewsCategoryIcon: SpringImageView = {
        let image = SpringImageView()
        return image
    }()
    
    private let NewsCategoryName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let randomButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(named: "dice"), for: .normal)
        return button
    }()
    
    private let selectCategoryButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(named: "checkmark"), for: .normal)
        return button
    }()
    
    var category: String = ""
    
    init(category: String) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        currentCategory()
        setUpButtons()
    }
    
    private func setUpView() {
        view.backgroundColor = .systemBackground
        view.addSubviews(closeButton, NewsCategoryIcon, NewsCategoryName, randomButton, selectCategoryButton)
        makeConstraints()
    }
    
    private func setUpButtons() {
        closeButton.addTarget(self, action: #selector(closeScreen), for: .touchUpInside)
        randomButton.addTarget(self, action: #selector(randomize), for: .touchUpInside)
        selectCategoryButton.addTarget(self, action: #selector(selectCategory), for: .touchUpInside)
    }
    
    private func currentCategory() {
        let newsCategory = NewsCategories.categories.first { $0.newsAbbreviation == category }!
        NewsCategoryIcon.image = UIImage(named: newsCategory.icon)
        NewsCategoryName.text = newsCategory.name
    }
    
    @objc private func closeScreen() {
        dismiss(animated: true)
    }
    
    @objc private func randomize() {
        let newsCategory = NewsCategories.categories.randomElement()!
        category = newsCategory.newsAbbreviation
        NewsCategoryIcon.image = UIImage(named: newsCategory.icon)
        NewsCategoryName.text = newsCategory.name
    }
    
    @objc private func selectCategory() {
        NotificationCenter.default.post(name: Notification.Name("category"), object: category)
        dismiss(animated: true)
    }
    
    private func makeConstraints() {
        
        closeButton.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(60)
            maker.right.equalToSuperview().inset(20)
        }
        
        NewsCategoryIcon.snp.makeConstraints { maker in
            maker.top.equalTo(closeButton.snp.bottom).offset(20)
            maker.centerX.equalToSuperview()
            maker.width.equalTo(150)
            maker.height.equalTo(150)
        }
        
        NewsCategoryName.snp.makeConstraints { maker in
            maker.top.equalTo(NewsCategoryIcon.snp.bottom).offset(50)
            maker.centerX.equalToSuperview()
        }
        
        randomButton.snp.makeConstraints { maker in
            maker.top.equalTo(NewsCategoryName.snp.bottom).offset(50)
            maker.centerX.equalToSuperview()
            maker.width.equalTo(35)
            maker.height.equalTo(35)
        }
        
        selectCategoryButton.snp.makeConstraints { maker in
            maker.top.equalTo(randomButton.snp.bottom).offset(30)
            maker.centerX.equalToSuperview()
            maker.width.equalTo(35)
            maker.height.equalTo(35)
        }
    }
}
