//
//  MapView.swift
//  TimeTravel
//
//  Created by chohoseo on 7/30/25.
//

import UIKit
import MapKit // MapView를 보여주기 위한 기술
import CoreLocation  // 현재 위치 확인 및 활용을 위한 기술


class MapView: UIViewController  {
    
    let mapView = MKMapView()
    let locationManager = CLLocationManager() // 위치정보를 처리할 인스턴스
    
    
    /*
     Info.plist
     
     <key>NSLocationWhenInUseUsageDescription</key>
     <string>이 앱은 현재 위치를 지도에 표시하기 위해 위치 권한이 필요합니다.</string>
     
     */
    
    let spots = [
        ("미륵사지", 35.9495, 126.9549),
        ("동원9층석탑", 35.9470, 126.9530),
        ("미륵사지당간지주", 35.9498, 126.9552),
        ("국립익산박물관", 35.9443, 126.9635),
        ("미륵사지석탑", 35.9493, 126.9545)
    ]
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        
        setupMapView()
        //        setupLocation() // 위치정보
        
    }
    
    
    
    
    private func setupMapView() {
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6)
        ])
        
        mapView.delegate = self
        
        // 스팟들
        for spot in spots {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: spot.1, longitude: spot.2)
            annotation.title = spot.0
            mapView.addAnnotation(annotation)
        }
        
    }
}
    
    // MARK: - CLLocationManagerDelegate 확장
    extension MapView: CLLocationManagerDelegate {
        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            // 위치 권한 변경 시 처리
            // setupLocation() 함수 안에 checkLocationAuthorization()을 호출하는 로직이 있다면 여기서 다시 호출할 수 있습니다.
            switch manager.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                manager.startUpdatingLocation()
                mapView.showsUserLocation = true
            case .denied, .restricted:
                // 권한 없을 때 처리 (예: 알림 표시)
                // showLocationDeniedAlert()
                break
            default:
                break
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let loc = locations.first {
                let region = MKCoordinateRegion(center: loc.coordinate,
                                                latitudinalMeters: 1000,
                                                longitudinalMeters: 1000)
                mapView.setRegion(region, animated: true)
                manager.stopUpdatingLocation() // 초기 위치 설정 후 업데이트 멈춤
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("위치 정보 못 가져옴: \(error.localizedDescription)")
        }
    }

    // MARK: - MKMapViewDelegate 확장
extension MapView: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
        // 1. MKUserLocation (사용자 현재 위치)에 대한 처리
        if annotation is MKUserLocation {
            // MKUserLocation은 기본 파란색 점으로 표시되므로, nil을 반환하여 시스템 기본값을 사용합니다.
            return nil
        }
            
        // 2. 사용자 정의 핀(annotation)에 대한 처리
        let identifier = "spotPin"
        // MKMarkerAnnotationView를 재사용하거나 새로 생성합니다.
        // as? MKMarkerAnnotationView를 사용하여 타입을 명확히 합니다.
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
            
        if annotationView == nil {
            // 재사용 가능한 뷰가 없으면 새로 생성합니다.
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true // 핀 탭 시 정보창 표시
            // MKMarkerAnnotationView의 애니메이션 속성은 animatesWhenAdded입니다.
            annotationView?.animatesWhenAdded = true // 핀이 추가될 때 애니메이션 효과
                
            // 핀 정보창에 버튼 추가 (선택 사항)
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            // 재사용 가능한 뷰가 있다면, 현재 주석(annotation)으로 업데이트합니다.
            annotationView?.annotation = annotation
        }
            
        // 마커 핀의 색상을 설정하는 속성은 markerTintColor입니다.
        annotationView?.markerTintColor = .red // 지역 핀은 빨간색으로 설정
            
        // 최종적으로 구성된 annotationView를 반환합니다.
        return annotationView
    }
        
    // 핀 버튼 클릭 이벤트 처리
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                    calloutAccessoryControlTapped control: UIControl) {
            
        // 탭된 핀의 제목을 가져옵니다.
        guard let annotationTitle = view.annotation?.title ?? nil else { return }
            
        // 탭된 핀의 정보를 보여주는 알림창을 띄웁니다.
        let alert = UIAlertController(title: annotationTitle,
                                        message: "여기에 \(annotationTitle) 상세 정보를 표시하세요.",
                                        preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "닫기", style: .default))
        present(alert, animated: true)
    }
    
    }
    
    




#Preview {
    
    UINavigationController(rootViewController: MapView())
}
