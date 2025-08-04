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
    let local: String //지역: 익산, 수원, 내 위치 근처
    let theme: String // <가제-숨겨진 왕의 흔적>, ,
    let color: UIColor
    let imgCourse: String // <가제-숨겨진 왕의 흔적>의 코스 경로이미지
    let arrCourse: [Course]
}

struct Course {
    let courseName: String // <가제-숨겨진 왕의 흔적> 코스의 유적지나 방문할 곳
    let coordinate: CLLocationCoordinate2D // 해당 유적지의 위도 경도
}

// 싱글톤 공용으로 로컬데이터 관리하기
class LocalModel {
    static let shared = LocalModel()
    
    // 우리 식구들만 사용하는 데이터
    private var innerthemeData: [Theme] = []
    
    // 0804 추가: 지역별 전체 노선도 이미지 이름 매핑 ─────
        /// 지역(key)에 대응하는 전체 노선도(이미지명) 값
        private let fullRouteImagesByLocal: [String: String] = [
            "익산":  "iksanAllroute", //에셋에 저장한 이름
            "수원":  "suwonAllroute",
           // "경주":  "gyeongju_fullRoute",
            // 필요하면 다른 지역도 추가...
        ]
        /// 전체 노선도 이미지 이름을 가져오는 헬퍼 메서드
        func fullRouteImageName(for local: String) -> String? {
            return fullRouteImagesByLocal[local]
        }
    
    
    // 외부에서 접근 가능한 읽기 전용 데이터
    var themeData: [Theme] {
        return innerthemeData
    }
    
    private init() {
        innerthemeData = [
            //전체 노선도 추가
            Theme(
                    local: "익산",
                    theme: "전체 노선도",
                    color: .systemBlue,
                    imgCourse: "iksanAllroute",
                    arrCourse: []               // 코스 핀은 필요 없으면 빈 배열
                ),
            
            
            Theme(
                local: "익산",
                theme: "잊혀진 유적",
                color: .systemYellow,
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
                imgCourse: "iksanBroute",
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
                imgCourse: "iksanCroute",
                arrCourse: [
                    Course(courseName: "서동공원", coordinate: CLLocationCoordinate2D(latitude: 36.0015063, longitude: 126.9022638)),
                    Course(courseName: "익산근대역사관", coordinate: CLLocationCoordinate2D(latitude: 35.938258, longitude: 126.947985)),
                    Course(courseName: "보석박물관", coordinate: CLLocationCoordinate2D(latitude: 35.990711, longitude: 127.103185)),
                    
                    
                ]
            ),
            
            Theme(
                    local: "수원",
                    theme: "전체 노선도",
                    color: .systemBlue,
                    imgCourse: "suwonallcourse",
                    arrCourse: []               // 코스 핀은 필요 없으면 빈 배열
                ),
            
            Theme(
                local: "수원",
                theme: "수원화성1",
                color: .systemYellow,
                imgCourse: "suwon1course",
                arrCourse: [
                    Course(courseName: "수원화성", coordinate: CLLocationCoordinate2D(latitude: 37.287342, longitude: 127.011884)),
                    Course(courseName: "수원박물관", coordinate: CLLocationCoordinate2D(latitude: 37.298497, longitude: 127.035483)),
                    Course(courseName: "광교호수공원 ", coordinate: CLLocationCoordinate2D(latitude: 37.283883, longitude: 127.066501)),
                ]
            ),
            
            Theme(
                local: "수원",
                theme: "수원화성2",
                color: .systemYellow,
                imgCourse: "suwon2course",
                arrCourse: [
                    Course(courseName: "미륵사지", coordinate: CLLocationCoordinate2D(latitude: 36.010937, longitude: 127.030684)),
                    Course(courseName: "아가페정원", coordinate: CLLocationCoordinate2D(latitude: 36.019836, longitude: 126.957924)),
                    Course(courseName: "왕궁리 유적", coordinate: CLLocationCoordinate2D(latitude: 35.972969, longitude: 127.054877)),
                ]
            ),
            
            Theme(
                local: "수원",
                theme: "수원화성3",
                color: .systemYellow,
                imgCourse: "suwon3course",
                arrCourse: [
                    Course(courseName: "미륵사지", coordinate: CLLocationCoordinate2D(latitude: 36.010937, longitude: 127.030684)),
                    Course(courseName: "아가페정원", coordinate: CLLocationCoordinate2D(latitude: 36.019836, longitude: 126.957924)),
                    Course(courseName: "왕궁리 유적", coordinate: CLLocationCoordinate2D(latitude: 35.972969, longitude: 127.054877)),
                ]
            )
            
            
            
            
            
            
        ]
    }
}
