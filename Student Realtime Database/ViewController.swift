//
//  ViewController.swift
//  Student Realtime Database
//
//  Created by SEAN MCCAIN on 1/30/25.
//

import UIKit
import FirebaseCore
import FirebaseDatabase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var ref: DatabaseReference!
    var students = [Student]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
       
        ref = Database.database().reference()
        
        readDatabase()
        
    }

    @IBAction func buttonAction(_ sender: Any) {
        
        if(nameField.text != "" && ageField.text != ""){
            
            var name = nameField.text!
            var age = Int(ageField.text!)!

            let dict = ["name": name, "age":age] as [String: Any]
            ref.child("students2").childByAutoId().setValue(dict)
            
        }
        
        tableView.reloadData()
        
    }
    
    func readDatabase(){
        
        ref.child("students2").observe(.childAdded, with: { (snapshot) in
            // snapshot is a dictionary with a key and a dictionary as a value
            // this gets the dictionary from each snapshot
            let dict = snapshot.value as! [String:Any]
            
            // building a Student object from the dictionary
            let s = Student(dict: dict)
            // adding the student object to the Student array
            s.key = snapshot.key
            
            self.students.append(s)
            self.tableView.reloadData()
        })
        
        //called after .childAdded is done
        ref.child("students2").observeSingleEvent(of: .value, with: { snapshot in
            
            print("--inital load has completed and the last user was read--")
            print(self.students)
            
        })
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return students.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell")!
        
        cell.textLabel?.text = students[indexPath.row].name
        cell.detailTextLabel?.text = "\(students[indexPath.row].age)"
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if(editingStyle == .delete){
            
            students[indexPath.row].deleteFromFirebase()
            students.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
        
    }

}
