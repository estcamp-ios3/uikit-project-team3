//
//  SpotModel.swift
//  TimeTravel
//
//  Created by chohoseo on 7/30/25.
//

import Foundation
import CoreLocation //위도 경도 넣을때 필요

// 유적지 상세 정보 모델
struct SpotInfo {
    let address: String
    let phone: String
    let website: String
    let cost: String
    let openTime: String
}

// 유적지 단일 항목 모델
struct Spot: Identifiable {
    let id = UUID()
    let spotName: String
    let spotImage: [String]
    let spotDetail: String
    let coordinate: CLLocationCoordinate2D
    let info: SpotInfo
}

// 데이터 관리 클래스
class SpotModel: ObservableObject {
    static let shared = SpotModel()

    let arrSpot: [Spot] = [
        Spot(
            spotName: "익산 미륵사지",
            spotImage: ["miruksa1", "miruksa2"], // 예시 이미지 파일명
            spotDetail: """
            익산 미륵사지는 백제 무왕이 선화공주와 함께 용화산 사자사를 향하던 중 연못에서 미륵삼존이 나타나자 왕비의 간청으로 창건했다는 전설이 깃든 장대한 규모의 사찰 터입니다.

            이곳은 특히 동서로 나란히 서 있는 두 개의 석탑과 국보 제11호인 미륵사지 석탑(서탑)으로 유명합니다. 이 석탑은 우리나라에서 가장 크고 오래된 석탑으로, 목탑의 양식을 계승한 백제 시대 건축 기술의 정수를 보여줍니다.

            2015년 유네스코 세계문화유산에 등재되었으며, 미륵사지 석탑의 해체 보수 과정에서 사리장엄구 등 귀중한 유물들이 발견되어 백제 시대의 문화와 역사를 생생하게 증언하고 있습니다. 넓은 터를 걸으며 천년의 시간을 거슬러 올라가는 듯한 깊은 감동을 느낄 수 있습니다.
            """ ,
            
            coordinate: CLLocationCoordinate2D(latitude: 36.0108, longitude: 127.0305),
            info: SpotInfo(
                address: "전북특별자치도 익산시 금마면 미륵사지로 362",
                phone: "063-830-0900",
                website: "www.iksan.go.kr",
                cost: "무료",
                openTime: "연중무휴"
            )
        ),
        Spot(
            spotName: "익산 왕궁리유적",
            spotImage: ["wanggungri1", "wanggungri2"], // 예시 이미지 파일명
            spotDetail: """
            익산 왕궁리유적은 백제 무왕이 도읍을 옮기기 위해 건설한 왕궁 터이자, 이후 사찰로 용도가 변경된 독특한 역사를 가진 장소입니다. 발굴 조사를 통해 확인된 궁궐 건물지, 공방, 정원 시설 등은 백제 왕궁의 구조와 생활상을 연구하는 데 귀중한 자료가 되고 있습니다.

            이곳의 중심에는 국보 제289호인 왕궁리 5층 석탑이 자리하고 있어, 백제의 뛰어난 석탑 조형미를 보여줍니다. 넓은 유적지를 천천히 거닐다 보면, 백제의 찬란했던 왕도 문화와 역사의 흔적을 깊이 있게 느껴볼 수 있습니다.

            특히, 해 질 녘 노을이 석탑을 비추는 풍경은 많은 방문객에게 잊지 못할 감동을 선사합니다. 왕궁리유적전시관에서는 발굴 유물과 함께 자세한 유적의 역사를 만나볼 수 있습니다.
            """,
            coordinate: CLLocationCoordinate2D(latitude: 35.9736, longitude: 127.0530),
            info: SpotInfo(
                address: "전북특별자치도 익산시 왕궁면 궁성로 666",
                phone: "063-859-4631",
                website: "www.iksan.go.kr/wg",
                cost: "무료",
                openTime: "09:00 ~ 18:00 (전시관은 월요일, 1월 1일 휴무)"
            )
        ),
        Spot(
            spotName: "익산 보석박물관",
            spotImage: ["jewelrymuseum1", "jewelrymuseum2"], // 예시 이미지 파일명
            spotDetail: """
            익산 보석박물관은 보석 가공 산업의 중심지였던 익산의 역사를 기리고, 보석의 아름다움을 널리 알리기 위해 건립된 곳입니다. 내부에는 세계 각지에서 수집된 진귀한 보석과 원석들이 전시되어 있습니다.

            특히, 100억 원 상당의 다이아몬드, 루비, 사파이어 등 희귀 보석들을 직접 볼 수 있는 전시실과, 화려한 보석 꽃 조형물은 관람객들의 탄성을 자아냅니다.

            보석박물관과 함께 운영되는 익산공룡테마공원은 다양한 공룡 조형물과 체험 시설을 갖추고 있어, 아이를 동반한 가족 방문객에게 큰 인기를 끌고 있습니다. 보석의 찬란함과 공룡의 웅장함을 동시에 경험할 수 있는 복합 문화 공간입니다.
            """,
            coordinate: CLLocationCoordinate2D(latitude: 35.9818, longitude: 127.0544),
            info: SpotInfo(
                address: "전북특별자치도 익산시 왕궁면 호반로 8",
                phone: "063-859-4641",
                website: "www.jewelmuseum.go.kr",
                cost: "성인 3,000원",
                openTime: "10:00 ~ 18:00 (월요일, 1월 1일 휴관)"
            )
        ),
        Spot(
            spotName: "익산 교도소세트장",
            spotImage: ["prisonset1", "prisonset2"], // 예시 이미지 파일명
            spotDetail: """
            폐교 부지를 활용하여 조성된 익산 교도소세트장은 국내에서 유일한 교도소 전문 영화 촬영지입니다. 이곳은 영화 '홀리데이', '7번방의 선물', 드라마 '아이리스' 등 수많은 인기 작품의 배경이 되었으며, 실제 교도소와 흡사한 독방, 면회실, 취조실 등의 시설을 생생하게 체험할 수 있습니다.

            이색적인 분위기 속에서 죄수복이나 교도관복을 대여하여 특별한 사진을 남기는 체험은 방문객들에게 큰 즐거움을 줍니다. 교도소 내부의 다양한 포토존과 감옥 체험은 젊은 층에게 특히 인기가 많아, 색다른 추억을 만들고 싶은 사람들에게 추천하는 장소입니다.

            영화와 드라마를 좋아한다면, 이곳에서 작품 속 주인공이 되어보는 특별한 경험을 할 수 있습니다.
            """,
            coordinate: CLLocationCoordinate2D(latitude: 36.0353, longitude: 126.9632),
            info: SpotInfo(
                address: "전북특별자치도 익산시 성당면 함낭로 207",
                phone: "063-859-3836",
                website: "www.iksan.go.kr/tour",
                cost: "무료",
                openTime: "09:00 ~ 18:00 (월요일 휴무)"
            )
        ),
        Spot(
            spotName: "익산 서동공원",
            spotImage: ["seodongpark1", "seodongpark2"], // 예시 이미지 파일명
            spotDetail:"""
            익산 서동공원은 백제 무왕의 어린 시절 이름인 서동과 신라 선화공주의 애틋한 사랑 이야기가 담긴 '서동요'를 테마로 조성된 곳입니다. 금마저수지를 끼고 있어 아름다운 수변 풍경을 자랑하며, 공원 곳곳에는 서동과 선화공주의 조각상을 비롯해 다양한 조형물들이 세워져 있습니다.

            봄에는 화려한 철쭉이 만개하고, 시원한 호수 주변을 따라 걷는 산책로는 익산 시민들과 방문객들에게 편안한 휴식과 힐링을 제공합니다. 매년 5월에는 서동요를 주제로 한 익산서동축제가 열려, 더욱 풍성한 볼거리와 즐길 거리를 제공합니다.

            역사적 이야기를 담고 있는 아름다운 자연 속에서 평화로운 시간을 보낼 수 있는 익산의 대표적인 관광 명소입니다.
            """,
            coordinate: CLLocationCoordinate2D(latitude: 36.0015, longitude: 126.9022),
            info: SpotInfo(
                address: "전북특별자치도 익산시 금마면 고도9길 41-14",
                phone: "063-859-4633",
                website: "www.iksan.go.kr/tour",
                cost: "무료",
                openTime: "상시개방"
            )
        ),
        Spot(
            spotName: "익산 서동시장",
            spotImage: ["seodongmarket1", "seodongmarket2"], // 예시 이미지 파일명
            spotDetail:"""
            익산 서동시장은 익산의 활기찬 정취를 느낄 수 있는 대표적인 전통시장입니다. 신선한 농산물, 해산물, 다양한 먹거리들이 풍부하게 갖춰져 있어, 지역 주민들의 삶과 밀접한 공간입니다.

            특히 시장에서만 맛볼 수 있는 특별한 먹거리와 익산의 지역 특산품을 저렴하게 구매할 수 있으며, 상인들의 따뜻한 인심과 활기 넘치는 분위기 속에서 시장의 매력을 제대로 느껴볼 수 있습니다.

            익산의 역사와 함께해 온 서동시장은 단순한 쇼핑 공간을 넘어, 지역 문화와 전통을 체험할 수 있는 소중한 장소로 자리매김하고 있습니다. 전통시장의 정겨움을 느끼고 싶은 분들께 추천합니다.
            """,            coordinate: CLLocationCoordinate2D(latitude: 35.9491, longitude: 126.9535),
            info: SpotInfo(
                address: "전북특별자치도 익산시 중앙로3길 39-1",
                phone: "063-842-0063",
                website: "jbsj.kr",
                cost: "별도 입장료 없음",
                openTime: "점포별 상이"
            )
        )
    ]
}
