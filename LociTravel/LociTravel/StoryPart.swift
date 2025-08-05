//
//  StoryPart.swift
//  LociTravel
//
//  Created by suji chae on 8/5/25.
//

import Foundation

struct StoryPart {
    let speaker: String     // "로키" 또는 "나(사용자)"
    let text: String
    let image: String?      // 배경 이미지 파일 이름 (선택 사항)
    let options: [String]?  // 사용자의 선택지 (선택 사항)
}
