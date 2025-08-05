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

    override func loadView() {
        view = mapView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupMap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func setupNavigationBar() {
        // 뒤로가기 버튼
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .black
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        mapView.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.width.height.equalTo(44)
        }
    }

    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }

    private func setupMap() {
        // 익산시청 위치를 중심으로 지도 설정
        let iksanCoordinate = CLLocationCoordinate2D(latitude: 35.9452, longitude: 126.9403)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: iksanCoordinate, span: span)
        mapView.mapView.setRegion(region, animated: true)

        // 스팟 데이터 (예시)
        let spots = [
            ("미륵사지", 35.9427, 126.9634),
            ("왕궁리 유적", 35.9431, 127.0270),
            ("익산 쌍릉", 35.9554, 126.9388)
        ]

        for spot in spots {
            let annotation = MKPointAnnotation()
            annotation.title = spot.0
            annotation.coordinate = CLLocationCoordinate2D(latitude: spot.1, longitude: spot.2)
            mapView.mapView.addAnnotation(annotation)
        }
    }
}

// Custom Annotation View를 사용해 로키 발자국 핀 구현
extension MapViewController: MKMapViewDelegate {
    // 델리게이트 메서드 구현
}
