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
