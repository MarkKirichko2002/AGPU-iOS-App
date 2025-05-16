//
//  URLSession + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 26.09.2024.
//

import Foundation

extension URLSession {
    
    func loadDocument(url: String, completion: @escaping(URL)->Void) {
        
        let docURL = URL(string: url)!
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let localFileURL = documentsDirectory.appendingPathComponent(docURL.lastPathComponent)
        
        URLSession.shared.downloadTask(with: docURL) { data, _, error in
            
            guard let data = data else {return}
            
            if FileManager.default.fileExists(atPath: localFileURL.path) {
                do {
                    try FileManager.default.removeItem(at: localFileURL)
                    print("удален")
                    try FileManager.default.moveItem(at: data, to: localFileURL)
                    DispatchQueue.main.async {
                        completion(localFileURL)
                    }
                } catch {
                    print(error)
                }
            } else {
                do {
                    try FileManager.default.moveItem(at: data, to: localFileURL)
                    DispatchQueue.main.async {
                        completion(localFileURL)
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
}
