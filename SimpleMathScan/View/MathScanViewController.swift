//
//  ViewController.swift
//  SimpleMathScan
//
//  Created by Kevin Joseph Mangulabnan on 5/21/22.
//

import UIKit
import Combine
import VisionKit

class MathScanViewController: UIViewController {
    private let appFunction = BuildConfig.shared.appFunction
    private var cancellables: [AnyCancellable] = []
    private let viewModel: MathScanViewModelType = MathScanViewModel(
        mathScanner: MathScanner(textRecognizer: TextRecognizer())
    )
    private let photoReceived = PassthroughSubject<UIImage?, Never>()
    
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
        setupUI()
        bindToViewModel()
    }

    private func setupUI() {
        title = "Math Scan"
        inputImageView.layer.borderWidth = 2
        inputImageView.layer.borderColor = BuildConfig.shared.appTheme.mainColor.cgColor
        expressionTextfield.isUserInteractionEnabled = false
        resultTextField.isUserInteractionEnabled = false
        setActionButtonText()
    }
    
    private func bindToViewModel() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        let input = MathScanViewModelInput(photoReceived: photoReceived.eraseToAnyPublisher())
        let output = viewModel.transform(input: input)

        output.sink(receiveValue: {[unowned self] state in
            expressionTextfield.text = state.expression
            resultTextField.text = state.result
            inputImageView.image = state.scannedImage
        }).store(in: &cancellables)
    }
    
    private func setActionButtonText() {
        if BuildConfig.shared.appFunction == .camera {
            actionButton.setTitle(" Take Photo ", for: .normal)
        } else {
            actionButton.setTitle(" Choose Photo ", for: .normal)
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
}

extension MathScanViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard
            let inputImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        else {
            print("Error selecting photo.")
            return
        }
        
        self.dismiss(animated: true, completion: nil)
        photoReceived.send(inputImage)
    }
}

extension MathScanViewController: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        controller.dismiss(animated: true) {
            // Currently there does not seem to be a way to limit the number of scans, so only the last one is processed
            let image = scan.imageOfPage(at: scan.pageCount - 1)
            self.dismiss(animated: true, completion: nil)
            self.photoReceived.send(image)
        }
    }
}
