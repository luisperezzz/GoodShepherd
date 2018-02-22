//
//  LoginViewController.swift
//  GoodShepherd
//
//  Created by Luis Arturo Perez Ramirez on 2/22/18.
//  Copyright © 2018 Term. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func signupAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "SegueMacroPickerViewController", sender: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
