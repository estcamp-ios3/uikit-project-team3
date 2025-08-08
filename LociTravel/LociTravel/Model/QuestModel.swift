//
//  Quest.swift
//  LociTravel
//
//  Created by suji chae on 8/6/25.
//

import Foundation
import UIKit

// MARK: - Quest 데이터 모델
struct Quest {
    let spotName: String
    let questName: String
    let questDetail: String
    let bgm: String
    let isCompleted: Bool
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

class QuestModel {
    static let shared = QuestModel()
    private var quests: [Quest] = []
    private var items: [Item] = []
    
    private init() {
        quests = [
            Quest(
                spotName: "없음",
                questName: "없음", questDetail: "없음",
                bgm: "없음",
                isCompleted: false
            ),
            Quest(
                spotName: "서동시장",
                questName: "고구마 배달", questDetail: "시장 상인들에게 고구마를 배달하라",
                bgm: "motivity",
                isCompleted: false
            ),
            Quest(
                spotName: "보석박물관",
                questName: "잃어버린 목걸이", questDetail: "도둑에게서 목걸이를 되찾으세요",
                bgm: "motivity",
                isCompleted: false
            ),
            Quest(
                spotName: "미륵사지",
                questName: "목걸이의 비밀", questDetail: "승려에게 찢어진 고서를 모두 찾아주세요",
                bgm: "motivity",
                isCompleted: false
            ),
            Quest(
                spotName: "서동공원",
                questName: "진실한 사랑", questDetail: "서동을 찾아 그의 마음을 확인하세요",
                bgm: "motivity",
                isCompleted: false
            ),Quest(
                spotName: "왕궁리 유적",
                questName: "평화의 왕", questDetail: "고서의 내용을 백성들에게 전파하세요",
                bgm: "motivity",
                isCompleted: false
            ),
        ]
        
        items = [
            Item(questName: "고구마 배달", itemImage: "sweetpotato", itemName: "고구마", itemDetail: "싱싱한 고구마",
                 isRandom: true,
                 itemLongitude: 126.957370, itemLatitude: 35.953040),
            Item(questName: "잃어버린 목걸이", itemImage: "necklace", itemName: "서동의 목걸이", itemDetail: "王者非血... 繼之者也",
                 isRandom: false,
                 itemLongitude: 0,
                 itemLatitude: 0),
            Item(questName: "목걸이의 비밀", itemImage: "oldpaper", itemName: "찢어진 고서", itemDetail: "낡은 고서, 찢어져 있어 글의 내용을 알아볼 수 없다.", isRandom: true, itemLongitude: 0, itemLatitude: 0),
            Item(questName: "진실한 사랑", itemImage: "brokenheart", itemName: "아픈 마음", itemDetail: "...", isRandom: true, itemLongitude: 0, itemLatitude: 0),
            Item(questName: "평화의 왕", itemImage: "mans", itemName: "백성", itemDetail: "...", isRandom: true, itemLongitude: 0, itemLatitude: 0)
        ]
    }
    
    public func getQuest(spotName: String) -> Quest {
        return quests.filter { $0.spotName == spotName }.first ?? quests[0]
    }
    
    public func getAllQuests() -> [Quest] {
        return quests
    }
    
    public func getItems(questName: String) -> [Item] {
        return items.filter { $0.questName == questName }
    }
}
