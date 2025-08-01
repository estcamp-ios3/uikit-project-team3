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
                color: .systemBlue,
                imgCourse: "courseone",
                arrCourse: [
                    Course(courseName: "미륵사지", coordinate: CLLocationCoordinate2D(latitude: 36.010937, longitude: 127.030684)),
                    Course(courseName: "아가페정원", coordinate: CLLocationCoordinate2D(latitude: 36.019836, longitude: 126.957924)),
                    Course(courseName: "왕궁리 유적", coordinate: CLLocationCoordinate2D(latitude: 35.972969, longitude: 127.054877)),
                ]
            ),
            
            Theme(
                local: "익산",
                theme: "사라진 유적",
                color: .systemYellow,
                imgCourse: "courseone",
                arrCourse: [
                    Course(courseName: "나바위 성당", coordinate: CLLocationCoordinate2D(latitude: 36.138465, longitude: 126.999489)),
                    Course(courseName: "익산아트센터", coordinate: CLLocationCoordinate2D(latitude: 35.938774, longitude: 126.948141)),
                    Course(courseName: "웅포 곰개나루길", coordinate: CLLocationCoordinate2D(latitude: 36.067527, longitude: 126.878010)),
                    
                ]
            ),
            
            Theme(
                local: "익산",
                theme: "우우 유적",
                color: .systemYellow,
                imgCourse: "courseone",
                arrCourse: [
                    Course(courseName: "서동공원", coordinate: CLLocationCoordinate2D(latitude: 36.0015063, longitude: 126.9022638)),
                    Course(courseName: "익산근대역사관", coordinate: CLLocationCoordinate2D(latitude: 35.938258, longitude: 126.947985)),
                    Course(courseName: "보석박물관", coordinate: CLLocationCoordinate2D(latitude: 35.990711, longitude: 127.103185)),
                    
                    
                ]
            ),
            
            Theme(
                local: "익산",
                theme: "우우 유적",
                color: .systemYellow,
                imgCourse: "courseone",
                arrCourse: [
                    Course(courseName: "입점리 고분", coordinate: CLLocationCoordinate2D(latitude: 36.046018, longitude: 126.870314)),
                    Course(courseName: "교도소 세트장", coordinate: CLLocationCoordinate2D(latitude: 36.069729, longitude: 126.931253)),
                    
                    
                ]
            )
            
            
            
            
            
            
        ]
    }
}
