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
    
    //퀘스트뷰에서 가져올것
    public func getStory(for regionName: String, preferPostMission: Bool = false) -> Story {
        // 1) 정확 일치 우선
        if let exact = innerStories.first(where: { $0.spotName == regionName }) {
            return exact
        }
        
        // 2) 정규화 키로 후보 찾기
        let key = Self.baseKey(regionName)
        let candidates = innerStories.filter { Self.baseKey($0.spotName) == key }
        
        if !candidates.isEmpty {
            if preferPostMission {
                return candidates.first(where: { $0.spotName.contains("미션 후") }) ?? candidates[0]
            } else {
                return candidates.first(where: { $0.spotName.contains("미션 전") }) ?? candidates[0]
            }
        }
        
        // 3) 폴백
        return innerStories.first ?? Story(spotName: "", questName: "", scenarioImage: "", characterImage: "", arrScenario: [], bgm: "")
    }
    
    // ✅ [추가] 공백/괄호/“미션 전·후” 표기 제거해서 비교용 키 생성
    private static func baseKey(_ s: String) -> String {
        var t = s.replacingOccurrences(of: " ", with: "")
        // 다양한 표기 제거
        t = t.replacingOccurrences(of: "(미션전)", with: "")
            .replacingOccurrences(of: "(미션후)", with: "")
            .replacingOccurrences(of: "(미션 전)", with: "")
            .replacingOccurrences(of: "(미션 후)", with: "")
            .replacingOccurrences(of: "미션전", with: "")
            .replacingOccurrences(of: "미션후", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
        return t
    }
    
    
}

// MARK: - 대사 데이터
let dialogues_Market: [(speaker: String, line: String)] = [
    ("내레이션", "서동 시장은 언제나 활기가 넘쳤지만, 서동에게는 하루하루가 고단한 생존의 싸움이었다."),
    ("내레이션", "그의 손에 쥐어진 것은 어머니의 유품인 낡은 목걸이 조각뿐이었다. 오늘도 서동은 직접 캔 약초를 팔아 끼니를 해결하려 애쓰고 있었다."),
    ("서동", "에휴, 오늘은 얼마나 팔 수 있을까…."),
    ("내레이션", "그때, 왁자지껄한 시장 골목에서 눈부신 한 줄기 빛이 다가왔다.하얀 비단옷을 입은 아름다운 처녀가 눈을 반짝이며 주위를 둘러보고 있었다."),
    ("선화", "와, 백제 시장은 신라랑은 또 다르네!"),
    ("내레이션", "선화는 눈앞에 펼쳐진 낯선 풍경에 홀려 주변을 살피다, 그만 정신없이 걷는 서동과 부딪히고 말았다."),
    ("서동", "아야…! 죄, 죄송합니다!"),
    ("선화", "어머, 괜찮아요? 제가 앞을 제대로 못 봤네요."),
    ("내레이션", "서동은 고개를 들었다. 눈앞에는 난생처음 보는 미인이 서 있었다. 그의 얼굴은 순식간에 붉어졌다."),
    ("서동", "아니요, 제가 괜찮습니다…."),
    ("선화", "후후, 참 재미있는 분이네요. 혹시 이곳에 대해 잘 아세요? 저는 멀리서 왔어요. 부모님께는 여행이라고 하고 왔지만… 사실은…."),
    ("내레이션", "선화의 눈이 이내 진지하게 변했다."),
    ("선화", "(속마음)부모님께서 말씀하신 목걸이의 비밀을 풀기 위해 백제 땅에 왔어. 어머니의 목걸이 조각이 이 땅에 전해졌다고 했으니, 분명 단서가 있을 거야. 그리고 나는… 이 예언이 말하는 운명의 조각을 찾아야 해."),
    ("선화", "혹시 시간이 있으시다면, 저와 함께 백제를 구경시켜 주실 수 있나요? 제가 가진 모든 약초를 사드릴게요!"),
    ("서동", "네, 네! 물론입니다! 백제를 모두 보여드릴게요!"),
    ("내레이션", "서동의 가슴은 떨렸다.아름다운 아가씨와의 만남에 설렜고, 그녀의 목에서 반짝이는 목걸이 조각이 왠지 모르게 자신의 것과 닮았다는 기묘한 느낌 때문이었다.이렇게, 두 사람의 운명적인 여행이 시작되었다."),
]


// MARK: - 대사 데이터: 보석박물관 (Museum)
let dialogues_Museum: [(speaker: String, line: String)] = [
    ("내레이션", "서동과 선화가 함께 도착한 곳은 보석박물관이었다. 그곳에는 찬란한 보석들이 가득했고, 그중에서도 고대 백제의 유물들이 특별한 빛을 발하고 있었다."),
    ("선화", "와, 정말 아름답네요! 신라의 보물들과는 또 다른 느낌이에요."),
    ("내레이션", "그때, 두 사람에게 낯선 그림자가 드리워졌다. 검은 복면을 쓴 한 사내가 재빠르게 서동에게 다가와 그의 목걸이를 낚아채 달아났다."),
    ("서동", "아앗! 내 목걸이!"),
    ("선화", "잠깐만요! 저 목걸이는…!"),
    ("내레이션", "놀란 선화는 자신의 목에 걸린 목걸이를 움켜쥐었다. 도둑이 훔쳐 달아난 서동의 목걸이 조각과 자신의 목걸이 조각이 마치 오래전부터 기다려온 짝처럼 보였기 때문이다."),
    ("선화", "(속마음)저건… 틀림없어. 내 목걸이와 같은 문양이 새겨져 있어! 고승이 말씀하신 예언의 조각이… 바로 저 목걸이었어. 서동의 것이었구나…."),
    ("서동", "어머니의 유품인데… 이걸 잃을 순 없습니다! 제가 꼭 되찾아올게요!"),
    ("선화", "혼자 가지 마세요! 서동님, 저도 함께 갈게요! 제게도 중요한… 중요한 의미가 있는 물건이니까요!"),
    ("내레이션", "서동은 자신의 목걸이를, 선화는 예언의 조각을 되찾기 위해 함께 도둑을 뒤쫓기 시작했다. 서로 다른 이유였지만, 두 사람의 발걸음은 하나의 운명을 향해 나아가고 있었다."),
    ("서동", "도대체 왜 제 목걸이를 훔쳐간 걸까요? 그냥 낡은 쇠붙이에 불과한데…."),
    ("선화", "서동님, 제 목걸이도 비슷한 모양을 하고 있어요. 어쩌면 그 도둑은 단순히 쇠붙이가 아닌, 이 목걸이 조각이 가진 비밀을 노리고 있는지도 몰라요."),
    ("내레이션", "서동은 선화의 말에 자신의 목걸이가 단순한 유품이 아닐지도 모른다는 생각을 품게 되었다. 그들의 눈앞에 펼쳐질 새로운 진실의 서막이 서서히 드러나고 있었다. 그리고 도둑은 미륵사지 방향으로 달아나고 있었다.")
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
    ("조각이 맞춰지는 순간", "무왕이여, 백제를 다시 밝히라 – 예언의 문장이 허공에 떠오른다."),
    ("선화", "목걸이가… 빛나고 있어요…!"),
    ("서동", "무왕이라… 이게 바로 그 예언의 끝이구나."),
    ("내레이션", "두 조각의 목걸이가 합쳐지자, 고조선의 마지막 왕 준위왕이 남긴 염원이 빛을 발하며 새로운 역사의 서막을 알렸다. 서동은 더 이상 마를 캐던 어린아이가 아니었다. 그는 백제의 새로운 왕, 무왕으로서 백성을 이끌 운명을 깨달았다. 신라의 공주 선화는 그저 정략적인 혼인의 대상이 아닌, 예언의 마지막 조각을 완성한 진정한 동반자였다."),
    ("선화", "당신은 피로 이어진 왕이 아닌, 믿음으로 선택된 왕이에요."),
    ("서동", "그렇소. 백제의 땅은 이미 수많은 피를 흘렸다오. 이제 그 피의 역사를 끝내고, 백성들의 믿음과 평화로 새로운 시대를 열어야 하오."),
    ("선화", "당신의 마음이 백성의 마음과 함께하는 한, 백제는 영원히 빛날 거예요."),
    ("서동", "이제, 우리가 함께 백제의 새로운 시대를 엽시다."),
    ("내레이션", "서동의 목소리는 드넓은 왕궁을 넘어 백성들에게 닿았다. 백성들은 자신들의 삶을 보듬어 줄 진정한 왕의 탄생을 보며 환호했다."),
    (" (백성들)", "만세! 만세! 무왕 만세!"),
    ("내레이션", "무왕은 선화와 함께 손을 잡고 백성들을 향해 걸어 나갔다. 그들의 발걸음이 닿는 곳마다 평화의 기운이 싹트고, 새로운 희망이 피어났다. 준왕이 남긴 마지막 염원은 서동과 선화의 만남을 통해 평화와 화합의 백제를 완성하는 위대한 서사가 되었다."),
    ("내레이션", "예언이 완성되었습니다. 당신의 이야기는 전설이 되었습니다.")
]
