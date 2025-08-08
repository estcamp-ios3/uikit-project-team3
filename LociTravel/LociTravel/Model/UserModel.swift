//
//  UserModel.swift
//  LociTravel
//
//  Created by chohoseo on 8/6/25.
//

import Foundation

class UserModel {
    static let shared = UserModel()
    
    private var questProgress: [String]
    private var items: [String]
    
    private init() {
        questProgress = []
        items = ["기억의 조각_0"]
    }
    
    public func getQuestProgress() -> [String] {
        return questProgress
    }
    
    public func getItems() -> [String] {
        return items
    }
    
    public func addQuestProgress(_ placeName: String) {
        questProgress.append(placeName)
    }
    
    public func addItem(_ itemName: String) {
        items.append(itemName)
    }
    
    public func clearAll() {
        questProgress = []
        items = []
    }
    
    public func removeItem(item: String) {
        items = items.filter { $0 != item }
    }
}
