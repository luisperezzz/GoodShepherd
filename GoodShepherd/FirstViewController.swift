//
//  FirstViewController.swift
//  GoodShepherd
//
//  Created by Term on 8/2/17.
//  Copyright © 2017 Term. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin

class FirstViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var friendsButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if AccessToken.current != nil {
            print("ya esta logeado")
            self.loginButton.setTitle("Log Out", for: .normal)
            
            
            
            
            
        }
        else {
            print("no esta logeado")
            self.loginButton.setTitle("Log In", for: .normal)
        }
        
        
        
    }
    
    @IBAction func loginAction() {
        let loginManager = LoginManager()
        if AccessToken.current != nil {
            print("ya esta logeado")
            loginManager.logOut()
            self.loginButton.setTitle("Log In", for: .normal)
        }
        else {
            print("no esta logeado")
            loginManager.logIn([.userFriends], viewController: self, completion: { (loginResult) in
                switch loginResult {
                case .failed(let error):
                    print(error)
                case .cancelled:
                    print("User cancelled login.")
                case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                    print("granted permissions: \(grantedPermissions)")
                    print("declined permissions: \(declinedPermissions)")
                    print("access token: \(accessToken)")
                    self.loginButton.setTitle("Log Out", for: .normal)
                }
            })
            
           
                
        }
    }
    
    @IBAction func getFriends(_ sender: UIButton) {
        self.requestFriends()
    }
    
    func requestFriends() {
        let graphRequest = GraphRequest(graphPath: "/me/taggable_friends", parameters: ["fields": "email, name, gender, picture, birthday, hometown"], accessToken: AccessToken.current, httpMethod: .GET, apiVersion: GraphAPIVersion.defaultVersion)
        
        graphRequest.start { (response, result) in
            switch result {
            case .failed(let error):
                print("error: \(error)")
            case .success(let response):
                print("response data: \(response)")
                let summaryDict = response.dictionaryValue!
                
                
                
            }
        }
    }
    
 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

extension FirstViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "hey"
        return cell
    }
}


extension FirstViewController: UITableViewDelegate {
    
}
