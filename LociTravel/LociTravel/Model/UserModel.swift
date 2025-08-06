//
//  UserModel.swift
//  LociTravel
//
//  Created by chohoseo on 8/6/25.
//

import Foundation

class UserModel {
    static let shared = UserModel()
    
    
    // UserDefaults에 접근하기 위한 키를 정의합니다.
    private let questProgressKey = "questProgress"
    private let itemsKey = "userItems"
    
    var questProgress: [String]
    var items: [String]
    
    // 이니셜라이저에서 UserDefaults에 저장된 데이터를 불러옵니다.
        // 만약 데이터가 없으면 빈 배열로 초기화합니다.
        private init() {
            self.questProgress = UserDefaults.standard.stringArray(forKey: questProgressKey) ?? []
            self.items = UserDefaults.standard.stringArray(forKey: itemsKey) ?? []
        }
        
        // MARK: - Public Methods
        
        /// 현재까지 완료된 퀘스트 목록을 반환합니다.
        public func getQuestProgress() -> [String] {
            return questProgress
        }
        
        /// 현재 보유한 아이템 목록을 반환합니다.
        public func getItems() -> [String] {
            return items
        }
        
        /// 새로운 퀘스트를 완료 목록에 추가하고 저장합니다.
        /// - Parameter questName: 완료된 퀘스트의 고유 이름
        public func completeQuest(_ questName: String) {
            // 이미 완료된 퀘스트라면 중복 추가하지 않습니다.
            if !questProgress.contains(questName) {
                questProgress.append(questName)
                saveData() // 데이터 저장
                print("퀘스트 완료: \(questName)")
            }
        }
        
        /// 새로운 아이템을 추가하고 저장합니다.
        /// - Parameter itemName: 추가할 아이템의 고유 이름
        public func addItem(_ itemName: String) {
            // 이미 보유한 아이템이라면 중복 추가하지 않습니다.
            if !items.contains(itemName) {
                items.append(itemName)
                saveData() // 데이터 저장
                print("아이템 획득: \(itemName)")
            }
        }
        
        // MARK: - Private Helper Method
        
        /// 퀘스트 진행 상황과 아이템 목록을 UserDefaults에 저장합니다.
        private func saveData() {
            UserDefaults.standard.set(questProgress, forKey: questProgressKey)
            UserDefaults.standard.set(items, forKey: itemsKey)
        }
        
        /// 모든 저장된 데이터를 초기화합니다. (디버깅용)
        public func resetData() {
            UserDefaults.standard.removeObject(forKey: questProgressKey)
            UserDefaults.standard.removeObject(forKey: itemsKey)
            questProgress.removeAll()
            items.removeAll()
            print("모든 유저 데이터가 초기화되었습니다.")
        }
    
    
//    private init() {
//        questProgress = ["서동시장", "보석박물관", "미륵사지", "서동공원", "왕궁리유적"]
//        items = ["기억의 조각_0"]
//    }
//    
//    public func getQuestProgress() -> [String] {
//            return questProgress
//        }
 
}
