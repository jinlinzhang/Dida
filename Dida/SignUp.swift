//
//  SignUp.swift
//  Dida
//
//  Created by 李政含 on 4/11/17.
//
//

import UIKit
import Foundation
import Firebase
import FirebaseAuth

struct user {
    var profName: String?
    var emailAdd: String?
    var profPic: String?
    var gender: String?
    
}



class SignUp:UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    

    @IBOutlet weak var PS: UITextField!
    
    @IBOutlet weak var Email: UITextField!
    var UserStorage:FIRStorageReference!
    var ref: FIRDatabaseReference!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true;
    }
    @IBAction func signUp(_ sender: UIButton) {
        if Email.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }else{
            FIRAuth.auth()?.createUser(withEmail: self.Email.text!, password: PS.text!, completion: { (user, error) in
        if error == nil
        {
            print("You have successfully signed up")
            self.performSegue(withIdentifier: "showMain", sender: self)
            
        } else{
            let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        })
            
    }
        createUser()
        currentUser = user(profName: Email.text!, emailAdd: Email.text!, profPic: "Circled User Male-30", gender: "Unspecified")
    }
    
    
    func createUser(){
    let uid = FIRAuth.auth()!.currentUser!.uid
    let ref = FIRDatabase.database().reference()
    let storage = FIRStorage.storage().reference(forURL: "gs://dida-a845a.appspot.com")
    
    let key = ref.child("users").childByAutoId().key
    let imageRef = storage.child("users").child(uid).child("\(key).jpg")
    
    let data = UIImageJPEGRepresentation(#imageLiteral(resourceName: "Circled User Male-30"), 0.6)
    
    let uploadTask = imageRef.put(data!, metadata: nil) { (metadata, error) in
        if error != nil {
            print(error!.localizedDescription)
            return
        }
        imageRef.downloadURL(completion: { (url, error) in
            if let url = url {
                let feed = ["userID" : uid,
                            "emailAdd" : self.Email.text!,
                            "proPic" : url.absoluteString,
                            "proName" : self.Email.text!,
                            "gender" : "Unspecified",
                            "postID" : key] as [String : Any]
                let postFeed = ["\(key)" : feed]
                
                ref.child("users").updateChildValues(postFeed)
                
                self.dismiss(animated: true, completion: nil)
            }
        })
        
    }
    
    uploadTask.resume()
    
}


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMain" {
        }
        
    }
  //  @IBOutlet weak var imageview: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       // imageview.isUserInteractionEnabled = true
       // let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
     //   longPressRecognizer.minimumPressDuration = 0.5
       // imageview.addGestureRecognizer(longPressRecognizer)
        let storage = FIRStorage.storage().reference(forURL: "gs://dida-a845a.appspot.com")
        UserStorage = storage.child("users")
        Email.delegate=self
        PS.delegate=self
    }

    
//    func longPressed(sender: UILongPressGestureRecognizer) {
//        let alert = UIAlertController(title: "Change Profile Picture", message: "Choose the way you want to change", preferredStyle: .actionSheet)
//        let UPAction = UIAlertAction(title: "Upload Picture", style: .destructive, handler: handleUpload)
//        let TPAction = UIAlertAction(title: "Take Photo", style: .destructive, handler: handleTakePhoto)
//        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancel)
//        alert.addAction(UPAction)
//        alert.addAction(TPAction)
//        alert.addAction(CancelAction)
//        self.present(alert, animated: true, completion: nil)
//        
//    }
//    var picker: UIImagePickerController!
//    func handleUpload(alertAction: UIAlertAction!) -> Void {
//        picker = UIImagePickerController()
//        picker.delegate = self
//        picker.sourceType = .photoLibrary
//        present(picker, animated: true, completion: nil)
//        
//    }
//    
//    func handleTakePhoto(alertAction: UIAlertAction!) -> Void {
//        picker = UIImagePickerController()
//        picker.delegate = self
//        picker.sourceType = .camera
//        present(picker, animated: true, completion: nil)
//    }
//    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        picker.dismiss(animated: true, completion: nil)
//        imageview.image = info[UIImagePickerControllerOriginalImage] as? UIImage
//        //dismiss(animated: true, completion: nil)
//        
//    }
    
    @IBAction func CancelSignUp(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func cancel(alertAction: UIAlertAction!) {
    }
}
