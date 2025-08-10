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
                coordinate: .init(latitude: 35.954, longitude: 126.94),
                appearance: .init(imageName: "icon_seodong", size: CGSize(width: 52, height: 52), anchorBottom: true),
                action: .startQuest(questName: "고구마 배달")
            ),
            NPC(
                id: "sunhwa-001",
                name: "선화",
                type: .questGiver,
                spotName: "서동시장",
                coordinate: .init(latitude: 35.95324, longitude: 126.95736),
                appearance: .init(imageName: "icon_seonhwa", size: CGSize(width: 52, height: 52), anchorBottom: true),
                action: .startQuest(questName: "고구마 배달")
            ),
            NPC(
                id: "villager-101",
                name: "마을사람",
                type: .villager,
                spotName: "서동시장",
                coordinate: .init(latitude: 35.95319, longitude: 126.95745),
                appearance: .init(imageName: "npc_villager_m1", size: nil, anchorBottom: true),
                action: .dialogue(storyKey: "market_greeting")
            )
            // … 마을별로 추가
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
