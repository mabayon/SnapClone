//
//  SelectPictureViewController.swift
//  Snapchat
//
//  Created by Mahieu Bayon on 09/11/2018.
//  Copyright © 2018 M4m0ut. All rights reserved.
//

import UIKit
import FirebaseStorage

class SelectPictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var messageTextField: UITextField!
    
    var imagePicker: UIImagePickerController?
    var imageAdded = false
    var imageName = "\(NSUUID().uuidString).jpg"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
    }
    
    @IBAction func selectPictureTapped(_ sender: Any) {
        if imagePicker != nil {
            imagePicker?.sourceType = .photoLibrary
            present(imagePicker!, animated: true, completion: nil)
        }
    }
    
    @IBAction func cameraTapped(_ sender: Any) {
        if imagePicker != nil {
            imagePicker?.sourceType = .camera
            present(imagePicker!, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            imageAdded = true
        }
        
        dismiss(animated: true, completion: nil )
    }
    
    @IBAction func nextTapped(_ sender: Any) {
           
        if let message = messageTextField.text {
            if imageAdded && message != "" {
                // Upload the image
                
                let imageFolder = Storage.storage().reference().child("images")
                
                if let image = imageView.image {
                    if let imageData = UIImageJPEGRepresentation(image, 0.1) {
                        
                        let imageRef = imageFolder.child(imageName)
                            
                        imageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                            if let error = error {
                                self.presentAlert(message: error.localizedDescription)
                            } else {
                                // Segue to next View Controller
                                
                                imageRef.downloadURL(completion: { (url, error) in
                                    if let error = error {
                                        self.presentAlert(message: error.localizedDescription)
                                    } else {
                                        if let downloadURL = url?.absoluteString {
                                            self.performSegue(withIdentifier: "selectReciverSegue", sender: downloadURL)
                                        }
                                    }
                                })
                            }
                        })
                    }
                }
            } else {
                // We are missing something
                
                presentAlert(message: "You must provide an image and a message")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let downloadURL = sender as? String {
            if let selectVC = segue.destination as? SelectRecipientTableViewController {
                selectVC.downloadURL = downloadURL
                selectVC.snapDescription = messageTextField.text!
                selectVC.imageName = imageName
            }
        }
    }
    
    func presentAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
