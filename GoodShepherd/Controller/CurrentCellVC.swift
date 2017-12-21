//
//  CurrentCellVC.swift
//  GoodShepherd
//
//  Created by Term on 8/10/17.
//  Copyright © 2017 Term. All rights reserved.
//

import UIKit
import ContactsUI

class CurrentCellVC: UIViewController {
    
    @IBOutlet weak var sheepTableView: UITableView!
    
    var sheeps = [Sheep]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addSheepAction(_ sender: UIBarButtonItem) {
        
        ContactManager.requestContacts { (contacts, error) in
            
            if error == nil {
                print("Contacts: \(contacts)")
            }
            else {
                switch error!.code {
                case ErrorCode.contactAccessDenied.rawValue:
                    let alert = UIAlertController(title: error!.localizedDescription, message: "Enable access in Settings", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (alertAction) in
                        UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!)
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                case ErrorCode.contactAccessRestricted.rawValue:
                    let alert = UIAlertController(title: error!.localizedDescription, message: "Check the app restrictions first", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                default:
                    break
                    
                }
                
            }
        }
   
    }
    
    
    
   
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}

extension CurrentCellVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SheepSummary", for: indexPath) as! SheepSummaryTVCell
        cell.fullNameLabel.text = "Luis Perez"
        return cell
    }
}

extension CurrentCellVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}

extension CurrentCellVC: CNContactPickerDelegate {
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        
    }
    
}
