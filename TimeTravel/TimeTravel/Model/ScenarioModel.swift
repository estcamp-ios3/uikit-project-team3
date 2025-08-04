//
//  Scenario.swift
//  TimeTravel
//
//  Created by chohoseo on 8/1/25.
//

import Foundation
import UIKit

struct Quest {
    let spotName: String
    let themeName: String
    let color: UIColor
    let questName: String
    let questDetail: String
    let item: [Item]
    let bgm: String
}

struct Item {
    let itemImage: String
    let itemName: String
    let itemDetail: String
    let isRandom: Bool
    let itemLongtitude: Double
    let itemLatitude: Double
}

struct Scenario {
    let themeName: String
    let spotName: String
    let questName: String
    let scenarioImage: String
    let characterImage: String
    let arrScenario: [(speaker: String, line:  String)]
    let bgm: String
}

class ScenarioModel {
    static let shared = ScenarioModel()
    
    private var innerQuests: [Quest] = []
    private var innerScenarios: [Scenario] = []
    
    public var quests: [Quest] {
        return innerQuests
    }
    public var scenarios: [Scenario] {
        return innerScenarios
    }
    
    private init() {
        innerQuests = [
            Quest(
                spotName: "미륵사지", themeName: "잊혀진 유산",
                color: .yellow,
                questName: "금가락지 소동", questDetail: "아주머니의 잃어버린 금가락지를 찾아라",
                item: [
                    Item(itemImage: "golden_ring", itemName: "금가락지", itemDetail: "투박한 금가락지",
                         isRandom: true,
                         itemLongtitude: 0, itemLatitude: 0),
                    Item(itemImage: "part_0", itemName: "기억의 조각", itemDetail: "기억의 일부",
                         isRandom: true,
                         itemLongtitude: 0,
                         itemLatitude: 0),
                ],
                bgm: "motivity"
            ),
            Quest(
                spotName: "왕궁리 유적", themeName: "잊혀진 유산",
                color: .yellow, questName: "무왕의 꿈", questDetail: "꿈의 조각을 모아라", item: [
                    Item(itemImage: "memory_0", itemName: "꿈의 조각", itemDetail: "영롱한 빛을 낸다",
                         isRandom: false,
                         itemLongtitude: 127.02, itemLatitude: 37.56),
                    Item(itemImage: "memory_1", itemName: "꿈의 조각", itemDetail: "영롱한 빛을 낸다",
                         isRandom: false,
                         itemLongtitude: 127.07,
                         itemLatitude: 38.00),
                ],
                bgm: "motivity"
            ),
        ]
        
        innerScenarios = [
            Scenario(themeName: "잊혀진 유산",
                     spotName: "미륵사지",
                     questName: "금가락지 소동", scenarioImage: "background", characterImage: "girl", arrScenario: dialogues_Market, bgm: "market"),
            Scenario(themeName: "잊혀진 유산",
                     spotName: "미륵사지", questName: "금가락지 소동", scenarioImage: "background", characterImage: "girl", arrScenario: dialogues_Market,
                     bgm: "market"),
        ]
    }
    
    public func getQuest(themeName: String, spotName: String) -> Quest {
        return innerQuests.filter { $0.themeName == themeName && $0.spotName ==  spotName }.first ?? innerQuests[0]
    }
    
    public func getScenarios(themeName: String, spotName: String) -> Scenario {
        return innerScenarios.filter { $0.themeName == themeName && $0.spotName ==  spotName }.first ?? innerScenarios[0]
    }
}

// MARK: - 대사 데이터
let dialogues_Market: [(speaker: String, line: String)] = [
    ("선화", "자아~~! 골라골라~!! 여기 질 좋은 비단있어요~!"),
    ("선화", "어휴.. 덥다 더워.. 날씨가 더우니 장사도 잘안되고.."),
    ("아주머니1", "고생 많구나 선화야~ 어서 여기 시~~원한 수박 먹어라"),
    ("선화", "역시 우리 이모~! 이렇게 더운 여름엔 수박이 최고지~!"),
    ("선화", "응? 왜 이렇게 사람들이 웅성대지?"),
    ("아주머니2", "아이고!! 나는 망했네~ 망했어 우리 딸 혼수품으로 줄 금가락지를 잃어버리다니~!!"),
    ("선화", "아주머니 진정하세요. 제가 도와드릴게요. 혹시 기억나는게 있으세요?"),
    ("아주머니2", "사물놀이패 장단에 맞춰 정신없이 엉덩이를 흔들다 보니 금가락지가 도망간 모양이야"),
    ("아주머니2", "장담컨데 분명 그전까진 있었다고. 이 근처 어딘가에 떨어졌을것 같긴한데.. "),
    ("선화", "(이 아줌마.. 정상아니군..) 걱정마세요~! ^^ 제가 도와드릴게요. 이 근방은 제가 빠삭하게 잘아니까 얼른 찾아드릴께요~!"),
    ("선화", "(히히 찾으면 내꺼라구~!!    \\(^,^)/")
]

let dialogues_Palas: [(speaker: String, line: String)] = [
    ("선화", "자아~~! 골라골라~!! 여기 질 좋은 비단있어요~!"),
    ("선화", "어휴.. 덥다 더워.. 날씨가 더우니 장사도 잘안되고.."),
    ("아주머니1", "고생 많구나 선화야~ 어서 여기 시~~원한 수박 먹어라"),
    ("선화", "역시 우리 이모~! 이렇게 더운 여름엔 수박이 최고지~!"),
    ("선화", "응? 왜 이렇게 사람들이 웅성대지?"),
    ("아주머니2", "아이고!! 나는 망했네~ 망했어 우리 딸 혼수품으로 줄 금가락지를 잃어버리다니~!!"),
    ("선화", "아주머니 진정하세요. 제가 도와드릴게요. 혹시 기억나는게 있으세요?"),
    ("아주머니2", "사물놀이패 장단에 맞춰 정신없이 엉덩이를 흔들다 보니 금가락지가 도망간 모양이야"),
    ("아주머니2", "장담컨데 분명 그전까진 있었다고. 이 근처 어딘가에 떨어졌을것 같긴한데.. "),
    ("선화", "(이 아줌마.. 정상아니군..) 걱정마세요~! ^^ 제가 도와드릴게요. 이 근방은 제가 빠삭하게 잘아니까 얼른 찾아드릴께요~!"),
    ("선화", "(히히 찾으면 내꺼라구~!!    \\(^,^)/")
]
