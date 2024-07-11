//
//  NewsMultipleSelectionListTableViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 11.07.2024.
//

import UIKit

class NewsMultipleSelectionListTableViewController: UITableViewController {

    var articles = [Article]()
    var abbreviation = ""
    var selectedArticles = [Article]()
    
    var count = 0
    
    let newsService = AGPUNewsService()
    
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
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .plain, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .label
        navigationItem.title = "Новости"
        setUpShareButton()
        navigationItem.leftBarButtonItem = closeButton
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
    }
    
    private func setUpShareButton() {
        let shareButton = UIBarButtonItem(image: UIImage(named: "share"), style: .done, target: self, action: #selector(share))
        shareButton.tintColor = .label
        navigationItem.rightBarButtonItem = shareButton
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
        if selectedArticles.isEmpty {
            self.showAlert(title: "Новости не выбраны!", message: "выберите хотя бы одну новость", actions: [UIAlertAction(title: "ОК", style: .default)])
        } else {
            self.shareInfo(image: UIImage(named: "АГПУ")!, title: "Новости", text: makeMessage())
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
