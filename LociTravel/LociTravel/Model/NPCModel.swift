//
//  NPCModel.swift
//  LociTravel
//
//  Created by chohoseo on 8/10/25.
//

import CoreLocation
import MapKit

public enum NPCType: String, Codable {
    case villager        // 일반 대화
    case questGiver      // 퀘스트 시작/수락
    case merchant        // 상점
    case assassin        // 이동형(NPC지만 특수 로직)
}

public enum NPCAction: Codable {
    case dialogue(storyKey: String)         // Story로 대화 열기
    case openShop(shopId: String)
    case startQuest(questName: String)
    case none
}

public struct NPCAppearance: Codable {
    let imageName: String
    let size: CGSize?            // nil이면 타입별 기본값 사용
    let anchorBottom: Bool       // true면 핀 하단이 좌표를 가리키도록
}

public struct NPC {
    public let id: String        // "seodong-001"
    public let name: String
    public let type: NPCType
    public let spotName: String  // 마을/스팟 연결
    public let coordinate: CLLocationCoordinate2D
    public let appearance: NPCAppearance
    public let action: NPCAction
}

final class WorldModel {
    static let shared = WorldModel()
    private(set) var npcs: [NPC] = []

    private init() {
        // JSON 으로 변경 예정
        npcs = [
            //서동시장
            NPC(
                id: "seodong-001",
                name: "서동",
                type: .questGiver,
                spotName: "서동시장",
                coordinate: .init(latitude: 35.9533, longitude: 126.9574),
                appearance: .init(imageName: "icon_seodong", size: CGSize(width: 52, height: 52), anchorBottom: true),
                action: .dialogue(storyKey: "market_greeting")
            ),
            NPC(
                id: "seonhwa-001",
                name: "선화",
                type: .questGiver,
                spotName: "서동시장",
                coordinate: .init(latitude: 35.9542, longitude: 126.95736),
                appearance: .init(imageName: "icon_seonhwa", size: CGSize(width: 52, height: 52), anchorBottom: true),
                action: .dialogue(storyKey: "market_greeting")
            ),
            NPC(
                id: "villager-101",
                name: "아주머니1",
                type: .villager,
                spotName: "서동시장",
                coordinate: .init(latitude: 35.95369, longitude: 126.95745),
                appearance: .init(imageName: "icon_woman1", size: nil, anchorBottom: true),
                action: .dialogue(storyKey: "market_greeting")
            ),
            NPC(
                id: "villager-102",
                name: "아주머니2",
                type: .villager,
                spotName: "서동시장",
                coordinate: .init(latitude: 35.9553, longitude: 126.95767),
                appearance: .init(imageName: "icon_woman2", size: nil, anchorBottom: true),
                action: .dialogue(storyKey: "market_greeting")
            ),
            
            //보석 박물관
            NPC(
                id: "jinsapyung-001",
                name: "진사평",
                type: .questGiver,
                spotName: "보석 박물관",
                coordinate: .init(latitude: 35.989156, longitude: 127.105036),
                appearance: .init(imageName: "icon_jinsapyung", size: CGSize(width: 52, height: 52), anchorBottom: true),
                action: .dialogue(storyKey: "market_greeting")
            ),
            
            //미륵사지
            NPC(
                id: "monk-001",
                name: "승려",
                type: .questGiver,
                spotName: "미륵사지",
                coordinate: .init(latitude:
                                    36.012028, longitude: 127.030956),
                appearance: .init(imageName: "icon_monk", size: CGSize(width: 52, height: 52), anchorBottom: true),
                action: .dialogue(storyKey: "market_greeting")
            ),
            
            //서동공원
            NPC(
                id: "seonhwa-002",
                name: "선화",
                type: .questGiver,
                spotName: "서동공원",
                coordinate: .init(latitude: 36.000866, longitude: 127.059637),
                appearance: .init(imageName: "icon_seonhwa", size: CGSize(width: 52, height: 52), anchorBottom: true),
                action: .dialogue(storyKey: "market_greeting")
            ),
            NPC(
                id: "seodong-002",
                name: "서동",
                type: .questGiver,
                spotName: "서동공원",
                coordinate: .init(latitude: 36.001417, longitude: 127.056713),
                appearance: .init(imageName: "icon_seodong", size: CGSize(width: 52, height: 52), anchorBottom: true),
                action: .dialogue(storyKey: "market_greeting")
            ),
            NPC(
                id: "jinsapyung-002",
                name: "진사평",
                type: .questGiver,
                spotName: "서동공원",
                coordinate: .init(latitude: 36.000988, longitude: 127.057641),
                appearance: .init(imageName: "icon_jinsapyung", size: CGSize(width: 52, height: 52), anchorBottom: true),
                action: .dialogue(storyKey: "market_greeting")
            ),
            
            //왕궁리 유적
            NPC(
                id: "seonhwa-003",
                name: "선화",
                type: .questGiver,
                spotName: "왕궁리 유적",
                coordinate: .init(latitude: 35.972734, longitude: 127.054834),
                appearance: .init(imageName: "icon_seonhwa", size: CGSize(width: 52, height: 52), anchorBottom: true),
                action: .dialogue(storyKey: "market_greeting")
            ),
            NPC(
                id: "seodong-003",
                name: "서동",
                type: .questGiver,
                spotName: "왕궁리 유적",
                coordinate: .init(latitude: 35.973008, longitude: 127.054612),
                appearance: .init(imageName: "icon_seodong", size: CGSize(width: 52, height: 52), anchorBottom: true),
                action: .dialogue(storyKey: "market_greeting")
            ),
            NPC(
                id: "jinsapyung-003",
                name: "진사평",
                type: .questGiver,
                spotName: "왕궁리 유적",
                coordinate: .init(latitude: 35.973045, longitude: 127.054834),
                appearance: .init(imageName: "icon_jinsapyung", size: CGSize(width: 52, height: 52), anchorBottom: true),
                action: .dialogue(storyKey: "market_greeting")
            ),
            NPC(
                id: "monk-003",
                name: "승려",
                type: .questGiver,
                spotName: "왕궁리 유적",
                coordinate: .init(latitude: 35.973042, longitude: 127.054671),
                appearance: .init(imageName: "icon_monk", size: CGSize(width: 52, height: 52), anchorBottom: true),
                action: .dialogue(storyKey: "market_greeting")
            ),
        ]
    }

    func npcs(in spotName: String) -> [NPC] {
        npcs.filter { $0.spotName == spotName }
    }
}

final class NPCAnnotation: NSObject, MKAnnotation {
    let npc: NPC
    init(npc: NPC) { self.npc = npc }
    var coordinate: CLLocationCoordinate2D { npc.coordinate }
    var title: String? { npc.name }
    var subtitle: String? { npc.type.rawValue }
}
