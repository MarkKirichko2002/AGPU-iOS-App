//
//  GestureRecognitionManager.swift
//  AGPU
//
//  Created by Марк Киричко on 13.03.2025.
//

import MediaPipeTasksVision

enum handGestures: String {
    case fist = "👊"
    case one = "☝️"
    case two = "✌️"
    case palm = "🤚"
    case like = "👍"
    case dislike = "👎"
    
}

final class GestureRecognitionManager: NSObject {
    
    var gestureRecognizer: GestureRecognizer?
    
    private var handRecognitionHandler: ((handGestures)->Void)?
    
    override init() {
        super.init()
        setUpGestureRecognition()
    }
    
    private func setUpGestureRecognition() {
        let baseOptions = BaseOptions()
        baseOptions.modelAssetPath = "gesture_recognizer.task"
        let options = GestureRecognizerOptions()
        options.baseOptions = baseOptions
        options.runningMode = .liveStream
        options.gestureRecognizerLiveStreamDelegate = self
        options.numHands = 2
        
        do {
            gestureRecognizer = try GestureRecognizer(options: options)
        } catch {
            print("Ошибка: \(error)")
        }
    }
    
    func registerHandGestureHandler(block: @escaping((handGestures)->Void)) {
        self.handRecognitionHandler = block
    }
}

extension GestureRecognitionManager: GestureRecognizerLiveStreamDelegate {
    
    func gestureRecognizer(
        _ gestureRecognizer: GestureRecognizer,
        didFinishGestureRecognition result: GestureRecognizerResult?,
        timestampInMilliseconds: Int,
        error: Error?
    ) {
        guard let result = result else { return }
        
        for gesture in result.gestures {
            let names = Set(gesture.map { $0.categoryName ?? "" })
            if names.contains("Closed_Fist") {
                DispatchQueue.main.async {
                    self.handRecognitionHandler?(.fist)
                }
            } else if names.contains("Pointing_Up") {
                DispatchQueue.main.async {
                    self.handRecognitionHandler?(.one)
                }
            } else if names.contains("Victory") {
                DispatchQueue.main.async {
                    self.handRecognitionHandler?(.two)
                }
            } else if names.contains("Open_Palm") {
                DispatchQueue.main.async {
                    self.handRecognitionHandler?(.palm)
                }
            } else if names.contains("Thumb_Up") {
                DispatchQueue.main.async {
                    self.handRecognitionHandler?(.like)
                }
            } else if names.contains("Thumb_Down") {
                DispatchQueue.main.async {
                    self.handRecognitionHandler?(.dislike)
                }
            }
        }
    }
}
