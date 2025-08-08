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
    let themeName: String
    let color: UIColor
    let questName: String
    let questDetail: String
    let item: [Item]
    let bgm: String
    let isCompleted: Bool
}

struct Item {
    let itemImage: String
    let itemName: String
    let itemDetail: String
    let isRandom: Bool
    let itemLongtitude: Double
    let itemLatitude: Double
}

class QuestModel {
    static let shared = QuestModel()
    private var quests: [Quest] = []
    private init() {
        quests = [
         
            Quest(
                spotName: "서동시장", themeName: "잊혀진 유산",
                color: .yellow,
                questName: "금가락지 소동", questDetail: "아주머니의 잃어버린 금가락지를 찾아라",
                item: [
                    Item(itemImage: "golden_ring", itemName: "금가락지", itemDetail: "투박한 금가락지",
                         isRandom: true,
                         itemLongtitude: 126.957370, itemLatitude: 35.953040),
                    Item(itemImage: "part_0", itemName: "기억의 조각", itemDetail: "기억의 일부",
                         isRandom: true,
                         itemLongtitude: 0,
                         itemLatitude: 0),
                ],
                bgm: "motivity",
                isCompleted: false
            ),
            
            Quest(
                spotName: "보석박물관", themeName: "없음",
                color: .yellow,
                questName: "보석박물관에서 보석찾기", questDetail: "찾아라 내보물",
                item: [
                    Item(itemImage: "없음", itemName: "없음", itemDetail: "없음",
                         isRandom: true,
                         itemLongtitude: 126.957370, itemLatitude: 35.953040),
                    Item(itemImage: "없음", itemName: "없음", itemDetail: "없음",
                         isRandom: true,
                         itemLongtitude: 0,
                         itemLatitude: 0),
                ],
                bgm: "없음",
                isCompleted: true
            ),
            
            Quest(
                spotName: "미륵사지", themeName: "없음",
                color: .yellow,
                questName: "석탑을 둘러보자", questDetail: "석탑 주변의 보물찾기",
                item: [
                    Item(itemImage: "없음", itemName: "없음", itemDetail: "없음",
                         isRandom: true,
                         itemLongtitude: 126.957370, itemLatitude: 35.953040),
                    Item(itemImage: "없음", itemName: "없음", itemDetail: "없음",
                         isRandom: true,
                         itemLongtitude: 0,
                         itemLatitude: 0),
                ],
                bgm: "없음",
                isCompleted: false
            ),
            
            Quest(
                spotName: "서동공원", themeName: "없음",
                color: .yellow,
                questName: "서동공원에서...", questDetail: "선화공주를 찾아라",
                item: [
                    Item(itemImage: "없음", itemName: "없음", itemDetail: "없음",
                         isRandom: true,
                         itemLongtitude: 126.957370, itemLatitude: 35.953040),
                    Item(itemImage: "없음", itemName: "없음", itemDetail: "없음",
                         isRandom: true,
                         itemLongtitude: 0,
                         itemLatitude: 0),
                ],
                bgm: "없음",
                isCompleted: false
            ),
            
            Quest(
                spotName: "왕궁리 유적 (미션 전)", themeName: "잊혀진 유산",
                color: .yellow, questName: "무왕의 꿈", questDetail: "꿈의 조각을 모아라", item: [
                    Item(itemImage: "memory_0", itemName: "꿈의 조각", itemDetail: "영롱한 빛을 낸다",
                         isRandom: false,
                         itemLongtitude: 127.02, itemLatitude: 37.56),
                    Item(itemImage: "memory_1", itemName: "꿈의 조각", itemDetail: "영롱한 빛을 낸다",
                         isRandom: false,
                         itemLongtitude: 127.07,
                         itemLatitude: 38.00),
                ],
                bgm: "motivity",
                isCompleted: false
            ),
            Quest(
                spotName: "왕궁리 유적 (미션 후)", themeName: "잊혀진 유산",
                color: .yellow, questName: "무왕의 꿈(엔딩)", questDetail: "꿈의 조각을 모아라", item: [
                    Item(itemImage: "memory_0", itemName: "꿈의 조각", itemDetail: "영롱한 빛을 낸다",
                         isRandom: false,
                         itemLongtitude: 127.02, itemLatitude: 37.56),
                    Item(itemImage: "memory_1", itemName: "꿈의 조각", itemDetail: "영롱한 빛을 낸다",
                         isRandom: false,
                         itemLongtitude: 127.07,
                         itemLatitude: 38.00),
                ],
                bgm: "motivity",
                isCompleted: false
            )
            
            
            
        ]
    }
    
    public func getQuest(spotName: String) -> Quest {
        return quests.filter { $0.spotName == spotName }.first ?? quests[0]
    }
    
    public func getAllQuests() -> [Quest] {
        return quests
    }
}
