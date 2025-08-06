//
//  SpotModel.swift
//  LociTravel
//
//  Created by chohoseo on 8/6/25.
//

struct Spot{
    let name: String
    let image: String
    let description: String
}

class SpotModel {
    static let shared = SpotModel()
    
    private init() {}
    
    var spots: [Spot] = [
        Spot(name: "서울숲", image: "seoul_forest", description: "서울숲은 서울의 10대 명소를 꼽는 곳입니다."),
        ]
}
