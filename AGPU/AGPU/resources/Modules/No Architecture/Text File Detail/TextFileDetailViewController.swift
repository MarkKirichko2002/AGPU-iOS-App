//
//  TextFileDetailViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 20.04.2025.
//

import UIKit

final class TextFileDetailViewController: UIViewController {

    var document: DocumentModel!
    
    @IBOutlet var fileName: UILabel!
    @IBOutlet var fileText: UITextView!
    
    // MARK: - Init
    init(document: DocumentModel) {
        self.document = document
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpUI()
    }
    
    private func setUpNavigation() {
        let titleView = CustomTitleView(image: "info icon", title: "Документ", frame: .zero)
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .plain, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .label
        navigationItem.titleView = titleView
        navigationItem.rightBarButtonItem = closeButton
    }
    
    private func setUpUI() {
        fileName.text = document.name
        fileText.font = .systemFont(ofSize: 17, weight: .bold)
        fileText.isEditable = false
        displayText()
    }
    
    func displayText() {
        do {
            guard let url = URL(string: document.url) else {return}
            fileText.text = try String(contentsOf: url, encoding: .utf8)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
    }
}
