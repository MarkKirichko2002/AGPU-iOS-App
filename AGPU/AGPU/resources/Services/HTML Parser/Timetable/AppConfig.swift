//
//  AppConfig.swift
//  AGPU
//
//  Created by Марк Киричко on 08.09.2025.
//

import Foundation
import FirebaseRemoteConfig

struct WeekIdMapping: Codable {
    let id: Int64
    let range: String

    private enum CodingKeys: String, CodingKey {
        case id = "id_mapping"
        case range
    }
}

final class AppConfig {
    static func getWeekIdMappings() -> [WeekIdMapping] {
        let remoteConfig = RemoteConfig.remoteConfig()
        
        // Берём строку JSON из Remote Config
        let jsonString = remoteConfig["week_id_mappings"].stringValue
         guard let data = jsonString.data(using: .utf8) else {
            return []
        }
        
        do {
            let decoded = try JSONDecoder().decode([WeekIdMapping].self, from: data)
            return decoded.map { WeekIdMapping(id: $0.id, range: $0.range) }
        } catch {
            print("❌ Ошибка парсинга Remote Config: \(error)")
            return []
        }
    }
}
