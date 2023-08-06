//
//  PDFLastPageViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 01.08.2023.
//

import UIKit
import PDFKit

class PDFLastPageViewController: UIViewController {
    
    private var pdfView: PDFView!
    private var document: PDFDocument!
    private var currentPage: Int = 0
    private var pdf: RecentPDFModel!
    
    init(pdf: RecentPDFModel) {
        self.pdf = pdf
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUpNavigation()
        SetUpPDF()
        LoadLastPage()
        SavePDF()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.post(name: Notification.Name("screen was closed"), object: nil)
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
        if let document = PDFDocument(url: URL(string: pdf.url)!) {
            self.pdfView.document = document
            self.document = document
        }
        view.addSubview(pdfView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handlePageChange), name: Notification.Name.PDFViewPageChanged, object: nil)
    }
    
    @objc private func handlePageChange() {
        let currentPage = document.index(for: pdfView.currentPage!) + 1
        let totalPageCount = pdfView.document?.pageCount
        navigationItem.title = "Документ [\(currentPage)/\(totalPageCount ?? 0)]"
        SavePDF()
    }
    
    private func SavePDF() {
        var page = 0
        guard let currentPage = pdfView.currentPage?.pageRef?.pageNumber else { return }
        page = currentPage - 1
       
        let pdf = RecentPDFModel(url: pdf.url, pageNumber: page)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            UserDefaults.SaveData(object: pdf, key: "last pdf") {
                print("сохранено: \(pdf)")
            }
        }
    }
    
    private func LoadLastPage() {
        pdfView.go(to: document.page(at: pdf.pageNumber)!)
    }
}
