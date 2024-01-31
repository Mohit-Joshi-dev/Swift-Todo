//
//  TodoManager.swift
//  Split It
//
//  Created by Mohit Joshi on 20/01/24.
//

import Foundation
import Firebase

class TodoManager {
    
    static let sharedInstance = TodoManager()
    let db = Firestore.firestore()
    var delegate: TodoManagerDelegate?
    
    var todos: [Todo] = []

    
    func getTodos( ){
        
        db.collection(K.FStore.collectionName)
            .order(by: "date")
            .getDocuments{ querySnapshot, error in
            if let e = error {
                print("Error while getting documents \(e)")
            } else {
                self.todos.removeAll()
                var newList: [Todo] = []
                if let documents = querySnapshot?.documents {
                    for doc in documents {
                        do{
                            let todo = try doc.data(as: Todo.self)
                            newList.append(todo)
                        }
                        catch {
                            print(error)
                        }
                    }
                }
                self.todos = newList
                self.delegate?.didReceiveData(data: newList)
            }
        }
    }
    
    func addTodo(todo: Todo){
        do {
            try db.collection(K.FStore.collectionName).addDocument(from: todo)
            getTodos()
        }
        catch{
            print(error)
        }
    }
    
    func deleteTodo(id: String) {
        db.collection(K.FStore.collectionName).document(id).delete()
        getTodos()
    }
    
    func markCompleted(id: String) {
        db.collection(K.FStore.collectionName).document(id).updateData(
                ["isCompleted" : true]
            )
        getTodos()
    }
}

protocol TodoManagerDelegate {
    func didReceiveData(data: [Todo])
    
//    func didDeleteTodo(index: Int)
}
