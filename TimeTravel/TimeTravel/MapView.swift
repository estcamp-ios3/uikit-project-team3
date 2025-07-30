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
    
    
    // 시뮬은 현재 가상 위치이므로 나중에 info에서 설정해야 내 위치가 뜸
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
        setupLocation()  // 알림 자꾸 떠서 나중에 info와 같이 살리기
//        self.mapView.mapType = .satellite
        
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
    
    
    
    // MARK: - 위치 권한 및 업데이트 설정
     private func setupLocation() {
         locationManager.delegate = self
         // 위치 정보 사용 승인 받기
         checkLocationAuthorization()
     }
     
     private func checkLocationAuthorization() {
         switch locationManager.authorizationStatus {
         case .notDetermined:
             // 앱 사용 중에만 위치 권한 요청
             locationManager.requestWhenInUseAuthorization()
         case .restricted, .denied:
             // 권한 없을 때 사용자에게 알림
             showLocationDeniedAlert()
         case .authorizedWhenInUse, .authorizedAlways:
             // 권한이 있다면 위치 업데이트 시작
             locationManager.startUpdatingLocation()
             mapView.showsUserLocation = true // 지도에 사용자 현재 위치 파란색 점 표시
         @unknown default:
             break
         }
     }
     
     private func showLocationDeniedAlert() {
         let alert = UIAlertController(title: "위치 권한이 꺼져있습니다",
                                       message: "설정 > 개인정보 보호에서 위치 서비스를 허용해주세요.",
                                       preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "확인", style: .default))
         present(alert, animated: true)
     }
 }

// MARK: - CLLocationManagerDelegate 확장
extension MapView: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let currentLocation = locations.first {
//            // 현재 위치로 지도의 중심 영역을 설정하고 확대/축소 레벨을 조절합니다. - 나중에 현재위치로 할 때 주석해제
//            let region = MKCoordinateRegion(center: currentLocation.coordinate,
//                                            latitudinalMeters: 1000, // 1km 범위
//                                            longitudinalMeters: 1000)
            
            // --- 이 부분에 익산역 가상 위치 설정 로직 추가 ---
                 let iksanStationLatitude: CLLocationDegrees = 35.945924
                 let iksanStationLongitude: CLLocationDegrees = 126.957748
                 
                 let iksanLocation = CLLocation(latitude: iksanStationLatitude, longitude: iksanStationLongitude)
                 
                 // 현재 위치를 익산역으로 강제 설정
                 let region = MKCoordinateRegion(center: iksanLocation.coordinate,
                                                 latitudinalMeters: 1000, // 1km 범위
                                                 longitudinalMeters: 1000)
            
            mapView.setRegion(region, animated: true)
            
            // 한 번 위치를 잡은 후에는 업데이트를 중지합니다 (배터리 소모 방지).
            // 계속해서 위치를 추적하려면 이 줄을 주석 처리하세요.
            manager.stopUpdatingLocation()
//        }   if의 중괄호임
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("📍 위치를 가져오지 못했습니다: \(error.localizedDescription)")
    }
}



// MARK: - MKMapViewDelegate 확장
extension MapView: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // **내 현재 위치 핀 처리 (빨간색)**
        if let userLocation = annotation as? MKUserLocation {
            let identifier = "userLocationPin"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
            
            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: userLocation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                annotationView?.animatesWhenAdded = true
            } else {
                annotationView?.annotation = userLocation
            }
            // 사용자 현재 위치 핀을 빨간색으로 설정
            annotationView?.markerTintColor = .red
            return annotationView
        }
        
        // **나머지 Spots 핀 처리 (파란색)**
        if annotation is MKPointAnnotation {
            let identifier = "spotPin"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
            
            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                annotationView?.animatesWhenAdded = true
                
            } else {
                annotationView?.annotation = annotation
            }
            
            // Spots 핀은 파란색으로 설정
            annotationView?.markerTintColor = .blue
            
            return annotationView
        }
        
        return nil
    }
    
    
    
    
}
    
    


#Preview {
    
    UINavigationController(rootViewController: MapView())
}
