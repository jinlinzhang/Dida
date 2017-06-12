//
//  EditProViewController.swift
//  Dida
//
//  Created by Cancan Li on 4/12/17.
//
//

import UIKit

class EditProViewController: UIViewController {

    @IBOutlet weak var navigItem: UINavigationItem!
   
    let Done  = UIButton{
        let button = UIButton
        button.title("Done")
        return button
    }()
    
    let Cancel = UIButton {
        let cbutton = UIButton
        cbutton.title("Cancel")
        return cbutton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = Done
        self.navigationItem.leftBarButtonItem = Cancel

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
