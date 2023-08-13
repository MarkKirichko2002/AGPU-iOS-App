//
//  HTMLParser + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 13.08.2023.
//

import Foundation
import SwiftSoup

// MARK: - HTMLParserProtocol
extension HTMLParser: HTMLParserProtocol {
    
    func ParseDocuments(url: String, completion: @escaping([DocumentModel])->Void) {
        var type = ""
        
        guard let url = URL(string: "http://test.agpu.net/struktura-vuza/faculties-institutes/ipimif/kafedra-infiITO/MetodicheskoyeObespecheniye/index.php") else {
            print("Недействительный URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Ошибка загрузки данных: \(error)")
                return
            }
            
            if let data = data, let html = String(data: data, encoding: .utf8) {
                do {
                    let doc: Document = try SwiftSoup.parseBodyFragment(html)
                    
                    let items = try doc.getElementsByClass("list-group-item")
                    
                    for item in items {
                        do {
                            let text = try item.text()
                            let url = try item.getElementsByTag("a")[0].attr("href")
                            if url.lowercased().contains("pdf") {
                                type = "PDF"
                            }
                            if url.lowercased().contains("doc") {
                                type = "doc"
                            }
                            if url.lowercased().contains("docx") {
                                type = "docx"
                            }
                            let document = DocumentModel(name: text, url: "http://test.agpu.net/struktura-vuza/faculties-institutes/ipimif/kafedra-infiITO/MetodicheskoyeObespecheniye/\(url)", format: type)
                            self.documentsArray.append(document)
                        } catch let error {
                            print("Ошибка: \(error)")
                        }
                    }
                    completion(self.documentsArray)
                } catch let error {
                    print("Ошибка: \(error)")
                }
            }
        }
        task.resume()
    }
}
