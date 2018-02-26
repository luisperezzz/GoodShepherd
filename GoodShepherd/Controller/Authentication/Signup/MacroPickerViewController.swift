//
//  MacroPickerViewController.swift
//  GoodShepherd
//
//  Created by Luis Arturo Perez Ramirez on 2/21/18.
//  Copyright © 2018 Term. All rights reserved.
//

import UIKit

class MacroPickerViewController: UIViewController {
    
    @IBOutlet weak var macroLeaderTableViewContainer: UIView!
    @IBOutlet weak var macroLeadersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCell()
    }
    
    func registerCell() {
        let bundle = UINib(nibName: "MacroLeaderTVCell", bundle: nil)
        self.macroLeadersTableView.register(bundle, forCellReuseIdentifier: "MacroLeaderTVCell")
        self.macroLeaderTableViewContainer.applyShadow()
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

extension MacroPickerViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MacroLeaderTVCell", for: indexPath)
        return cell
    }
    
}

extension MacroPickerViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
