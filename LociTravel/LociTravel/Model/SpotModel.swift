//
//  SpotModel.swift
//  LociTravel
//
//  Created by chohoseo on 8/6/25.
//

import Foundation
import CoreLocation // 위도 경도 넣을때 필요

// MARK: - Spot (유적지 단일 항목 모델)
// 각 유적지의 핵심 정보를 담는 구조체입니다.
// 부가 정보 (SpotInfo)는 더 이상 포함하지 않습니다.
struct Spot: Identifiable {
    let id = UUID() // 각 Spot을 고유하게 식별하기 위한 ID
    let spotName: String // 유적지 이름 (예: 미륵사지 석탑)
    let spotImage: [String] // 유적지 사진 파일 이름 목록 (여러 장의 이미지를 위해 배열로 변경)
    let spotDetail: String // 유적지 설명 텍스트 (긴 텍스트를 담을 수 있도록 String 타입 유지)
    let spotSummary: String // 간략한 설명 (RecordBookVeiw 연결)
    let coordinate: CLLocationCoordinate2D // 유적지의 지도 좌표
}

// MARK: - SpotModel (데이터 관리 클래스)
// 앱 내 모든 유적지 데이터를 관리하는 싱글톤 클래스입니다.
// 싱글톤 패턴을 사용하여 앱 전체에서 이 클래스의 인스턴스를 하나만 사용하도록 합니다.
class SpotModel {
    static let shared = SpotModel() // 앱 전체에서 접근할 수 있는 공유 인스턴스

    // 외부에서 직접 SpotModel 인스턴스를 생성하는 것을 방지합니다.
    private init() {}

    // 유적지 목록 배열입니다. 여기에 실제 유적지 데이터를 추가합니다.
    // `spotImage` 배열에는 Assets.xcassets에 추가된 이미지 파일 이름들을 넣어주세요.
    let arrSpot: [Spot] = [
        Spot(
            spotName: "미륵사지 석탑",
            spotImage: ["miruksa1", "miruksa2", "miruksa3", "miruksa4", "miruksa5"], // 여러 이미지 파일명
            spotDetail: """
            익산 미륵사지는 백제 무왕이 선화공주와 함께 용화산 사자사를 향하던 중 연못에서 미륵삼존이 나타나자 왕비의 간청으로 창건했다는 전설이 깃든 장대한 규모의 사찰 터입니다.

            이곳은 특히 동서로 나란히 서 있는 두 개의 석탑과 국보 제11호인 미륵사지 석탑(서탑)으로 유명합니다. 이 석탑은 우리나라에서 가장 크고 오래된 석탑으로, 목탑의 양식을 계승한 백제 시대 건축 기술의 정수를 보여줍니다.

            2015년 유네스코 세계문화유산에 등재되었으며, 미륵사지 석탑의 해체 보수 과정에서 사리장엄구 등 귀중한 유물들이 발견되어 백제 시대의 문화와 역사를 생생하게 증언하고 있습니다. 넓은 터를 걸으며 천년의 시간을 거슬러 올라가는 듯한 깊은 감동을 느낄 수 있습니다.
            """,
            spotSummary: "백제 무왕이 창건한 백제 최대의 사찰 터", 
            coordinate: CLLocationCoordinate2D(latitude: 35.9427, longitude: 126.9634) // 익산 미륵사지 실제 좌표
        ),
        Spot(
            spotName: "왕궁리 5층 석탑",
            spotImage: ["wanggungri1", "wanggungri2", "wanggungri3", "wanggungri4", "wanggungri5"], // 여러 이미지 파일명
            spotDetail: """
            익산 왕궁리유적은 백제 무왕이 도읍을 옮기기 위해 건설한 왕궁 터이자, 이후 사찰로 용도가 변경된 독특한 역사를 가진 장소입니다. 발굴 조사를 통해 확인된 궁궐 건물지, 공방, 정원 시설 등은 백제 왕궁의 구조와 생활상을 연구하는 데 귀중한 자료가 되고 있습니다.

            이곳의 중심에는 국보 제289호인 왕궁리 5층 석탑이 자리하고 있어, 백제의 뛰어난 석탑 조형미를 보여줍니다. 넓은 유적지를 천천히 거닐다 보면, 백제의 찬란했던 왕도 문화와 역사의 흔적을 깊이 있게 느껴볼 수 있습니다.

            특히, 해 질 녘 노을이 석탑을 비추는 풍경은 많은 방문객에게 잊지 못할 감동을 선사합니다. 왕궁리유적전시관에서는 발굴 유물과 함께 자세한 유적의 역사를 만나볼 수 있습니다.
            """,
            spotSummary: "백제 무왕이 왕궁을 짓고 이후 사찰로 용도를 변경하여 사용했던 유적지",
            coordinate: CLLocationCoordinate2D(latitude: 35.9431, longitude: 127.0270) // 익산 왕궁리 실제 좌표
        ),
        Spot(
            spotName: "보석박물관",
            spotImage: ["jewelrymuseum1", "jewelrymuseum2", "jewelrymuseum3", "jewelrymuseum4", "jewelrymuseum5"],
            spotDetail: """
            익산 보석박물관은 보석 가공 산업의 중심지였던 익산의 역사를 기리고, 보석의 아름다움을 널리 알리기 위해 건립된 곳입니다. 내부에는 세계 각지에서 수집된 진귀한 보석과 원석들이 전시되어 있습니다.

            특히, 100억 원 상당의 다이아몬드, 루비, 사파이어 등 희귀 보석들을 직접 볼 수 있는 전시실과, 화려한 보석 꽃 조형물은 관람객들의 탄성을 자아냅니다.

            보석박물관과 함께 운영되는 익산공룡테마공원은 다양한 공룡 조형물과 체험 시설을 갖추고 있어, 아이를 동반한 가족 방문객에게 큰 인기를 끌고 있습니다. 보석의 찬란함과 공룡의 웅장함을 동시에 경험할 수 있는 복합 문화 공간입니다.
            """,
            spotSummary: "백제 문화유적과 보석의 아름다움을 관광자원으로 활용하기 위해 건립된 박물관",
            coordinate: CLLocationCoordinate2D(latitude: 35.990806, longitude: 127.102563)
        ),
        Spot(
            spotName: "서동공원",
            spotImage: ["seodongpark1", "seodongpark2", "seodongpark3", "seodongpark4"],
            spotDetail:"""
            익산 서동공원은 백제 무왕의 어린 시절 이름인 서동과 신라 선화공주의 애틋한 사랑 이야기가 담긴 '서동요'를 테마로 조성된 곳입니다. 금마저수지를 끼고 있어 아름다운 수변 풍경을 자랑하며, 공원 곳곳에는 서동과 선화공주의 조각상을 비롯해 다양한 조형물들이 세워져 있습니다.

            봄에는 화려한 철쭉이 만개하고, 시원한 호수 주변을 따라 걷는 산책로는 익산 시민들과 방문객들에게 편안한 휴식과 힐링을 제공합니다. 매년 5월에는 서동요를 주제로 한 익산서동축제가 열려, 더욱 풍성한 볼거리와 즐길 거리를 제공합니다.

            역사적 이야기를 담고 있는 아름다운 자연 속에서 평화로운 시간을 보낼 수 있는 익산의 대표적인 관광 명소입니다.
            """,
            spotSummary: "백제 무왕과 선화공주의 사랑 이야기를 테마로 조성된 공원",
            coordinate: CLLocationCoordinate2D(latitude: 36.001114, longitude: 127.057518)
        ),
        Spot(
            spotName: "서동시장",
            spotImage: ["seodongmarket1", "seodongmarket2", "seodongmarket3", "seodongmarket4", "seodongmarket5"],
            spotDetail:"""
            익산 서동시장은 익산의 활기찬 정취를 느낄 수 있는 대표적인 전통시장입니다. 신선한 농산물, 해산물, 다양한 먹거리들이 풍부하게 갖춰져 있어, 지역 주민들의 삶과 밀접한 공간입니다.

            특히 시장에서만 맛볼 수 있는 특별한 먹거리와 익산의 지역 특산품을 저렴하게 구매할 수 있으며, 상인들의 따뜻한 인심과 활기 넘치는 분위기 속에서 시장의 매력을 제대로 느껴볼 수 있습니다.

            익산의 역사와 함께해 온 서동시장은 단순한 쇼핑 공간을 넘어, 지역 문화와 전통을 체험할 수 있는 소중한 장소로 자리매김하고 있습니다. 전통시장의 정겨움을 느끼고 싶은 분들께 추천합니다.
            """,
            spotSummary: "익산역과 가까운 곳에 위치한 활기찬 전통시장",
            coordinate: CLLocationCoordinate2D(latitude: 35.946904, longitude: 126.950516)
        )
    ]
    
    // 특정 유적지 이름을 통해 Spot 객체를 찾아 반환하는 함수입니다.
    public func getSpotData(spot: String) -> Spot? {
        return arrSpot.filter { $0.spotName == spot }.first
    }
}
