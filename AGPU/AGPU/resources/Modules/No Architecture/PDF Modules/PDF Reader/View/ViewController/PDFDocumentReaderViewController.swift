//
//  PDFDocumentReaderViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 01.08.2023.
//

import UIKit
import PDFKit

class PDFDocumentReaderViewController: UIViewController {
    
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
        setUpNavigation()
        setUpPDF()
        savePDF()
    }
    
    private func setUpNavigation() {
        navigationItem.title = "PDF-документ"
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .done, target: self, action: #selector(close))
        closeButton.tintColor = .black
        let sections = UIBarButtonItem(image: UIImage(named: "sections"), menu: makeMenu())
        sections.tintColor = .black
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItem = sections
    }
    
    @objc private func close() {
        self.dismiss(animated: true)
    }
    
    private func makeMenu()-> UIMenu {
        let shareAction = UIAction(title: "поделиться", image: UIImage(named: "share")) { _ in
            self.shareInfo(image: UIImage(named: "pdf")!, title: "документ", text: self.url)
        }
        let menu = UIMenu(title: "документ", children: [shareAction])
        return menu
    }
    
    private func setUpPDF() {
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
    
    @objc private func handlePageChange() {
        let currentPage = document.index(for: pdfView.currentPage!) + 1
        let totalPageCount = pdfView.document?.pageCount
        navigationItem.title = "Документ [\(currentPage)/\(totalPageCount ?? 0)]"
        savePDF()
    }
    
    private func savePDF() {
        var page = 0
        guard let currentPage = pdfView.currentPage?.pageRef?.pageNumber else { return }
        page = currentPage - 1
       
        let pdf = RecentPDFModel(url: url, pageNumber: page)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            UserDefaults.saveData(object: pdf, key: "last pdf") {
                print("сохранено: \(pdf)")
            }
        }
    }
}
