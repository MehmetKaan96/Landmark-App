//
//  AddPlaceViewController.swift
//  Foursquare Clone
//
//  Created by mehmet on 7.09.2022.
//

import UIKit
import Parse


@available(iOS 14, *)
class AddPlaceViewController: UIViewController{

    @IBOutlet var nextButton: UIButton!
    @IBOutlet var placeImageView: UIImageView!
    @IBOutlet var descriptionTextField: UITextField!
    @IBOutlet var typeTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        placeImageView.isUserInteractionEnabled = true
        let imageGesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        placeImageView.addGestureRecognizer(imageGesture)
        
        let hideGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(hideGesture)
    }
    

    @IBAction func nextButtonTapped(_ sender: UIButton) {
        
        //data transfer between viewcontrollers using singleton
        
        if nameTextField.text! != "" && typeTextField.text! != "" && descriptionTextField.text! != "" {
            if let chosenImage = placeImageView.image {
                let placeModel = Places.sharedInstance
                placeModel.placeName = nameTextField.text!
                placeModel.placeType = typeTextField.text!
                placeModel.placeDesc = descriptionTextField.text!
                placeModel.placeImg = chosenImage
            }
            performSegue(withIdentifier: "toMapVC", sender: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "Please check your place infos", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
        
    }
    
}

@available(iOS 14, *)
extension AddPlaceViewController : UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @objc func selectImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        placeImageView.image  = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
    
}
