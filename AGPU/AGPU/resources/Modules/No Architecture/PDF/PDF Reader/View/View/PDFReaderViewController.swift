//
//  PDFReaderViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 01.08.2023.
//

import UIKit
import PDFKit

class PDFReaderViewController: UIViewController {
    
    var pdfView: PDFView!
    var currentPage: Int = 0
    var url: String = ""
    
    init(url: String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Документ"
        SetUpPDF()
    }
    
    private func SetUpPDF() {
        pdfView = PDFView(frame: view.bounds)
        pdfView.autoScales = true
        if let document = PDFDocument(url: URL(string: url)!) {
            pdfView.document = document
            pdfView.go(to: document.page(at: 3)!)
        }
        view.addSubview(pdfView)
    }
}
