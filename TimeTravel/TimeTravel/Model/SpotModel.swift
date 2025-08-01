//
//  SpotModel.swift
//  TimeTravel
//
//  Created by chohoseo on 8/1/25.
//

import Foundation
import CoreLocation //위도 경도 넣을때 필요

struct Spot {
    let spotName: String
    let spotImage: [String]
    let spotDetail: String
    let coordinate: CLLocationCoordinate2D
    let info: Infomation
}

struct Infomation {
    let address: String
    let phone: String
    let website: String
    let cost: String
    let openTime: String
}

//공용으로 쓰게 만들기
class SpotModel {
    static let shared = SpotModel()
    
    private var innerArrSpot: [Spot] = []
    
    public var arrSpot: [Spot] {
        return innerArrSpot
    }
    
    private init() {
        Spot(spotName: "미륵사지",
             spotImage: [
                "미륵사지1",
                "미륵사지2",
                "미륵사지3",
             ],
             spotDetail: "미륵사지 설명",
             coordinate: CLLocationCoordinate2D(latitude: 36.010917, longitude: 127.030800),
             info: Infomation(address: "경기도 용인시 기흥구 미륵사로 123", phone: "031-751-1234", website: "www.naver.com", cost: "Free", openTime: "10:00-20:00")
        )
        
        Spot(spotName: "왕궁리 유적", spotImage: [
            "왕궁리 유적1",
            "왕궁리 유적2",
            "왕궁리 유적3",
        ], spotDetail: "왕궁리유적 설명",
             coordinate: CLLocationCoordinate2D(latitude: 35.973905, longitude: 127.054394),
             info: Infomation(address: "경기도 용인시 기흥구 미륵사로 123", phone: "031-751-1234", website: "www.naver.com", cost: "Free", openTime: "10:00-20:00")
        )
    }
}
