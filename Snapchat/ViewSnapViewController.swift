//
//  ViewSnapViewController.swift
//  Snapchat
//
//  Created by Mahieu Bayon on 20/11/2018.
//  Copyright © 2018 M4m0ut. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SDWebImage
import FirebaseAuth
import FirebaseStorage

class ViewSnapViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    
    var snap: DataSnapshot?
    var imageName = ""
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let snapDictionary = snap?.value as? NSDictionary {
            if let description = snapDictionary["description"] as? String {
                if let imageURL = snapDictionary["imageURL"] as? String {
                    messageLabel.text  = description
                    
                    if let url = URL(string: imageURL) {
                        imageView.sd_setImage(with: url, completed: nil)
                    }
                    if let imageName = snapDictionary["imageName"] as? String {
                        self.imageName = imageName
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let currentUserUid = Auth.auth().currentUser?.uid {
            if let key = snap?.key {
                
                timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { _ in
                    if self.imageView.image != nil {
                        
                       self.timer.invalidate()
                        Database.database().reference().child("users").child(currentUserUid).child("snaps").child(key).removeValue()
                        Storage.storage().reference().child("images").child(self.imageName).delete(completion: nil)
                    }
                })
            }
        }
    }
}
