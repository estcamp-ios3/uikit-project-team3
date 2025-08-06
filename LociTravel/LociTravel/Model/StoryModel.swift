//
//  StoryModel.swift
//  LociTravel
//
//  Created by chohoseo on 8/6/25.
//

import Foundation
import UIKit

public struct Story: Codable {
    public var id: String
    public var title: String
    public var description: String
    public var imageUrl: String
    //public var location: LocationModel
}

// MARK: - StoryPart 데이터 모델
struct StoryPart {
    let speaker: String
    let text: String
    let image: UIImage
    let options: [String]
}

class StoryModel {
    static let shared = StoryModel()
    private var stories: [Story] = []
    private init() {
        stories = [
//            "start": StoryPart(speaker: "로키", text: "여기에 도착했군! 이 곳이 바로 미륵사지야. 엄청나게 오래된 곳이지!", image: nil, options: ["다음"]),
//            "next": StoryPart(speaker: "로키", text: "이곳의 역사는 정말 흥미로워. 더 들어볼래?", image: nil, options: ["웅장하군요.", "자세히 알려주세요."]),
//            "choice1": StoryPart(speaker: "나", text: "웅장하군요.", image: nil, options: ["로키의 다음 대사"]),
//            "choice2": StoryPart(speaker: "로키", text: "정말 그렇지? 여기는 백제 무왕이 지은 절이라고 해.", image: nil, options: ["다음"]),
        ]
    }
}
