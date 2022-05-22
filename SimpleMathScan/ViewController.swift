//
//  ViewController.swift
//  SimpleMathScan
//
//  Created by Kevin Joseph Mangulabnan on 5/21/22.
//

import UIKit
import Vision

class ViewController: UIViewController {
    
    let appFunction = BuildConfig.shared.appFunction
    
    @IBOutlet weak var actionButton: UIButton!
    
    @IBAction func actionButtonTapped(_ sender: UIButton) {
        if appFunction == .camera {
            openCamera()
        } else {
            openPhotoLibrary()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setActionButtonText()
    }

    private func setActionButtonText() {
        if BuildConfig.shared.appFunction == .camera {
            actionButton.setTitle("Take Photo", for: .normal)
        } else {
            actionButton.setTitle("Choose Photo", for: .normal)
        }
    }
    
    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true)
        }
    }
    
    // Since iOS 11, read access to the photo library via UIImagePickerController() no longer requires the user to grant explicit permission
    private func openPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true)
        }
    }    
}

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let cgImage = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)?.cgImage else {
            print("Error selecting photo.")
            return
        }
        
        // Instantiate TextRecognizer to scan text from the image
        let recognizer = TextRecognizer(withImage: cgImage)
        print(recognizer.text)
        self.dismiss(animated: true, completion: nil)
    }
}

extension ViewController: UINavigationControllerDelegate {
    
}
