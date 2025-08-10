//
//  Quest.swift
//  LociTravel
//
//  Created by suji chae on 8/6/25.
//

import Foundation
import UIKit
import CoreLocation

// MARK: - Quest 데이터 모델
struct Quest {
    let spotName: String
    let questName: String
    let questDetail: String
    let bgm: String
    var isCompleted: Bool
}

struct Item {
    let questName: String
    let itemImage: String
    let itemName: String
    let itemDetail: String
    let isRandom: Bool
    let itemLongitude: Double
    let itemLatitude: Double
}

/// 자객(이동 NPC) 데이터
struct Assassin {
    let questName: String
    let imageName: String           // e.g. "icon_assassin_0"
    let start: CLLocationCoordinate2D
    let end: CLLocationCoordinate2D
    let speedMPS: CLLocationSpeed   // m/s (예: 1.5 = 걷기)
    let prefersWalking: Bool        // true: 보행경로, false: 자동차경로
}

final class QuestModel {
    static let shared = QuestModel()

    private var quests: [Quest] = []
    private var items: [Item] = []
    private var assassins: [Assassin] = []

    private init() {
        quests = [
            Quest(spotName: "서동시장",
                  questName: "고구마 배달", questDetail: "시장 상인들에게 고구마를 배달하라",
                  bgm: "motivity", isCompleted: false),
            Quest(spotName: "보석 박물관",
                  questName: "잃어버린 목걸이", questDetail: "도둑에게서 목걸이를 되찾으세요",
                  bgm: "motivity", isCompleted: false),
            Quest(spotName: "미륵사지",
                  questName: "목걸이의 비밀", questDetail: "승려에게 찢어진 고서를 모두 찾아주세요",
                  bgm: "motivity", isCompleted: false),
            Quest(spotName: "서동공원",
                  questName: "진실한 사랑", questDetail: "서동을 찾아 그의 마음을 확인하세요",
                  bgm: "motivity", isCompleted: false),
            Quest(spotName: "왕궁리 유적",
                  questName: "평화의 왕", questDetail: "고서의 내용을 백성들에게 전파하세요",
                  bgm: "motivity", isCompleted: false),
        ]

        // ✅ 아이템 목록(자객은 여기서 제거!)
        items = [
            Item(questName: "고구마 배달",
                 itemImage: "sweetpotato", itemName: "고구마",
                 itemDetail: "싱싱한 고구마",
                 isRandom: true,
                 itemLongitude: 126.957370, itemLatitude: 35.953040),

            // 🔻 (기존에 자객을 아이템으로 넣었던 레코드는 삭제)

            Item(questName: "목걸이의 비밀",
                 itemImage: "oldpaper", itemName: "찢어진 고서",
                 itemDetail: "낡은 고서, 찢어져 있어 글의 내용을 알아볼 수 없다.",
                 isRandom: true,
                 itemLongitude: 127.030435, itemLatitude: 36.012300),

            Item(questName: "진실한 사랑",
                 itemImage: "brokenheart", itemName: "아픈 마음",
                 itemDetail: "...",
                 isRandom: true,
                 itemLongitude: 127.057281, itemLatitude: 36.001081),

            Item(questName: "평화의 왕",
                 itemImage: "mans", itemName: "백성",
                 itemDetail: "...",
                 isRandom: true,
                 itemLongitude: 127.054876, itemLatitude: 35.973552)
        ]

        // ✅ 퀘스트별 자객 정의 (필요한 퀘스트에만)
        assassins = [
            Assassin(
                questName: "잃어버린 목걸이",
                imageName: "icon_assassin_0",
                start: CLLocationCoordinate2D(latitude: 35.990587, longitude: 127.102335), // 보석박물관
                end:   CLLocationCoordinate2D(latitude: 35.989145, longitude: 127.105042),
                speedMPS: 14,
                prefersWalking: true
            )
            // 다른 퀘스트에 자객을 추가하고 싶으면 이 배열에 더 넣으면 됩니다.
        ]
    }

    // MARK: - Quest
    public func getQuest(spotName: String) -> Quest {
        return quests.first(where: { $0.spotName == spotName }) ?? quests[0]
    }

    public func getAllQuests() -> [Quest] {
        return quests
    }

    // MARK: - Items
    public func getItems(questName: String) -> [Item] {
        return items.filter { $0.questName == questName }
    }

    public func hasItems(questName: String) -> Bool {
        return items.contains { $0.questName == questName }
    }

    // MARK: - Assassin
    public func getAssassin(questName: String) -> Assassin? {
        return assassins.first(where: { $0.questName == questName })
    }

    public func hasAssassin(questName: String) -> Bool {
        return getAssassin(questName: questName) != nil
    }

    // MARK: - Update
    public func updateQuest(spotName: String, completed: Bool = true) -> Bool {
        guard let idx = quests.firstIndex(where: { $0.spotName == spotName }) else {
            print("⚠️ updateQuest: '\(spotName)' 퀘스트를 찾지 못했습니다.")
            return false
        }
        quests[idx].isCompleted = completed
        return true
    }

    public func updateQuestByQuestName(_ questName: String, completed: Bool = true) -> Bool {
        guard let idx = quests.firstIndex(where: { $0.questName == questName }) else {
            print("⚠️ updateQuestByQuestName: '\(questName)' 퀘스트를 찾지 못했습니다.")
            return false
        }
        quests[idx].isCompleted = completed
        return true
    }
}
