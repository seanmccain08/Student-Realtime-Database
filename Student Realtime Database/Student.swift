//
//  Student.swift
//  Student Realtime Database
//
//  Created by SEAN MCCAIN on 2/4/25.
//

import Foundation
import FirebaseCore
import FirebaseDatabase

class Student{
    
    var name : String
    var age : Int
    var key : String
    let ref = Database.database().reference()
    
    init(name: String, age: Int) {
        
        self.name = name
        self.age = age
        self.key = ""
        
    }
    
    init(dict:[String:Any]){
        
        // Safely unwrapping values from dictionary
        if let a = dict["age"] as? Int{
            age = a
        }
        else{
            age = 0
        }
        
        if let n = dict["name"] as? String{
            name = n
        }
        else{
            name = ""
        }
        self.key = ""
        
    }
    
    func saveToFirebase(){
        
        let dict = ["name":name, "age":age] as [String:Any]
        ref.child("students2").childByAutoId().setValue(dict)
        key = ref.child("students2").childByAutoId().key ?? "0"
        
    }
    
    func deleteFromFirebase(){
        
        ref.child("students2").child(key).removeValue()
        
    }
    
    func updateFirebase(dict: [String: Any]){
        
           ref.child("students2").child(key).updateChildValues(dict)
        
    }
    
}
