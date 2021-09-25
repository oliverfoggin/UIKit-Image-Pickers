//
//  ViewController.swift
//  UIKit Image Pickers
//
//  Created by Foggin, Oliver (Developer) on 25/09/2021.
//

import UIKit
import PhotosUI

class ViewController: UIViewController {

  @IBOutlet weak var imageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }

  @IBAction func showImagePicker(_ sender: Any) {
    let picker = UIImagePickerController()
    picker.allowsEditing = true
    picker.delegate = self
    present(picker, animated: true)
  }
  
  @IBAction func showPhotoPicker(_ sender: Any) {
    var config = PHPickerConfiguration()
    config.filter = .images
    config.selectionLimit = 1
    
    let picker = PHPickerViewController(configuration: config)
    picker.delegate = self
    present(picker, animated: true)
  }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    picker.dismiss(animated: true)
    
    guard let image = info[.editedImage] as? UIImage else {
      return
    }
    
    imageView.image = image
  }
}

extension ViewController: PHPickerViewControllerDelegate {
  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    picker.dismiss(animated: true)
    
    guard let provider = results.first?.itemProvider,
          provider.canLoadObject(ofClass: UIImage.self) else {
            return
          }
    
    provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
      guard let image = image as? UIImage else {
        return
      }
      
      DispatchQueue.main.async {
        self?.imageView.image = image
      }
    }
  }
}
