//
//  UserModel.swift
//  LociTravel
//
//  Created by chohoseo on 8/6/25.
//

import Foundation

//진행상태가 바뀌면(이어하기 가능) 버튼 갱신 등을 위해 보낼 알림 이름
extension Notification.Name {
    static let progressDidChange = Notification.Name("UserModel.progressDidChange")
}

extension UserModel {
    /// 저장된 진행이 하나라도 있으면 true
    var hasResumeData: Bool {
        // GameProgress가 있거나, 퀘스트 로그가 비어있지 않으면 이어하기 가능
        return progress != nil || !questProgress.isEmpty
    }
    /// 마지막 진행 스팟명(없으면 nil)
    var lastSpotName: String? { getQuestProgress().last }
}


class UserModel {
    static let shared = UserModel()
    
    // UserDefaults 키들(버전 붙여서 충돌 방지)
       private let kProgressKey = "GameProgress.v1"
       private let kQuestKey    = "QuestProgress.v1"
       private let kItemsKey    = "Items.v1"
    
    // 이어하기용 진행 상태 (설정될 때마다 자동 저장 + 알림)
       var progress: GameProgress? {
           didSet {
               saveProgress()
               NotificationCenter.default.post(name: .progressDidChange, object: nil)
           }
       }
    
    // 외부에서는 읽기만 가능하게(통째 교체를 막아 안전)
        private(set) var questProgress: [String] = []
        private(set) var items: [String] = []

        // ✅ 단 하나의 초기화 구간만 사용
        private init() {
            loadAllFromDisk()                    // 앱 시작 시 디스크에서 복구
            if items.isEmpty {                   // 첫 실행일 때만 기본 아이템 추가
                items = ["기억의 조각_0"]
                saveItems()
            }
        }
    
    // MARK: - Public API (팀 코드 호환: 기존 이름/라벨 그대로 유지)

      /// 퀘스트 완료 체크(중복 추가 방지 + 즉시 저장)
      func addQuestProgress(_ id: String) {
          guard !questProgress.contains(id) else { return }
          questProgress.append(id)
          saveQuests()
      }

      /// 아이템 추가(즉시 저장)
      func addItem(_ name: String) {
          items.append(name)
          saveItems()
      }

      /// 아이템 제거(즉시 저장)
      func removeItem(item: String) {
          items.removeAll { $0 == item }
          saveItems()
      }

      /// 모든 진행 초기화(progress는 didSet 통해 저장/알림, 배열은 별도 저장)
      func clearAll() {
          progress = nil
          questProgress.removeAll()
          items.removeAll()
          saveQuests()
          saveItems()
      }

      /// 팀원이 쓰고 있을 수 있는 읽기 함수들(그대로 둬도 됨)
      public func getQuestProgress() -> [String] { questProgress }
      public func getItems() -> [String] { items }

      // MARK: - 저장/로드 (UserDefaults)

      private func saveProgress() {
          if let p = progress, let data = try? JSONEncoder().encode(p) {
              UserDefaults.standard.set(data, forKey: kProgressKey)
          } else {
              UserDefaults.standard.removeObject(forKey: kProgressKey)
          }
      }

      private func loadProgress() {
          guard let data = UserDefaults.standard.data(forKey: kProgressKey),
                let p = try? JSONDecoder().decode(GameProgress.self, from: data) else { return }
          // progress에 대입하면 위 didSet이 호출되어 저장/알림이 한 번 더 돌지만, 부작용은 없음
          progress = p
      }

      private func saveQuests() {
          UserDefaults.standard.set(questProgress, forKey: kQuestKey)
      }

      private func loadQuests() {
          if let arr = UserDefaults.standard.stringArray(forKey: kQuestKey) {
              questProgress = arr
          }
      }

      private func saveItems() {
          UserDefaults.standard.set(items, forKey: kItemsKey)
      }

      private func loadItems() {
          if let arr = UserDefaults.standard.stringArray(forKey: kItemsKey) {
              items = arr
          }
      }

      private func loadAllFromDisk() {
          loadQuests()
          loadItems()
          loadProgress()
      }
  }
    
    
    
