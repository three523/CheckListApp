//
//  CheckListTableViewController.swift
//  CheckListApp2
//
//  Created by apple on 2021/04/05.
//

import UIKit

class CheckListTableViewController: UITableViewController {

    @IBOutlet var plusButton: UIButton!
    @IBOutlet var checkListTableView: UITableView!
    
    override func viewDidLoad() {
        
        plusButton.backgroundColor = UIColor(named: "black")
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

}
