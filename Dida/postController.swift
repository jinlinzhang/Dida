//
//  post.swift
//  Dida
//
//  Created by 李政含 on 4/13/17.
//
//

import Foundation
import Firebase
import YelpAPI
import BrightFutures

struct ResInfo{
    var name:String
    var id:String
}


class postController: UIViewController, UIImagePickerControllerDelegate,UISearchBarDelegate, UINavigationControllerDelegate, UITableViewDelegate {
    @IBOutlet weak var Res: UIButton!
    
    @IBAction func Res(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showRes", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRes"{
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MyFood.isUserInteractionEnabled = true
        let TapPressRecognizer = UITapGestureRecognizer(target: self, action: #selector(Tap))
        MyFood.addGestureRecognizer(TapPressRecognizer)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableData(notification: )), name: .reload, object: nil)
    }
    func reloadTableData(notification: NSNotification) {
        Res.setTitle(postLocation, for: UIControlState.normal)
    }
    
    func Tap(sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Change Profile Picture", message: "Choose the way you want to change", preferredStyle: .actionSheet)
        let UPAction = UIAlertAction(title: "Upload Picture", style: .destructive, handler: handleUpload)
        //let TPAction = UIAlertAction(title: "Take Photo", style: .destructive, handler: handleTakePhoto)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancel)
        alert.addAction(UPAction)
        //alert.addAction(TPAction)
        alert.addAction(CancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    func cancel(alertAction: UIAlertAction!) {
    }
    
    

    
    
    var picker: UIImagePickerController!
    func handleUpload(alertAction: UIAlertAction!) -> Void {
        picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var MyFood: UIImageView!
    @IBOutlet weak var MyFeel: UITextView!
    
   
    
        
    @IBAction func post(_ sender: Any) {
        
        let uid = FIRAuth.auth()!.currentUser!.uid
        let ref = FIRDatabase.database().reference()
        let storage = FIRStorage.storage().reference(forURL: "gs://dida-a845a.appspot.com")
        
        let key = ref.child("posts").childByAutoId().key
        let imageRef = storage.child("posts").child(uid).child("\(key).jpg")
        
        let data = UIImageJPEGRepresentation(self.MyFood.image!, 0.6)
        
        let uploadTask = imageRef.put(data!, metadata: nil) { (metadata, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            imageRef.downloadURL(completion: { (url, error) in
                if let url = url {
                    let feed = ["userID" : uid,
                                "pathToImage" : url.absoluteString,
                                "likes" : 0,
                                "say" : self.MyFeel.text,
                                "ResName":postLocation,
                                "ResID":resID,
                                "email" : currentUser.emailAdd!,
                                "postID" : key] as [String : Any]
                    let postFeed = ["\(key)" : feed]
                    
                    ref.child("posts").updateChildValues(postFeed)
                    
                    self.tabBarController?.selectedIndex = 0
                    //self.dismiss(animated: true, completion: nil)
                    
                }
            })
            
        }
        
        uploadTask.resume()
        
    }

        


    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        MyFood.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        //dismiss(animated: true, completion: nil)
        
    }

    
}
















