//
//  PDFReaderViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 01.08.2023.
//

import UIKit
import PDFKit

class PDFReaderViewController: UIViewController {
    
    private var pdfView: PDFView!
    private var document: PDFDocument!
    private var currentPage: Int = 0
    private var url: String = ""
    
    init(url: String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUpNavigation()
        SetUpPDF()
        SavePDFUrl()
        SavePage()
    }
    
    private func SetUpNavigation() {
        navigationItem.title = "Документ"
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .done, target: self, action: #selector(close))
        closeButton.tintColor = .black
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func close() {
        self.dismiss(animated: true)
    }
    
    private func SetUpPDF() {
        pdfView = PDFView(frame: view.bounds)
        pdfView.autoScales = true
        pdfView.usePageViewController(true)
        if let document = PDFDocument(url: URL(string: url)!) {
            self.pdfView.document = document
            self.document = document
        }
        view.addSubview(pdfView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handlePageChange), name: Notification.Name.PDFViewPageChanged, object: nil)
        
        UserDefaults.standard.setValue(url, forKey: "last pdf url")
    }
    
    private func SavePDFUrl() {
        
        let dateManager = DateManager()
        let date = dateManager.getCurrentDate()
        let time = dateManager.getCurrentTime()
        let page = RecentPageModel(date: date, time: time, url: url, position: CGPoint(x: 0, y: 0))
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            UserDefaults.SaveData(object: page, key: "last page") {
                print("сохранено: \(page)")
            }
        }
    }
    
    @objc private func handlePageChange() {
        let currentPage = document.index(for: pdfView.currentPage!) + 1
        let totalPageCount = pdfView.document?.pageCount
        navigationItem.title = "Документ [\(currentPage)/\(totalPageCount ?? 0)]"
        SavePage()
    }
    
    private func SavePage() {
        var page = 0
        guard let currentPage = pdfView.currentPage?.pageRef?.pageNumber else { return }
        page = currentPage - 1
        UserDefaults.standard.set(page, forKey: "pdfPageNumber")
    }
}
