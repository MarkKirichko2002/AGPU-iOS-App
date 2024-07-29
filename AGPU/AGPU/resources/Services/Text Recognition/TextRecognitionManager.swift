//
//  TextRecognitionManager.swift
//  AGPU
//
//  Created by Марк Киричко on 28.06.2024.
//

import UIKit
import Vision

class TextRecognitionManager {
    
    var requests = [VNRequest]() // holds Image Classification Request
    
    var handler: ((String)->Void)?
    
    func setupVision() {
        // load MNIST model for the use with the Vision framework
        guard let visionModel = try? VNCoreMLModel(for: MNIST(configuration: .init()).model) else {fatalError("can not load Vision ML model")}
        
        // create a classification request and tell it to call handleClassification once its done
        let classificationRequest = VNCoreMLRequest(model: visionModel, completionHandler: self.handleClassification)
        
        self.requests = [classificationRequest] // assigns the classificationRequest to the global requests array
    }
    
    func handleClassification(request:VNRequest, error:Error?) {
        guard let observations = request.results else {print("no results"); return}
        
        // process the ovservations
        let classifications = observations
            .compactMap({$0 as? VNClassificationObservation}) // cast all elements to VNClassificationObservation objects
            .filter({$0.confidence > 0.8}) // only choose observations with a confidence of more than 80%
            .map({$0.identifier}) // only choose the identifier string to be placed into the classifications array
        
        handler?(classifications.first ?? "нет")
    }
    
    func recognizeText(image: UIImage,completion: @escaping(String)->()) {
        
        guard let cgImage = image.cgImage else {
            return
        }
        
        // Handler
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        // Request
        let request = VNRecognizeTextRequest { request,error in
            guard let observations = request.results as? [VNRecognizedTextObservation],
                  error == nil else {
                return
            }
            
            let text = observations.compactMap({
                $0.topCandidates(1).first?.string
            }).joined(separator: " ")
            completion(text)
        }
        
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }
}
