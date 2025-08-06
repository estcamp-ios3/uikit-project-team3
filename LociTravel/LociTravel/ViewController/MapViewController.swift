//
//  MapViewController.swift
//  LociTravel
//
//  Created by suji chae on 8/5/25.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    private let mapView = MapView()
    
    private var isQuestCompleted = true // 임시 상태
    
    override func loadView() {
        view = mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtonActions()
        addAnnotations()
        
        // 1) 톱니 버튼 액션 연결
                mapView.optionButton.addTarget(self, action: #selector(didTapOptionButton), for: .touchUpInside)
        // 2) 메뉴 버튼 액션 연결
        mapView.mapButton.addTarget(self, action: #selector(showMap), for: .touchUpInside)
        mapView.journalButton.addTarget(self, action: #selector(showJournal), for: .touchUpInside)
                mapView.recordBookButton.addTarget(self, action: #selector(showRecordBook), for: .touchUpInside)
        
    }
    
    private func setupButtonActions() {
        mapView.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
    }
    
    private func optionButtonActions() {
        mapView.optionButton.addTarget(self, action: #selector(didTapOptionButton), for: .touchUpInside)
    }
    
    @objc private func didTapBackButton() {
        navigationController?.popToRootViewController(animated: true) //뒤로가기 버튼 클릭시 초기화면(홈뷰)로 이동
    }
    
    @objc private func didTapOptionButton() {
        // 토글: 보였다 숨겼다
        let isHidden = mapView.menuTopConstraint.constant < 0
        mapView.menuTopConstraint.constant = isHidden ? 8 : -350
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.view.layoutIfNeeded()
        }
    }
        
        @objc private func showMap() {
                let vc = MapViewController() // 실제 지도로 교체
                navigationController?.pushViewController(vc, animated: true)
            }
            @objc private func showJournal() {
                let vc = QuestListViewController()
                navigationController?.pushViewController(vc, animated: true)
            }
            @objc private func showRecordBook() {
                let vc = SpotDetailViewController()
                navigationController?.pushViewController(vc, animated: true)
            }
        
      
    
    
    //맵에 유적지를 나타내는 핀이 아니라 버튼으로 레이아웃을 따로잡게 화면 레이아웃의 x, y 위치값을 고정해서 맵뷰에 보이도록 수정 할 예정.
    private func addAnnotations() {
        let mireuksa = MKPointAnnotation()
        mireuksa.title = "미륵사지 석탑"
        mireuksa.coordinate = CLLocationCoordinate2D(latitude: 35.9427, longitude: 126.9634)
        mapView.mapView.addAnnotation(mireuksa)
        
        let wanggungri = MKPointAnnotation()
        wanggungri.title = "왕궁리 5층 석탑"
        wanggungri.coordinate = CLLocationCoordinate2D(latitude: 35.9431, longitude: 127.0270)
        mapView.mapView.addAnnotation(wanggungri)
        
        if isQuestCompleted {
            let jesaksaji = MKPointAnnotation()
            jesaksaji.title = "보석박물관"
            jesaksaji.coordinate = CLLocationCoordinate2D(latitude: 35.9427, longitude: 126.9734)
            mapView.mapView.addAnnotation(jesaksaji)
        }
        
        let center = CLLocationCoordinate2D(latitude: 35.94, longitude: 126.99)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.mapView.setRegion(region, animated: false)
    }
    
    //버튼을 누르면 시나리오 화면으로 넘어가는 함수
}
