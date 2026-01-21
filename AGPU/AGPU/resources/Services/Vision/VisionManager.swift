//
//  VisionManager.swift
//  AGPU
//
//  Created by Марк Киричко on 21.01.2026.
//

import Vision
import AVFoundation

enum headPoses {
    case left
    case right
    case down
}

final class VisionManager {
    
    private var sequenceHandler = VNSequenceRequestHandler()
    
    var headPoseHandler: ((headPoses) ->())?
    
    func detectHeadPose(from pixelBuffer: CVPixelBuffer) {
        let faceDetectionRequest = VNDetectFaceRectanglesRequest { [weak self] request, error in
            guard let observations = request.results as? [VNFaceObservation],
                  let faceObservation = observations.first else { return }
            
            self?.detectLandmarks(on: faceObservation, pixelBuffer: pixelBuffer)
        }
        
        try? sequenceHandler.perform([faceDetectionRequest], on: pixelBuffer)
    }
    
    private func detectLandmarks(on faceObservation: VNFaceObservation, pixelBuffer: CVPixelBuffer) {
        let faceLandmarksRequest = VNDetectFaceLandmarksRequest { request, error in
            guard let observations = request.results as? [VNFaceObservation],
                  let face = observations.first else { return }
            
            if let yaw = face.yaw?.doubleValue,
               let pitch = face.pitch?.doubleValue {
                
                if yaw > 0.5 {
                    print(yaw)
                    self.headPoseHandler?(.left)
                }
                
                if yaw < -0.5 {
                    print(yaw)
                    self.headPoseHandler?(.right)
                }
                
                if pitch > 0.3 {
                    print(pitch)
                    self.headPoseHandler?(.down)
                }
            }
        }
        
        faceLandmarksRequest.inputFaceObservations = [faceObservation]
        try? sequenceHandler.perform([faceLandmarksRequest], on: pixelBuffer)
    }
    
    func registerHandPoseHandler(block: @escaping(headPoses)->Void) {
        self.headPoseHandler = block
    }
}

