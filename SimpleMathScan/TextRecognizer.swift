//
//  TextRecognizer.swift
//  SimpleMathScan
//
//  Created by Kevin Joseph Mangulabnan on 5/22/22.
//

import Vision

class TextRecognizer {
    var text: [String] = []

    init(withImage cgImage: CGImage) {
        requestFromImage(cgImage: cgImage)
    }
    
    func requestFromImage(cgImage: CGImage) {
        // Create a new image-request handler.
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)

        // Create a new request to recognize text.
        let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        
        do {
            // Perform the text-recognition request.
            try requestHandler.perform([request])
        } catch {
            print("Unable to perform the requests: \(error).")
        }
    }

    private func recognizeTextHandler(request: VNRequest, error: Error?) {
        guard let observations =
                request.results as? [VNRecognizedTextObservation] else {
            return
        }
        
        text = observations.compactMap { observation in
            // Return the string of the top VNRecognizedText instance.
            return observation.topCandidates(1).first?.string
        }
    }
}
