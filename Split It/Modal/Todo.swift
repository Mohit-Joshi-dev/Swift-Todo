//
//  Todo.swift
//  Split It
//
//  Created by Mohit Joshi on 20/01/24.
//

import Foundation
import FirebaseFirestore

struct Todo : Codable {
    @DocumentID var id : String?
    let name:String
    let des: String
    let date: Double
    let isCompleted:Bool
}
