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
        let contactsVC = CNContactPickerViewController()
        self.present(contactsVC, animated: true, completion: nil)
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
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        print("selected contact: \(contact)")
    }
    
}
