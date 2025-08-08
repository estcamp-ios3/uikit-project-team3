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
    let arrScenario: [(speaker: String, line: String)]
    let bgm: String
}

class StoryModel {
    static let shared = StoryModel()
    
    // MARK: - 프롤로그
    static let prologueTexts: [String] = [
        "프롤로그: 버려진 왕의 마지막 염원",
        "고조선의 마지막 왕 준왕은 믿었던 위만에게 배신당해 홀로 익산 땅으로 도망친다.",
        "그는 죽음을 앞두고, 목걸이를 쪼개며 마지막 염원을 남긴다.",
        "\"이 목걸이가 합쳐지는 날, 이 땅에 피가 아닌 평화의 염원을 이을 왕이 통치하는 시대가 올것이다.\"",
        "목걸이의 한 조각은 한 고승에 의해 서동의 어머니에게 전해진다.",
        "고승은 울고 있는 어린 서동을 안고 있는 어머니에게 목걸이를 건네며, ",
        "훗날 이 아이가 평화의 시대를 열 운명을 지닌 아이가 될 것임을 암시한다.",
        "다른 한 조각은 다른 고승에 의해 신라의 왕과 왕비에게 전달된다.",
        "고승은 갓 태어난 선화공주를 안고 행복해하는 두 사람에게 목걸이를 건네며,",
        "이 아이가 평화의 염원을 잇는 중요한 존재가 될 것임을 예고한다.",
    ]
    
    // 5개의 프롤로그 이미지 파일 이름을 담는 배열
    // 이 파일들은 프로젝트의 Assets.xcassets에 추가되어야 합니다.
    static let prologueImageNames: [String] = [
        "prologue_image_1",
        "prologue_image_2",
        "prologue_image_3",
        "prologue_image_4",
        "prologue_image_5"
    ]
    
    // MARK: - 메인 스토리
    private var innerStories: [Story] = []
    
    private init() {
        innerStories = [
            Story(spotName: "서동시장", questName: "금가락지 소동", scenarioImage: "background", characterImage: "girl", arrScenario: dialogues_Market, bgm: "market"),
            Story(spotName: "보석박물관", questName: "고대 퍼즐", scenarioImage: "background", characterImage: "girl", arrScenario: dialogues_Museum, bgm: "museum"),
            Story(spotName: "미륵사지", questName: "신탁의 문장", scenarioImage: "background", characterImage: "girl", arrScenario: dialogues_Temple, bgm: "temple"),
            Story(spotName: "서동공원", questName: "서동요의 비밀", scenarioImage: "background", characterImage: "girl", arrScenario: dialogues_Park, bgm: "park"),
            Story(spotName: "왕궁리 유적 (미션 전)", questName: "예언의 완성", scenarioImage: "background", characterImage: "girl", arrScenario: dialogues_Palace_Intro, bgm: "palace_intro"),
            Story(spotName: "왕궁리 유적 (미션 후)", questName: "에필로그", scenarioImage: "background", characterImage: "girl", arrScenario: dialogues_Palace_Epilogue, bgm: "palace_epilogue")
        ]
    }
    
    public func getStories(spotName: String) -> Story {
        return innerStories.filter { $0.spotName == spotName }.first ?? innerStories[0]
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
    ("선화", "(히히 찾으면 내꺼라구~!!  \\(^,^)/")
]


// MARK: - 대사 데이터: 보석박물관 (Museum)
let dialogues_Museum: [(speaker: String, line: String)] = [
    ("선화", "여기는 언제 와도 반짝반짝 눈이 부셔~!"),
    ("서동", "공주님은 원래 보석보다 더 반짝이시지만요~ (씨익)"),
    ("선화", "후훗~ 말을 예쁘게도 하네~"),
    ("선화", "응? 저기 보석 문양 좀 봐봐! 어딘가 익숙한데...?"),
    ("서동", "이 문양… 우리 어머니가 물려주신 목걸이랑 닮았어."),
    ("선화", "그럼 어쩌면… 이 보석이 우리가 찾는 단서일지도 몰라!"),
    ("서동", "근데 너무 많잖아. 다 찾아보려면 밤새야 해…"),
    ("선화", "그렇다면 미션으로 해결하자! 자, 퍼즐을 풀어봐~!"),
    ("시스템", "[미션] 문양이 새겨진 보석을 찾아 고대 퍼즐을 맞추세요!")
]


// MARK: - 대사 데이터: 미륵사지 (Temple)
let dialogues_Temple: [(speaker: String, line: String)] = [
    ("서동", "여긴 언제 와도 마음이 차분해져…"),
    ("선화", "왕이 된다는 예언, 부담스럽지 않아?"),
    ("서동", "부담스럽다기보다… 내가 그런 사람일까 고민돼."),
    ("고승", "마음을 비우거라. 탑을 돌며 네 운명을 마주하라."),
    ("서동", "고승님… 저는 어떤 왕이 되어야 하나요?"),
    ("고승", "진정한 왕은 피가 아니라 평화를 잇는 자니라."),
    ("선화", "우리 함께라면… 두려울 거 없어요."),
    ("시스템", "[미션] 탑을 3번 돌고, 신탁의 문장을 찾으세요."),
    ("서동", "(속삭이며) 탑을 돌며 바람이 멈출 때를 기다리자.")
]


// MARK: - 대사 데이터: 서동공원 (Park)
let dialogues_Park: [(speaker: String, line: String)] = [
    ("선화", "여기 연못, 어릴 때 참 자주 왔었는데…"),
    ("서동", "나도 여기서 자주 노래했었지. 선화공주를 그리워하면서."),
    ("선화", "설마… 그 노래가 ‘서동요’가 된 거야?"),
    ("서동", "사람들이 퍼뜨리기 시작하더니… 지금은 내가 만든 것도 모르더라고."),
    ("선화", "근데 이상해… 목걸이 조각이 빛나고 있어!"),
    ("시스템", "[미션] 연못 주변 QR코드를 찾아 스캔하고, 서동요의 진짜 의미를 찾아보세요."),
    ("서동", "노래는 바람을 타고 흐르지… 정답은 물 위에 있을지도.")
]


// MARK: - 데사 데이터: 왕궁리 유적 도착 (미션 전)

let dialogues_Palace_Intro: [(speaker: String, line: String)] = [
    ("서동", "여기가 바로… 왕궁리 유적."),
    ("서동", "이 땅 위에서, 백제의 미래를 꿈꿨었지."),
    ("선화", "이 목걸이 조각들… 이제 하나로 만들 수 있겠죠?"),
    ("서동", "그래, 지금이야말로 그 예언의 의미를 확인할 때야."),
    ("선화", "마지막까지 같이 걸어와줘서 고마워요."),
    ("서동", "함께였기에, 여기까지 올 수 있었어. 이제… 진실을 마주하자.")
]


// MARK: - 에필로그: 예언의 완성 (미션 후)

let dialogues_Palace_Epilogue: [(speaker: String, line: String)] = [
    //    ("(조각이 맞춰지는 순간)", "眞王(진왕)이여, 백제를 다시 밝히라 – 예언의 문장이 허공에 떠오른다."),
    //    ("선화", "목걸이가… 빛나고 있어요…!"),
    //    ("서동", "진왕… 진정한 왕이라… 이게 바로 그 예언의 끝이구나."),
    //    ("선화", "당신은 피로 이어진 왕이 아닌, 믿음으로 선택된 왕이에요."),
    //    ("서동", "이제, 우리가 함께 백제의 새로운 시대를 열자."),
    //    (" (백성들)", "만세! 만세! 진왕 만세!"),
    //    ("시스템", "[에필로그] 예언이 완성되었습니다. 당신의 이야기는 전설이 되었습니다.")
    ("조각이 맞춰지는 순간", "眞王(진왕)이여, 백제를 다시 밝히라 – 예언의 문장이 허공에 떠오른다."),
    ("선화", "목걸이가… 빛나고 있어요…!"),
    ("서동", "진왕… 진정한 왕이라… 이게 바로 그 예언의 끝이구나."),
    ("내레이션", "두 조각의 목걸이가 합쳐지자, 고조선의 마지막 왕 준왕이 남긴 염원이 빛을 발하며 새로운 역사의 서막을 알렸다. 서동은 더 이상 마를 캐던 어린아이가 아니었다. 그는 백제의 새로운 왕, 무왕으로서 백성을 이끌 운명을 깨달았다. 신라의 공주 선화는 그저 정략적인 혼인의 대상이 아닌, 예언의 마지막 조각을 완성한 진정한 동반자였다."),
    ("선화", "당신은 피로 이어진 왕이 아닌, 믿음으로 선택된 왕이에요."),
    ("서동", "그래. 백제의 땅은 이미 수많은 피를 흘렸다. 이제 그 피의 역사를 끝내고, 백성들의 믿음과 평화로 새로운 시대를 열어야 한다."),
    ("선화", "당신의 마음이 백성의 마음과 함께하는 한, 백제는 영원히 빛날 거예요."),
    ("서동", "이제, 우리가 함께 백제의 새로운 시대를 열자."),
    ("내레이션", "서동의 목소리는 드넓은 왕궁을 넘어 백성들에게 닿았다. 백성들은 자신들의 삶을 보듬어 줄 진정한 왕의 탄생을 보며 환호했다."),
    (" (백성들)", "만세! 만세! 진왕 만세!"),
    ("내레이션", "무왕은 선화와 함께 손을 잡고 백성들을 향해 걸어 나갔다. 그들의 발걸음이 닿는 곳마다 평화의 기운이 싹트고, 새로운 희망이 피어났다. 준왕이 남긴 마지막 염원은 서동과 선화의 만남을 통해 평화와 화합의 백제를 완성하는 위대한 서사가 되었다."),
    ("시스템", "[에필로그] 예언이 완성되었습니다. 당신의 이야기는 전설이 되었습니다.")
]
