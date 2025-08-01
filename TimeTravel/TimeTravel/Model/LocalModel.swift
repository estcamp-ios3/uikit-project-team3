//
//  LocalModel.swift
//  TimeTravel
//
//  Created by chohoseo on 8/1/25.
//

import Foundation
import CoreLocation
import UIKit // CGFloat, UIColor 사용 시 필요

struct Theme {
    let local: String
    let theme: String
    let color: UIColor
    let imgCourse: String
    let arrCourse: [Course]
}

struct Course {
    let courseName: String
    let coordinate: CLLocationCoordinate2D
}

// 싱글톤 공용으로 로컬데이터 관리하기
class LocalModel {
    static let shared = LocalModel()
    
    // 우리 식구들만 사용하는 데이터
    private var innerthemeData: [Theme] = []
    
    // 외부에서 접근 가능한 읽기 전용 데이터
    var themeData: [Theme] {
        return innerthemeData
    }
    
    private init() {
        innerthemeData = [
            Theme(
                local: "익산",
                theme: "잊혀진 유적",
                color: .systemYellow,
                imgCourse: "iksan_course1",
                arrCourse: [
                    Course(courseName: "미륵사지4층석탑",
                           coordinate: CLLocationCoordinate2D(latitude: 36.010917, longitude: 127.030800)),
                    Course(courseName: "익산역",
                           coordinate: CLLocationCoordinate2D(latitude: 35.940658, longitude: 126.946303)),
                    Course(courseName: "왕궁리 유적",
                           coordinate: CLLocationCoordinate2D(latitude: 35.973905, longitude: 127.054394))
                ]
            )
        ]
    }
}
