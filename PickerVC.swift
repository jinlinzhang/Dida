//
//  PickerVC.swift
//  yyy
//
//  Created by Cancan Li on 4/17/17.
//  Copyright © 2017 Cancan Li. All rights reserved.
//

import UIKit

extension CGRect{
    init(_ x:CGFloat,_ y:CGFloat,_ width:CGFloat,_ height:CGFloat) {
        self.init(x:x,y:y,width:width,height:height)
    }
    
}

class PickerVC: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource {
    
//    @available(iOS 2.0, *)
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 3
//    }

    
    var pickerView: UIPickerView!
    
    var gArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gArray = ["Female", "Male", "Unspecified"]
        
        
        pickerView = UIPickerView(frame: CGRect(0, self.view.frame.height - 200, self.view.frame.width, 200))
        pickerView.delegate = self
        pickerView.dataSource = self
        
        // initialize myPickerView
        pickerView = UIPickerView(frame: CGRect(0, self.view.frame.height - 200, self.view.frame.width, 200))
        pickerView.delegate = self
  //      pickerView.dataSource = self
        
        self.view.addSubview(pickerView)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(component == 0){
            return gArray.count
        }
        return 0
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(component == 0){
            return gArray[row]
        }
        return nil
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(component == 0){
            print("gender selected: \(gArray[row])")
            currentUser.gender=gArray[row]
        }
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
