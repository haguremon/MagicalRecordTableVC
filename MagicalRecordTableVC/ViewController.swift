//
//  ViewController.swift
//  MagicalRecordTableVC
//
//  Created by IwasakIYuta on 2021/08/13.
//

import UIKit
import MagicalRecord
class ViewController: UIViewController {
    static let cellid = "cell"
    var users = [User]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    
    }


}
extension ViewController: UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewController.cellid, for: indexPath)
    
        return cell
    }
    
    
    
}
