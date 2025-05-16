//
//  NewsMultipleSelectionListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 11.07.2024.
//

import UIKit

final class NewsMultipleSelectionListTableViewController: UITableViewController {

    var articles = [Article]()
    var abbreviation = ""
    var selectedArticles = [Article]()
    
    // MARK: - сервисы
    let newsService = AGPUNewsService()
    let settingsManager = SettingsManager()
    
    init(articles: [Article], abbreviation: String) {
        self.articles = articles
        self.abbreviation = abbreviation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpTableView()
    }
    
    private func setUpNavigation() {
        let titleView = CustomTitleView(image: getCategory().icon, title: "\(getCategory().name) новости", frame: .zero)
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .plain, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .label
        navigationItem.titleView = titleView
        setUpMenu()
        navigationItem.leftBarButtonItem = closeButton
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
    }
    
    private func getCategory()-> NewsCategoryModel {
        if let newsCategory = NewsCategories.categories.first(where: { $0.newsAbbreviation == abbreviation }) {
            return newsCategory
        } else {
            return NewsCategories.categories[0]
        }
    }
    
    private func setUpMenu() {
        
        let selectAll = UIAction(title: "Выбрать все") { _ in
            self.selectAllRows()
        }
        
        let cancelAll = UIAction(title: "Отменить все") { _ in
            self.deSelectAllRows()
        }
        
        let shareAction = UIAction(title: "Поделиться") { _ in
            self.share()
        }
        
        let menu = UIMenu(title: "Новости", children: [selectAll, cancelAll, shareAction])
        let sections = UIBarButtonItem(image: UIImage(named: "sections"), menu: menu)
        sections.tintColor = .label
        navigationItem.rightBarButtonItem = sections
        
    }
    
    private func selectAllRows() {
        for i in 0..<articles.count {
            tableView.selectRow(at: IndexPath(row: i, section: 0), animated: true, scrollPosition: .none)
        }
        self.selectedArticles = self.articles
    }
    
    private func deSelectAllRows() {
        for i in 0..<articles.count {
            tableView.deselectRow(at: IndexPath(row: i, section: 0), animated: true)
        }
        self.selectedArticles = []
    }
    
    
    private func makeMessage()-> String {
        
        var str = ""
        
        if !selectedArticles.isEmpty {
            for i in 0..<selectedArticles.count {
                let url = newsService.urlForCurrentArticle(abbreviation: abbreviation, index: selectedArticles[i].id)
                str += "\(i + 1)) \(selectedArticles[i].title): \(url) \n\n"
            }
        }
        
        return str
    }
    
    @objc private func share() {
        checkCount()
    }
    
    func checkCount() {
        let message = createAlertMessage()
        if selectedArticles.isEmpty {
            self.showAlert(title: message.0, message: message.1, actions: [UIAlertAction(title: "ОК", style: .default)])
        } else {
            self.shareInfo(image: UIImage(named: "АГПУ")!, title: "Новости", text: makeMessage())
        }
    }
    
    func createAlertMessage()-> (String, String) {
        let style = settingsManager.getSavedCommunicationStyle()
        let name = UserDefaults.standard.string(forKey: "name") ?? ""
        switch style {
        case .formal:
            return ("Новости не выбраны!", !name.isEmpty ? "\(name) выберите хотя бы одну новость" : "выберите хотя бы одну новость")
        case .informal:
            return ("Новости не выбраны!", !name.isEmpty ? "\(name) выбери хотя бы одну" : "выбери хотя бы одну")
        }
    }
    
    private func setUpTableView() {
        tableView.isEditing.toggle()
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let id = selectedArticles.firstIndex { $0.id == articles[indexPath.row].id } ?? 0
        selectedArticles.remove(at: id)
        print(selectedArticles.count)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedArticles.append(articles[indexPath.row])
        print(selectedArticles.count)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell else {return UITableViewCell()}
        cell.configure(article: articles[indexPath.row])
        return cell
    }
}
