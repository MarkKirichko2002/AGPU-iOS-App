//
//  PDFDocumentReaderViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 01.08.2023.
//

import UIKit
import PDFKit

final class PDFDocumentReaderViewController: UIViewController {
    
    private var pdfView: PDFView!
    private var document: PDFDocument!
    private var url: String = ""
    
    var currentPage: Int = 0
    
    // MARK: - сервисы
    private let realmManager = RealmManager()
    
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
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .done, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .label
        let sections = UIBarButtonItem(image: UIImage(named: "sections"), menu: makeMenu())
        sections.tintColor = .label
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItem = sections
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        self.dismiss(animated: true)
    }
    
    private func makeMenu()-> UIMenu {
        
        let shareAction = UIAction(title: "Поделиться", image: UIImage(named: "share")) { _ in
            URLSession.shared.loadDocument(url: self.url) { docURL in
                let activityViewController = UIActivityViewController(activityItems: [docURL], applicationActivities: nil)
                self.present(activityViewController, animated: true)
            }
        }
        let saveAction = UIAction(title: "Сохранить", image: UIImage(named: "download")) { _ in
            URLSession.shared.loadDocument(url: self.url) { docURL in
                let document = DocumentModel()
                document.name = docURL.lastPathComponent
                document.format = docURL.pathExtension
                document.url = docURL.absoluteString
                document.page = self.currentPage
                self.realmManager.saveDocument(document: document)
            }
        }
        let menu = UIMenu(title: "Документ", children: [shareAction, saveAction])
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
        
        guard let doc = document else {return}
        
        guard let page = doc.page(at: currentPage) else {return}
        
        pdfView.go(to: page)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handlePageChange), name: Notification.Name.PDFViewPageChanged, object: nil)
        
        UserDefaults.standard.setValue(url, forKey: "last pdf url")
    }
    
    @objc private func handlePageChange() {
        currentPage = document.index(for: pdfView.currentPage!)
        realmManager.editDocumentPage(url: url, page: currentPage)
        let totalPageCount = pdfView.document?.pageCount
        navigationItem.title = "Документ [\(currentPage + 1)/\(totalPageCount ?? 0)]"
        savePDF()
    }
    
    private func savePDF() {
               
        let pdf = RecentPDFModel(url: url, pageNumber: currentPage)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            UserDefaults.saveData(object: pdf, key: "last pdf") {
                print("сохранено: \(pdf)")
            }
        }
    }
}
