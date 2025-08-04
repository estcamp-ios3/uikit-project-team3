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
    
    // 이전에 선택된 테마를 저장하는 정적(static) 변수
       // HomeView에서 이 변수에 테마를 할당하고, MapView는 이 변수를 사용합니다.
       static var sharedTheme: Theme?
    
    // HomeView에서 넘어온 title을 받기 위한 변수
    var theme: Theme? {
        didSet {
            // theme 변수가 설정되면 sharedTheme에도 저장
            MapView.sharedTheme = theme
        }
    }
    
    let mapView = MKMapView()
    
    let locationManager = CLLocationManager() // 위치정보를 처리할 인스턴스
    
    
    
    /*
     Info.plist
     
     <key>NSLocationWhenInUseUsageDescription</key>
     <string>이 앱은 현재 위치를 지도에 표시하기 위해 위치 권한이 필요합니다.</string>
     
     */
    
    
    // 코스 이미지
    let courseImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    // 버튼 스크롤
    let horizontalScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    // 전체 스택뷰
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        return stackView
    }()
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        
                
        // viewDidLoad 시점에 theme이 nil이면 sharedTheme을 사용합니다.
               // 이렇게 하면 다른 탭을 갔다가 돌아왔을 때 이전에 선택된 테마를 복원할 수 있습니다.
               if self.theme == nil {
                   self.theme = MapView.sharedTheme
               }
               
               guard let currentTheme = self.theme else {
                   print("Error: No theme data found.")
                   showNoThemeAlert()
                   return
               }
        
        
        self.title = currentTheme.theme
        self.courseImage.image = UIImage(named: currentTheme.imgCourse)
        
        
        
        setupMapUI(with: currentTheme)
        setupButtons(with: currentTheme)
        setupLocation()
        self.mapView.mapType = .standard
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        // 뷰가 화면에 나타날 때마다 핀 애니메이션을 시작합니다.
        startPinAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 뷰가 화면에서 사라질 때 핀 애니메이션을 중지합니다.
        stopPinAnimation()
    }
    
    
    private func setupMapUI(with theme: Theme) {
        
        courseImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(courseImage)
        
        horizontalScrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(horizontalScrollView)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalScrollView.addSubview(stackView)
        
        
        
        NSLayoutConstraint.activate([
            courseImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            courseImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            courseImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            courseImage.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        NSLayoutConstraint.activate([
            horizontalScrollView.topAnchor.constraint(equalTo: courseImage.bottomAnchor),
            horizontalScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            horizontalScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            horizontalScrollView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: horizontalScrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: horizontalScrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: horizontalScrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: horizontalScrollView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: horizontalScrollView.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        mapView.delegate = self
        
        
        // 🔧 ④ 기존 static spots 대신, theme 기반 spots 사용
        for spot in theme.arrCourse {
            let annotation = MKPointAnnotation()
            annotation.coordinate = spot.coordinate
            annotation.title = spot.courseName
            mapView.addAnnotation(annotation)
            
        }
        
    }
    
    
    private func setupButtons(with theme: Theme) {
        
        // 내 위치 버튼
        var myLocationConfig = UIButton.Configuration.plain()
        myLocationConfig.title = "현재 위치"
        myLocationConfig.titlePadding = 0
        myLocationConfig.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
        myLocationConfig.baseForegroundColor = .black
        
        // 버튼 스타일링
        let myLocationButton = UIButton(configuration: myLocationConfig, primaryAction: nil)
        myLocationButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        myLocationButton.tag = -1
        myLocationButton.addTarget(self, action: #selector(spotButtonTapped(_:)), for: .touchUpInside)
        
        myLocationButton.layer.cornerRadius = 15
        myLocationButton.layer.borderWidth = 1
        myLocationButton.layer.borderColor = UIColor.red.cgColor   // 현재 위치 버튼 테두리 빨간색
        myLocationButton.backgroundColor = .white
        
        
        stackView.addArrangedSubview(myLocationButton)
        
        
        // 스팟들 버튼
        for (index, spot) in theme.arrCourse.enumerated() {
            // UIButton.Configuration을 사용해 버튼 생성
            var config = UIButton.Configuration.plain()
            config.title = spot.courseName
            config.titlePadding = 0
            config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
            config.baseForegroundColor = .black
            
            let button = UIButton(configuration: config, primaryAction: nil)
            
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            button.tag = index // 버튼 태그를 스팟 배열의 인덱스로 설정
            button.addTarget(self, action: #selector(spotButtonTapped(_:)), for: .touchUpInside)
            
            
            
            // 버튼 스타일링
            button.layer.cornerRadius = 15
            button.layer.borderWidth = 1
            button.layer.borderColor = theme.color.cgColor
            button.backgroundColor = .white
            
            stackView.addArrangedSubview(button)
        }
        
    }
    
    // 나중에 현재위치로 할 시 사용
    @objc private func spotButtonTapped(_ sender: UIButton) {
        
        guard let theme = self.theme else { return }
        
        let spotIndex = sender.tag
        
        if spotIndex == -1 {
            // "현재 위치" 버튼을 누르면
            switch locationManager.authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                locationManager.startUpdatingLocation()
            default:
                let iksanStationLatitude: CLLocationDegrees = 35.9458
                let iksanStationLongitude: CLLocationDegrees = 126.9467
                let iksanLocation = CLLocationCoordinate2D(latitude: iksanStationLatitude, longitude: iksanStationLongitude)
                let region = MKCoordinateRegion(center: iksanLocation, latitudinalMeters: 500, longitudinalMeters: 500)
                mapView.setRegion(region, animated: true)
                
                if let annotation = mapView.annotations.first(where: {
                    ($0 as? MKPointAnnotation)?.title == "현재 위치"
                }) {
                    mapView.selectAnnotation(annotation, animated: true)
                }
            }
        } else {
            // 다른 스팟 버튼을 누르면 해당 스팟으로 이동
            let selectedSpot = theme.arrCourse[spotIndex]
            let coordinate = selectedSpot.coordinate
            
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
            mapView.setRegion(region, animated: true)
            
            // 해당 스팟 핀 선택
            if let annotation = mapView.annotations.first(where: {
                $0.title == selectedSpot.courseName
            }) {
                mapView.selectAnnotation(annotation, animated: true)
            }
        }
        
    }
    
    
    //    @objc private func spotButtonTapped(_ sender: UIButton) {
    //        guard let theme = self.theme else { return }
    //
    //        let spotIndex = sender.tag
    //
    //        if spotIndex == -1 {
    //            // "현재 위치" 버튼을 누르면 가상 익산역으로 이동
    //            let iksanStationLatitude: CLLocationDegrees = 35.9458
    //            let iksanStationLongitude: CLLocationDegrees = 126.9467
    //            let iksanLocation = CLLocationCoordinate2D(latitude: iksanStationLatitude, longitude: iksanStationLongitude)
    //            let region = MKCoordinateRegion(center: iksanLocation, latitudinalMeters: 500, longitudinalMeters: 500)
    //            mapView.setRegion(region, animated: true)
    //
    //            if let annotation = mapView.annotations.first(where: {
    //                $0.title == "현재 위치"
    //            }) {
    //                mapView.selectAnnotation(annotation, animated: true)
    //            }
    //
    //        } else {
    //            let selectedSpot = theme.arrCourse[spotIndex]
    //            let coordinate = selectedSpot.coordinate
    //
    //            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
    //            mapView.setRegion(region, animated: true)
    //
    //            if let annotation = mapView.annotations.first(where: {
    //                $0.title == selectedSpot.courseName /*&&*/
    ////                $0.coordinate.latitude == selectedSpot.coordinate.latitude &&
    ////                $0.coordinate.longitude == selectedSpot.coordinate.longitude
    //            }) {
    //                mapView.selectAnnotation(annotation, animated: true)
    //            }
    //        }
    //    }
    
    
    
    // MARK: - 위치 권한 및 업데이트 설정
    private func setupLocation() {
        locationManager.delegate = self
        // 위치 정보 사용 승인 받기
        checkLocationAuthorization()
    }
    
    
    private func showNoThemeAlert() {
            let alert = UIAlertController(title: "테마를 선택해주세요",
                                          message: "홈 화면에서 먼저 테마를 선택해주세요.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
                // 사용자를 홈 탭으로 이동시킵니다.
                self.tabBarController?.selectedIndex = 0
            })
            present(alert, animated: true)
        }
    
    
    private func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            showLocationDeniedAlert()
        case .authorizedWhenInUse, .authorizedAlways:
            // 시스템의 파란색 점을 사용하지 않습니다.
            mapView.showsUserLocation = false
            locationManager.startUpdatingLocation()
            
            let myLocationAnnotation = MKPointAnnotation()
            myLocationAnnotation.title = "현재 위치"
            // 'reverseGeocodeAndAddPin'을 통해 정확한 현재 위치에 핀 추가
            if let currentLocation = locationManager.location {
                reverseGeocodeAndAddPin(at: currentLocation, title: "현재 위치")
            } else {
                // 위치 정보를 가져오지 못했을 때를 대비해 기본 익산역 위치를 사용
                let iksanLocation = CLLocation(latitude: 35.9458, longitude: 126.9467)
                reverseGeocodeAndAddPin(at: iksanLocation, title: "현재 위치")
            }
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
    
    
    
    // MARK: - 역지오코딩 후 핀 추가
    private func reverseGeocodeAndAddPin(at location: CLLocation, title: String) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self else { return }
            
            var subtitle = "Unknown Address"
            
            if let placemark = placemarks?.first {
                let parts: [String?] = [
                    placemark.name,
                    placemark.locality,
                    placemark.administrativeArea,
                    placemark.country
                ]
                subtitle = parts.compactMap { $0 }.joined(separator: ", ")
            }
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = title
            annotation.subtitle = subtitle
            self.mapView.addAnnotation(annotation)
        }
    }
    
    
    
    
    
    
    // MARK: - 핀 애니메이션 시작/중지
    private func startPinAnimation() {
        // "현재 위치" 핀만 찾아서 애니메이션을 시작합니다.
        guard let myLocationPin = mapView.annotations.first(where: {
            ($0 as? MKPointAnnotation)?.title == "현재 위치"
        }) as? MKPointAnnotation else {
            return
        }
        
        if let view = mapView.view(for: myLocationPin) as? MKMarkerAnnotationView {
            // 기존 애니메이션 뷰가 있다면 제거
            view.subviews.filter { $0.tag == 999 }.forEach { $0.removeFromSuperview() }
            
            // 새로운 애니메이션 뷰 생성
            let size: CGFloat = view.bounds.width * 1.8
            let pulseView = UIView(frame: CGRect(x: 0, y: 0, width: size, height: size))
            pulseView.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY - view.bounds.height / 4)
            pulseView.layer.cornerRadius = size / 2
            pulseView.backgroundColor = UIColor.red.withAlphaComponent(0.3)
            pulseView.alpha = 0.0
            pulseView.tag = 999
            
            view.insertSubview(pulseView, at: 0)
            
            // 애니메이션 시작
            UIView.animate(withDuration: 1.5, delay: 0, options: [.repeat, .autoreverse, .allowUserInteraction], animations: {
                pulseView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                pulseView.alpha = 0.6
            }, completion: nil)
        }
    }
    
    private func stopPinAnimation() {
        // "현재 위치" 핀만 찾아서 애니메이션을 중지합니다.
        guard let myLocationPin = mapView.annotations.first(where: {
            ($0 as? MKPointAnnotation)?.title == "현재 위치"
        }) as? MKPointAnnotation else {
            return
        }
        
        if let view = mapView.view(for: myLocationPin) {
            view.subviews.filter { $0.tag == 999 }.forEach { $0.removeFromSuperview() }
        }
    }
    
}





// MARK: - CLLocationManagerDelegate 확장
extension MapView: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.first else { return }
        
        // 현재 위치로 지도의 중심 영역을 설정하고 확대/축소 레벨을 조절합니다.
        let region = MKCoordinateRegion(center: currentLocation.coordinate,
                                        latitudinalMeters: 3000,
                                        longitudinalMeters: 3000)
        
        mapView.setRegion(region, animated: true)
        
        // 한 번 위치를 잡은 후에는 업데이트를 중지합니다 (배터리 소모 방지).
        // 계속해서 위치를 추적하려면 이 줄을 주석 처리하세요.
        manager.stopUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("📍 위치를 가져오지 못했습니다: \(error.localizedDescription)")
        
    }
}

//        // --- 익산역 가상 위치 설정 ---
//        let iksanStationLatitude: CLLocationDegrees = 35.9458 // 익산역 위도
//        let iksanStationLongitude: CLLocationDegrees = 126.9467 // 익산역 경도
//
//        let iksanLocation = CLLocation(latitude: iksanStationLatitude, longitude: iksanStationLongitude)

// 핀에 label 달아주기
//        reverseGeocodeAndAddPin(at: currentLocation, title: "현재 위치")

//        // 지도의 중심을 익산역으로 설정하고 확대/축소 레벨을 조절합니다.
//        let region = MKCoordinateRegion(center: iksanLocation.coordinate,
//                                        latitudinalMeters: 3000,
//                                        longitudinalMeters: 3000)

//        mapView.setRegion(region, animated: true)
//
//        // 한 번 위치를 잡은 후에는 업데이트를 중지합니다 (배터리 소모 방지).
//        // 계속해서 위치를 추적하려면 이 줄을 주석 처리하세요.
//        manager.stopUpdatingLocation()
//
//
//        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//            print("📍 위치를 가져오지 못했습니다: \(error.localizedDescription)")
//
//        }
//    }
//}



// MARK: - MKMapViewDelegate 확장
extension MapView: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        if let pointAnnotation = annotation as? MKPointAnnotation {
            let identifier = "spotPin"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
            
            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = false
                annotationView?.animatesWhenAdded = true
            } else {
                annotationView?.annotation = annotation
                // 재사용 시 기존 애니메이션 뷰를 제거하고 다시 시작합니다.
                annotationView?.subviews.filter { $0.tag == 999 }.forEach { $0.removeFromSuperview() }
            }
            
            guard let theme = self.theme else { return nil }
            
            // 핀 색상 설정
            if pointAnnotation.title == "현재 위치" {
                annotationView?.markerTintColor = .red
            } else {
                annotationView?.markerTintColor = theme.color
            }
            
            // 모든 핀에 맥박 애니메이션 추가
            let size: CGFloat = annotationView!.bounds.width * 1.8
            let pulseView = UIView(frame: CGRect(x: 0, y: 0, width: size, height: size))
            pulseView.center = CGPoint(x: annotationView!.bounds.midX, y: annotationView!.bounds.midY - annotationView!.bounds.height / 4)
            pulseView.layer.cornerRadius = size / 2
            pulseView.backgroundColor = (pointAnnotation.title == "현재 위치" ? UIColor.red : theme.color).withAlphaComponent(0.3)
            pulseView.alpha = 0.0
            pulseView.tag = 999
            
            annotationView?.insertSubview(pulseView, at: 0)
            
            // 애니메이션 적용
            UIView.animate(withDuration: 1.5, delay: 0, options: [.repeat, .autoreverse, .allowUserInteraction], animations: {
                pulseView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                pulseView.alpha = 0.6
            }, completion: nil)
            
            return annotationView
        }
        return nil
    }
    
    
    // MARK: - 핀을 탭하면 바로 SpotDetailView로 이동하는 로직 추가
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // 맵 뷰에서 어노테이션(핀)이 선택될 때 호출됩니다.
        
        guard let annotation = view.annotation else { return }
        
        // 내 현재 위치 핀(빨간색)을 탭했을 때는 상세 뷰로 이동하지 않도록 합니다.
        if annotation is MKUserLocation {
            print("현재 위치 핀은 상세 뷰가 없습니다.")
            return
        }
        
        // MKPointAnnotation 중 "나의위치" 핀은 상세 뷰로 이동하지 않도록 처리
        if let pointAnnotation = annotation as? MKPointAnnotation, pointAnnotation.title == "현재 위치" {
            print("나의위치 핀은 상세 뷰가 없습니다.")
            mapView.deselectAnnotation(annotation, animated: true)
            return
        }
        
        // 일반 스팟 핀(파란색)이 탭되면 SpotDetailView로 이동합니다.
        if annotation is MKPointAnnotation {
            //            let detailVC = SpotDetailView()
            //            self.navigationController?.pushViewController(detailVC, animated: true)
            // ?? 갑자기 오류가...
            
            // 핀을 탭한 후 바로 상세 뷰로 이동했으니, 핀 선택 상태를 해제하여 말풍선이 사라지게 합니다.
            mapView.deselectAnnotation(annotation, animated: true)
        }
    }
    
    
}



