//
//  UserModel.swift
//  LociTravel
//
//  Created by chohoseo on 8/6/25.
//

import Foundation

class UserModel {
    static let shared = UserModel()
    
    var questProgress: [String]
    var items: [String]
    
    private init() {
        questProgress = ["서동시장"]
        items = ["기억의 조각_0"]
    }
}
