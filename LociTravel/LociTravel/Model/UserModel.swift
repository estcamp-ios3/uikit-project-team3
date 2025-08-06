//
//  UserModel.swift
//  LociTravel
//
//  Created by chohoseo on 8/6/25.
//

import Foundation

struct User: Codable {
    let id: Int
    let name: String
    let questProgress: Int
}

class UserModel {
    static let shared = UserModel()
    
    private var users: [User] = []
    
    private init() {
        users = [
            //User(id: <#T##Int#>, name: <#T##String#>, questProgress: <#T##Int#>),
        ]
    }
}
