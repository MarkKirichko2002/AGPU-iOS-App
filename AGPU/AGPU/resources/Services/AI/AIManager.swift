//
//  AIManager.swift
//  AGPU
//
//  Created by Марк Киричко on 18.12.2025.
//

import FirebaseAILogic

final class AIManager {
    
    let models = ["gemini-2.5-flash", "gemini-2.5-flash-lite"]
    var currentModel = "gemini-2.5-flash"
    
    func makeResponse(prompt: String) async throws -> String {
        let ai = FirebaseAI.firebaseAI(app: .app(), backend: .googleAI(), useLimitedUseAppCheckTokens: true)
        let model = ai.generativeModel(modelName: currentModel)
        do {
            let response = try await model.generateContent(prompt)
            if let text = response.text {
                return text
            }
        } catch {
            print("Ошибка: \(error)")
        }
        return "Запросы закончились"
    }
}
