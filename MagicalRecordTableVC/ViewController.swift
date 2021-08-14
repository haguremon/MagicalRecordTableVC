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
    //let context = NSManagedObjectContext.mr_default()
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
   
    @IBAction func userRegister(_ sender: UIButton) {
        
        guard let username = textField.text ,
              !username.isEmpty else { return }
        
        newUserData(name: username)
        createTasksDataAll()
        print(users)
    }
    
    //coreDataのCRUD等
    func createTasksDataAll(){
        
        guard let userAllData = User.mr_findAll() as? [User] else { return }
        
        users = userAllData
        

            tableView.reloadData()
        
    }

    func newUserData(name: String){
        //特定のコンテキストにエンティティを作成する
        guard let user = User.mr_createEntity(in: mycontext) else { return }
        user.name = name
        user.id = String(UUID().uuidString.dropLast(30)) as String
        
        user.createAt = Date()
        
        mycontext.mr_saveToPersistentStoreAndWait()
      
        
        
        
    }
    func upDateusernameData(user: User, name: String) {
        user.name = name
        mycontext.mr_saveToPersistentStoreAndWait()

        createTasksDataAll()
        
    }
    
    func deleteUserData(user: User) {
        user.mr_deleteEntity(in: mycontext)
       
        mycontext.mr_saveToPersistentStoreAndWait()
        
        createTasksDataAll()
        
    }
    
    func presentDialog(user: User){
        
        let dialog = UIAlertController(title: "編集", message: "変更しますか？", preferredStyle: .alert)
        dialog.addTextField(configurationHandler: nil)
        dialog.textFields?.first?.text = user.name
        
        let edit = UIAlertAction(title: "edit", style: .default) { [ weak self ] _ in
            guard let field = dialog.textFields?.first,
                  let editData = field.text, !editData.isEmpty else { return }
            self?.upDateusernameData(user: user, name: editData)
            self?.createTasksDataAll()
        }
        
        let delete = UIAlertAction(title: "delete", style: .default) { [ weak self ] _ in
        
            self?.deleteUserData(user: user)
        
           
            
            
            
            print(self?.users ?? "")

        }
        
        let cancel = UIAlertAction(title: "cancel", style: .cancel)
        
        dialog.addAction(edit)
        
        dialog.addAction(delete)
        
        dialog.addAction(cancel)
        
        self.present(dialog, animated: true)
            
    }
}
extension ViewController: UITableViewDataSource , UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewController.cellid, for: indexPath)
        
        
        cell.textLabel?.text = users[indexPath.item].name
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user = users[indexPath.row]
        
        presentDialog(user: user)
    
    }
    
    
    
}
