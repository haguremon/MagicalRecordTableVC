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
    private var index = 0
    
    @IBOutlet weak var selecteSegControl: UISegmentedControl!
    
    
    var users = [User]()
    
    
    //違いがわからん
    let context = NSManagedObjectContext.mr_default()
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        createUsersDataAll()
        let index = UserDefaults.standard.integer(forKey: "index")
        
        selecteSegControl.selectedSegmentIndex = index
        
        cellEditViewSegmentControl(selecteSegControl)
    
    }
    @IBAction func cellEditViewSegmentControl(_ sender: UISegmentedControl) {
        //let userRequest = User.mr_requestAll(in: context)
        switch sender.selectedSegmentIndex {
        case 0:
            tableView.isEditing = false
            index = 0
        case 1:
            tableView.isEditing = true
            index = 1
        case 2:
         
            let userRequest = User.mr_requestAllSorted(by: "createAt", ascending: true, with: nil)
//            let controller = User.mr_fetchController(userRequest, delegate: nil, useFileCache: false, groupedBy: nil, in: context)
//            controller.fetchRequest.includesSubentities = false
            //User.mr_performFetch(controller)
           // let userfetchRequest =  controller.fetchRequest
            
            guard let users = User.mr_executeFetchRequest(userRequest) as? [User] else { return }
            
            
            
            
           self.users = users
            
            DispatchQueue.main.async {
               
                self.tableView.reloadData()
            
            }
            
            index = 2
            //print(users)
            
            
        case 3:
            

            let userRequest = User.mr_requestAllSorted(by: "createAt", ascending: false, with: nil)
//            let controller = User.mr_fetchController(userRequest, delegate: nil, useFileCache: false, groupedBy: nil, in: context)
//            controller.fetchRequest.includesSubentities = false
//            User.mr_performFetch(controller)
//            let userfetchRequest =  controller.fetchRequest
            
            guard let users = User.mr_executeFetchRequest(userRequest) as? [User] else { return }
            
            
            
            
            self.users = users
            
            DispatchQueue.main.async {
               
                self.tableView.reloadData()
            
            }
            
            
            index = 3
        default:
            print("")
            
            
        }
        
        UserDefaults.standard.set(index, forKey: "index")
        
    }
    
    
    @IBAction func userRegister(_ sender: UIButton) {
        
        guard let username = textField.text ,
              !username.isEmpty else { return }
        
        newUserData(name: username)

        print(users)
    }
    
    //coreDataのCRUD等
    func createUsersDataAll(){
        
        guard let userAllData = User.mr_findAll() as? [User] else { return }
        
        users = userAllData
        
        DispatchQueue.main.async {
            
            self.tableView.reloadData()
            
        }
        
    }
    
    func newUserData(name: String){
        //特定のコンテキストにエンティティを作成する
        guard let user = User.mr_createEntity(in: context) else { return }
        user.name = name
        user.id = String(UUID().uuidString.dropLast(30)) as String
        
        user.createAt = Date()
        
        context.mr_saveToPersistentStoreAndWait()
        DispatchQueue.main.async {
            
            self.createUsersDataAll()
            
        }
        
        
        
        
    }
    func upDateusernameData(user: User, name: String) {
        user.name = name
        context.mr_saveToPersistentStoreAndWait()
        
        createUsersDataAll()
        
    }
    
    func deleteUserData(user: User) {
        user.mr_deleteEntity(in: context)
        
        context.mr_saveToPersistentStoreAndWait()
        
        createUsersDataAll()
        
    }
    func searchingData() {
        
        
    }
    
    
    func presentDialog(user: User){
        
        let dialog = UIAlertController(title: "編集", message: "変更しますか？", preferredStyle: .alert)
        dialog.addTextField(configurationHandler: nil)
        dialog.textFields?.first?.text = user.name
        
        let edit = UIAlertAction(title: "edit", style: .default) { [ weak self ] _ in
            
            guard let field = dialog.textFields?.first,
                  let editData = field.text, !editData.isEmpty else { return }
            
            
            self?.upDateusernameData(user: user, name: editData)
            
            print(self?.users ?? "")
            
        }
        
        let delete = UIAlertAction(title: "delete", style: .default) { [ weak self ] _ in
            
            
            self?.deleteUserData(user: user)
            
            print(self?.users ?? "")
            
        }
        
        let cancel = UIAlertAction(title: "cancel", style: .cancel)
        
        dialog.addAction(edit)
        
        dialog.addAction(delete)
        
        dialog.addAction(cancel)
        
        
        self.present(dialog, animated: true) {
            
            print(self.users)
            
        }
        
    }
    func searchingData(name: String) {
        
        let predicate = NSPredicate(format: "name == %@",name)//name一致したやつを指定
        let fetchRequest = User.mr_requestAll(with: predicate)
       
        
        //fetchRequest.predicate = predicate
        guard let username = User.mr_executeFetchRequest(fetchRequest) as? [User] else { return }
        self.users = username
        
        DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        
    }
    func searchResultdalog(message: String){
        let dalog = UIAlertController(title: "検索結果", message: message, preferredStyle: .alert)
        dalog.addAction(UIAlertAction(title: "Cancel", style: .cancel))
       present(dalog, animated: true, completion: nil)
    }
    
    
    @IBAction func searchingButton(_ sender: UIButton) {
        guard let name = textField.text, !name.isEmpty  else {
            searchResultdalog(message: "値を入れてください")
            return
            
        }
        searchingData(name: name)
        
        guard !users.isEmpty else {
            searchResultdalog(message: "値がヒットしませんでした")
            
            createUsersDataAll()
            
            return
        }
        searchResultdalog(message: "\(users.count)件ヒットしました")
            
         
 
        
       
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            
            self.createUsersDataAll()
       
        }
        
   
    
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
        
        cell.textLabel?.text = users[indexPath.row].name
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user = users[indexPath.row]
        
        presentDialog(user: user)
        
    }
    
    
    
}
