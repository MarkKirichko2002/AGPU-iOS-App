//
//  AIInfoViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 19.12.2025.
//

import Foundation

final class AIInfoViewModel {
    
    // MARK: - сервисы
    private let aiManager = AIManager()
    
    var text: String
    var aiInfoHandler: ((String)->Void)?
    var modelsMenuChangedHandler: (()->Void)?
    
    init(text: String) {
        self.text = text
    }
    
    func getInfo() {
        Task {
            let summary = try await aiManager.makeResponse(prompt: text)
            aiInfoHandler?(summary)
        }
    }
    
    func getCurrentGeminiModel()-> String {
        return aiManager.currentModel
    }
    
    func getGeminiModels()-> [String] {
        return aiManager.models
    }
    
    func selectGeminiModel(model: String) {
        aiManager.currentModel = model
        modelsMenuChangedHandler?()
    }
    
    func registerAIInfoHandler(block: @escaping(String)->Void) {
        self.aiInfoHandler = block
    }
    
    func registerModelsMenuChangedHandler(block: @escaping()->Void) {
        self.modelsMenuChangedHandler = block
    }
}
