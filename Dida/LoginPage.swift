//
//  LoginPage.swift
//  Dida
//
//  Created by 李政含 on 4/11/17.
//
//

import UIKit
import Firebase
import FirebaseAuth

var currentUser:user!

class LoginPage:UIViewController, UITextFieldDelegate{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LoginPage.dismissKeyboard)))
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func dismissKeyboard(){
        email.resignFirstResponder()
        password.resignFirstResponder()
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.SV.endEditing(true)
//        super.touchesBegan(touches, with: event)
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBOutlet weak var SV: UIScrollView!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        SV.setContentOffset(CGPoint(x: 0, y: 250), animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        SV.setContentOffset(CGPoint(x:0,y:0), animated: true)
    }
    @IBAction func SignUpClick(_ sender: Any) {
        self.performSegue(withIdentifier: "showSignUp", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSignUp" {
        }
        
       
    }
    @IBAction func LogIn(_ sender: UIButton) {
        if self.email.text == "" || self.password.text == "" {
            
            //Alert to tell the user that there was an error because they didn't fill anything in the textfields because they didn't fill anything in
            
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            FIRAuth.auth()?.signIn(withEmail: self.email.text!, password: self.password.text!) { (user, error) in
                
                if error == nil {
                    print("You have successfully logged in")
                    self.fetchUser()
                    self.performSegue(withIdentifier: "show", sender: self)
                } else {
                    
                    //Tells the user that there is an error and then gets firebase to tell them the error
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    func fetchUser(){
        var ref: FIRDatabaseReference!
        
        ref = FIRDatabase.database().reference().child("users")
        
        ref?.queryOrderedByKey().observe(.value, with: { snapshot in
            let postDict = snapshot.value as? [String:Any]
            for p in postDict! {
                let obj=p.value as? [String:Any]
                if let author = obj?["emailAdd"] as! String?
                {
                    if author == self.email.text!{
                        currentUser = user(profName: (obj?["proName"] as! String), emailAdd: (obj?["emailAdd"] as! String), profPic: (obj?["proPic"] as! String), gender: obj?["gender"] as? String), postID: (obj?["postID"] as! String)
                    }
                }
            }
        }
            
        )
    }

}
