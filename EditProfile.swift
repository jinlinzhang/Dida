//
//  EditProfile.swift
//  Dida
//
//  Created by 李政含 on 4/17/17.
//
//

import UIKit
import Foundation
import YelpAPI
import Firebase


var Username: String?

class ciel: UITableViewCell, UITextFieldDelegate{
    
    //var cimage: UIImage!
    var txtf = UITextField(frame: CGRect(x: 50, y: 0, width: 400, height: 30))
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "ciel")
        txtf.isEnabled = true
        txtf.clearButtonMode = .whileEditing
        self.addSubview(txtf)
        txtf.delegate = self
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        Username = self.txtf.text
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class EditProfile: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    let gArray = ["Male", "Female", "Unspecified"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tbView.delegate = self
        tbView.dataSource = self
        tbView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tbView.isScrollEnabled=false
        let TapPressRecognizer = UITapGestureRecognizer(target: self, action: #selector(Tap))
        profilePic.addGestureRecognizer(TapPressRecognizer)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var tbView: UITableView!
    
    @IBAction func picBtn(_ sender: UIButton) {
        let alert = UIAlertController(title: "Change Profile Picture", message: "Choose the way you want to change", preferredStyle: .actionSheet)
        let UPAction = UIAlertAction(title: "Upload Picture", style: .destructive, handler: handleUpload)
        let TPAction = UIAlertAction(title: "Take Photo", style: .destructive, handler: handleTakePhoto)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancel)
        alert.addAction(UPAction)
        alert.addAction(TPAction)
        alert.addAction(CancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            
        }else if indexPath.row == 1{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PickerVC") as! PickerVC
            
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = ciel()
            
            cell.txtf.text = currentUser.profName
            cell.imageView?.image = #imageLiteral(resourceName: "User-20")
            return cell
            
        }
            
        else if indexPath.row == 1 {
            
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
            cell.textLabel?.text = currentUser.gender
//            cell.textLabel?.text = theData.gender
            cell.imageView?.image = #imageLiteral(resourceName: "Gender-20")
            return cell
        }
            
        else{
            let cell =  UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
            cell.textLabel?.text=currentUser.emailAdd
//            cell.textLabel?.text = theData.emailAdd
            cell.imageView?.image = #imageLiteral(resourceName: "Email-20")
            cell.isUserInteractionEnabled=false
            return cell
        }
        
    }
    
    
    
    
    
    @IBAction func Save(_ sender: UIButton) {
        UpdateInfo()
        self.dismiss(animated: true, completion: nil)
    }
   
    
    
    
    func UpdateInfo(){
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
                                "proPic" : url.absoluteString,
                                "proName" : Username!,
                                "gender" : "Unspecified",
                                "postID" : key] as [String : Any]
                    
                    
                    let childUpdates = ["/users/\(key)/": feed]
                    ref.updateChildValues(childUpdates)
                    
                    
//                    let postFeed = ["\(key)" : feed]
//                    
//                    ref.child("users").updateChildValues(postFeed)
                    
                    self.dismiss(animated: true, completion: nil)
                }
            })
            
        }
        
        uploadTask.resume()
        
    }

    
    @IBAction func Cancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func Tap(sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Change Profile Picture", message: "Choose the way you want to change", preferredStyle: .actionSheet)
        let UPAction = UIAlertAction(title: "Upload Picture", style: .destructive, handler: handleUpload)
        let TPAction = UIAlertAction(title: "Take Photo", style: .destructive, handler: handleTakePhoto)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancel)
        alert.addAction(UPAction)
        alert.addAction(TPAction)
        alert.addAction(CancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    var picker: UIImagePickerController!
    func handleUpload(alertAction: UIAlertAction!) -> Void {
        picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
        
    }
    
    func handleTakePhoto(alertAction: UIAlertAction!) -> Void {
        picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        profilePic.downloadImage(from: currentUser.profPic)
       // dismiss(animated: true, completion: nil)
        
    }
    
    
    func cancel(alertAction: UIAlertAction!) {
    }
    

    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension UIImageView {
    
    func downloadImage(from imgURL: String!) {
        let url = URLRequest(url: URL(string: imgURL)!)
        
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
            
        }
        
        task.resume()
    }
}
