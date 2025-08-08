//
//  GameProgress.swift
//  LociTravel
//
//  Created by dkkim on 8/8/25.
//

struct GameProgress: Codable {
    enum Stage: String, Codable { case map, scenario, quest, finished }
    var region: String              // 예: "익산"
    var themeIndex: Int             // 0,1,2...
    var visitedSpotIDs: [String]    // 다녀간 스팟 ID
    var lastSpotID: String?         // 마지막으로 머문 스팟
    var stage: Stage                // map | scenario | quest | finished
}
