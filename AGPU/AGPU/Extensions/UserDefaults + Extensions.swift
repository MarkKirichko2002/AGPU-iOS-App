//
//  UserDefaults + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 21.06.2023.
//

import Foundation

extension UserDefaults {
    
    static func SaveData<T: Encodable>(object: T, key: String) {
        do {
            let data = try JSONEncoder().encode(object)
            UserDefaults.standard.setValue(data, forKey: key)
        } catch {
            print(error)
        }
    }
    
    static func loadData<T: Decodable>(type: T.Type, key: String)-> T? {
        do {
            if let data = UserDefaults.standard.data(forKey: key) {
                let object = try JSONDecoder().decode(T.self, from: data)
                print(object)
                return object
            }
        } catch {}
        return nil
    }
}
