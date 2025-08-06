//
//  Quest.swift
//  LociTravel
//
//  Created by suji chae on 8/6/25.
//

import Foundation
import CoreLocation

// MARK: - Quest 데이터 모델
struct Quest {
    let id: String
    let title: String
    let description: String
    let location: CLLocationCoordinate2D
    var isCompleted: Bool
    let storyKey: String
}

class QuestModel {
    static let shared = QuestModel()
    private var quests: [Quest] = []
    private init() {
        quests = [
            Quest(id: "quest_1", title: "미륵사지 석탑의 비밀", description: "백제 무왕과 선화공주의 전설이 깃든 곳...", location: CLLocationCoordinate2D(latitude: 35.9427, longitude: 126.9634), isCompleted: false, storyKey: "mireuksa_quest_intro"),
            Quest(id: "quest_2", title: "왕궁리 5층 석탑의 수수께끼", description: "천년의 시간을 품은 탑의 이야기를 들어보자.", location: CLLocationCoordinate2D(latitude: 35.9431, longitude: 127.0270), isCompleted: false, storyKey: "wanggungri_quest_intro"),
            Quest(id: "quest_3", title: "제석사지", description: "미륵사지 근처에 위치한 제석사지터.", location: CLLocationCoordinate2D(latitude: 35.9427, longitude: 126.9734), isCompleted: true, storyKey: "jesaksaji_quest_intro")
        ]
    }
}
