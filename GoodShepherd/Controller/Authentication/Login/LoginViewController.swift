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
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func signupAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "SegueMacroPickerViewController", sender: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
