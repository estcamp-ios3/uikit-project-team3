//
//  StoryModel.swift
//  LociTravel
//
//  Created by chohoseo on 8/6/25.
//

import Foundation
import UIKit

public struct Story {
    let spotName: String
    let questName: String
    let scenarioImage: String
    let characterImage: String
    let arrScenario: [(speaker: String, line:  String)]
    let bgm: String
}

class StoryModel {
    static let shared = StoryModel()
    private var innerStories: [Story] = []
    
    private init() {
        innerStories = [
            Story(spotName: "서동시장", questName: "금가락지 소동", scenarioImage: "background", characterImage: "girl", arrScenario: dialogues_Market, bgm: "market"),
        ]
    }
    
    public func getStories(spotName: String) -> Story {
        return innerStories.filter { $0.spotName ==  spotName }.first ?? innerStories[0]
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
