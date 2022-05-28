//
//  ViewController.swift
//  SimpleMathScan
//
//  Created by Kevin Joseph Mangulabnan on 5/21/22.
//

import UIKit
import VisionKit

class ViewController: UIViewController {
    
    let appFunction = BuildConfig.shared.appFunction
    
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var inputImageView: UIImageView!
    @IBOutlet weak var expressionTextfield: UITextField!
    @IBOutlet weak var resultTextField: UITextField!
    
    @IBAction func actionButtonTapped(_ sender: UIButton) {
        if appFunction == .camera {
            openCamera()
        } else {
            openPhotoLibrary()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        expressionTextfield.isUserInteractionEnabled = false
        resultTextField.isUserInteractionEnabled = false
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
        // Using VNDocumentCameraViewController() instead of UIImagePickerController() for the camera as the latter's text recognition is of poor quality
        let documentCameraViewController = VNDocumentCameraViewController()
        documentCameraViewController.delegate = self
        present(documentCameraViewController, animated: true)
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
    
    private func processImage(inputImage: UIImage) {
        guard let cgImage = inputImage.cgImage else { return }

        // Set the imageView with the input image
        inputImageView.image = inputImage
        
        // Instantiate TextRecognizer to scan text from the image
        let recognizer = TextRecognizer(withImage: cgImage)
        let parsedValues = MathParser.parseArithmetic(fromText: recognizer.text)
        expressionTextfield.text = parsedValues?.expression
        resultTextField.text = parsedValues?.result
        
        self.dismiss(animated: true, completion: nil)
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard
            let inputImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        else {
            print("Error selecting photo.")
            return
        }
        
        processImage(inputImage: inputImage)
    }
}

extension ViewController: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        controller.dismiss(animated: true) {
            // Currently there does not seem to be a way to limit the number of scans, so only the last one is processed
            let image = scan.imageOfPage(at: scan.pageCount - 1)
            self.processImage(inputImage: image)
        }
    }
}
