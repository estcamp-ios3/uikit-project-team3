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
                     imgCourse: "iksanallcourse",
                     arrCourse: []               // 코스 핀은 필요 없으면 빈 배열
                 ),
             
              Theme(
                  local: "익산",
                  theme: "잊혀진 유적",
                  color: .systemBlue,
                  imgCourse: "onecourse",
                  arrCourse: [
                      Course(courseName: "서동시장", coordinate: CLLocationCoordinate2D(latitude: 35.946904, longitude: 126.950516)),
                      Course(courseName: "보석박물관", coordinate: CLLocationCoordinate2D(latitude: 35.990806, longitude: 127.102563)),
                      Course(courseName: "교도소 세트장", coordinate: CLLocationCoordinate2D(latitude: 36.069755, longitude: 126.931221)),
                      Course(courseName: "미륵사지", coordinate: CLLocationCoordinate2D(latitude: 36.010969, longitude: 127.030704)),
                      Course(courseName: "서동공원", coordinate: CLLocationCoordinate2D(latitude: 36.001114, longitude: 127.057518
  )),
                      Course(courseName: "왕궁리 유적", coordinate: CLLocationCoordinate2D(latitude: 35.972960, longitude: 127.054845)),
                  ]
              ),
              
              Theme(
                  local: "익산",
                  theme: "사라진 유적",
                  color: .systemYellow,
                  imgCourse: "iksan2course",
                  arrCourse: [
                      Course(courseName: "나바위 성당", coordinate: CLLocationCoordinate2D(latitude: 36.138465, longitude: 126.999489)),
                      Course(courseName: "익산아트센터", coordinate: CLLocationCoordinate2D(latitude: 35.938774, longitude: 126.948141)),
                      Course(courseName: "웅포 곰개나루길", coordinate: CLLocationCoordinate2D(latitude: 36.067527, longitude: 126.878010)),
                      
                  ]
              ),
              
              Theme(
                  local: "익산",
                  theme: "익산3",
                  color: .systemMint,
                  imgCourse: "iksan3course",
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
                  theme: "수원1코스",
                  color: .systemBlue,
                  imgCourse: "suwon1course",
                  arrCourse: [
                      Course(courseName: "해우재", coordinate: CLLocationCoordinate2D(latitude: 37.319273, longitude: 126.977928)),
                      Course(courseName: "화서문", coordinate: CLLocationCoordinate2D(latitude: 37.285838, longitude: 127.009739)),
                      Course(courseName: "장안문 ", coordinate: CLLocationCoordinate2D(latitude: 37.289009, longitude: 127.014098)),
                      Course(courseName: "화성행궁", coordinate: CLLocationCoordinate2D(latitude: 37.282197, longitude: 127.013759)),
                      Course(courseName: "화홍문", coordinate: CLLocationCoordinate2D(latitude: 37.287597, longitude: 127.017992)),
                      Course(courseName: "연무대", coordinate: CLLocationCoordinate2D(latitude: 37.288550, longitude: 127.023260)),
                      Course(courseName: "수원화성박물관", coordinate: CLLocationCoordinate2D(latitude: 37.282828, longitude: 127.018977)),
                  ]
              ),
              
              Theme(
                  local: "수원",
                  theme: "수원2코스",
                  color: .systemYellow,
                  imgCourse: "suwon2course",
                  arrCourse: [
                      Course(courseName: "해우재", coordinate: CLLocationCoordinate2D(latitude: 37.319273, longitude: 126.977928)),
                      Course(courseName: "화성행궁", coordinate: CLLocationCoordinate2D(latitude: 37.282197, longitude: 127.013759)),
                      Course(courseName: "연무대", coordinate: CLLocationCoordinate2D(latitude: 37.288550, longitude: 127.023260)),
                      Course(courseName: "지동시장", coordinate: CLLocationCoordinate2D(latitude: 37.277780, longitude: 127.019491)),
                      Course(courseName: "화홍문", coordinate: CLLocationCoordinate2D(latitude: 37.287597, longitude: 127.017992)),
                      Course(courseName: "수원화성박물관", coordinate: CLLocationCoordinate2D(latitude: 37.282828, longitude: 127.018977)),
                      Course(courseName: "광교호수공원", coordinate: CLLocationCoordinate2D(latitude: 37.283236, longitude: 127.066458)),
                      
                  ]
              ),
              
              Theme(
                  local: "수원",
                  theme: "수원3코스",
                  color: .systemMint,
                  imgCourse: "suwon3course",
                  arrCourse: [
                      Course(courseName: "화서문", coordinate: CLLocationCoordinate2D(latitude: 37.285838, longitude: 127.009739)),
                      Course(courseName: "장안문 ", coordinate: CLLocationCoordinate2D(latitude: 37.289009, longitude: 127.014098)),
                      Course(courseName: "화홍문", coordinate: CLLocationCoordinate2D(latitude: 37.287597, longitude: 127.017992)),
                      Course(courseName: "화성행궁", coordinate: CLLocationCoordinate2D(latitude: 37.282197, longitude: 127.013759)),
                      Course(courseName: "연무대", coordinate: CLLocationCoordinate2D(latitude: 37.288550, longitude: 127.023260)),
                      Course(courseName: "지동시장", coordinate: CLLocationCoordinate2D(latitude: 37.277780, longitude: 127.019491)),
                      Course(courseName: "팔달문", coordinate: CLLocationCoordinate2D(latitude: 37.277681, longitude: 127.016885)),
                      Course(courseName: "융릉과건릉", coordinate: CLLocationCoordinate2D(latitude: 37.212051, longitude: 126.991259)),
                      Course(courseName: "용주사", coordinate: CLLocationCoordinate2D(latitude: 37.212189, longitude: 127.005031)),
                    
                  ]
              ),
//              Theme(
//                  local: "익산",
//                  theme: "예예 유적",
//                  color: .systemPink,
//                  imgCourse: "onecourse",
//                  arrCourse: [
//                      Course(courseName: "입점리 고분", coordinate: CLLocationCoordinate2D(latitude: 36.046018, longitude: 126.870314)),
//                      Course(courseName: "교도소 세트장", coordinate: CLLocationCoordinate2D(latitude: 36.069729, longitude: 126.931253)),
//                      
//                      
//                  ]
//              )
              
              
              
              
              
              
          ]
      }
  }
