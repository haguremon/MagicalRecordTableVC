//
//  ViewController.swift
//  MagicalRecordTableVC
//
//  Created by IwasakIYuta on 2021/08/13.
//テスト

import UIKit
import MagicalRecord
class ViewController: UIViewController {
    static let cellid = "cell"
    var users = [User]()
    //違いがわからん
    //let mycontext = NSManagedObjectContext.mr_default()
    let mycontext =  NSManagedObjectContext.mr_()
  //    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        createTasksDataAll()
    }
    
    
    //coreDataのCRUD等
    func createTasksDataAll(){
            
        guard let userAllData = User.mr_findAll() as? [User] else { return }
        
        users = userAllData
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
    }
    @IBAction func userRegister(_ sender: UIButton) {        
        title = "Register"
        sender.title(for: .normal)
        guard let username = textField.text else { return }
        newUserData(name: username)
    }
    func newUserData(name: String){
    //特定のコンテキストにエンティティを作成する
        guard let user = User.mr_createEntity(in: mycontext) else { return }
        
        user.name = name
        
        user.createAt = Date()
        
        mycontext.mr_saveToPersistentStoreAndWait()
        print(user)
        createTasksDataAll()
      
        
    }
    func upDateusernameData(user: User, name: String) {
        user.name = name
        mycontext.mr_saveOnlySelfAndWait()
            
        createTasksDataAll()
  
    }
    //上と似てるから変更できそう
    func upTasksid(user: User, id: Int32) {
        
        user.id = id
        
        mycontext.mr_saveOnlySelfAndWait()
        
        createTasksDataAll()
    
    }
    
    func deleteUserData(user: User) {
        mycontext.delete(user)
        mycontext.mr_saveOnlySelfAndWait()
        createTasksDataAll()

    }
}
extension ViewController: UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewController.cellid, for: indexPath)
    
        cell.textLabel?.text = users[indexPath.row].name
        
        return cell
    }
    
    
    
}
