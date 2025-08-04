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
    // ① 동적 생성된 스팟 배열을 저장할 프로퍼티
    private var spots: [(name: String, lat: CLLocationDegrees, lon: CLLocationDegrees)] = []
    
    let mapView = MKMapView()
    var theme: Theme!
    
    let locationManager = CLLocationManager() // 위치정보를 처리할 인스턴스
    
    // let arrTheme = LocalModel.share.themeData.filter{ $0.local == "잊혀진 유적" }
    
    // 시뮬은 현재 가상 위치이므로 나중에 info에서 설정해야 내 위치가 뜸
    /*
     Info.plist
     
     <key>NSLocationWhenInUseUsageDescription</key>
     <string>이 앱은 현재 위치를 지도에 표시하기 위해 위치 권한이 필요합니다.</string>
     
     */
    
    let courseImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "courseone")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    
    //아래 일시적으로 주석처리 함
//    let spots = [
//        ("미륵사지", 36.010937, 127.030684),
//        ("아가페정원", 36.019836, 126.957924),
//        ("왕궁리 유적",35.972969, 127.054877),
//        ("나바위 성당", 36.138465, 126.999489),
//        ("익산아트센터", 35.938774, 126.948141),
//        ("웅포 곰개나루길",36.067527, 126.878010),
//        ("서동공원", 36.0015063, 126.9022638),
//        ("익산근대역사관", 35.938258, 126.947985),
//        ("보석박물관",  35.990711, 127.103185),
//        ("입점리 고분", 36.046018, 126.870314),
//        ("교도소 세트장", 36.069729, 126.931253),
//    ]
    
    
    
    // 버튼 스크롤
    let horizontalScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
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
        
        
        //추가
        
        // ① 테마 정보로 화면 초기화
          title = theme.theme
          courseImage.image = UIImage(named: theme.imgCourse)

          // ② 프로퍼티 spots 에 데이터 할당 (로컬 let이 아님)
          spots = theme.arrCourse.map {
            (name: $0.courseName,
             lat:  $0.coordinate.latitude,
             lon:  $0.coordinate.longitude)
          }

        
        //추가한 부분
        setupMapUI()
        // 🔧 ③ 전달받은 theme로 화면 초기화
               self.title = theme.theme                                // 네비게이션 타이틀에 테마명
               courseImage.image = UIImage(named: theme.imgCourse)     // 이미지 설정
               // theme.arrCourse를 spots 배열로 변환
               spots = theme.arrCourse.map { course in
                   (
                       name: course.courseName,
                       lat: course.coordinate.latitude,
                       lon: course.coordinate.longitude
                   )
               }

     
             setupMapUI()
        
        setupButtons()
        setupLocation()  // 알림 자꾸 떠서 나중에 info와 같이 살리기
        self.mapView.mapType = .standard
        
    }
    
    
    
    
    private func setupMapUI() {
        
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
        for spot in spots {
            let annotation = MKPointAnnotation()
            
            annotation.title = spot.name
                        annotation.coordinate = CLLocationCoordinate2D(latitude: spot.lat,
                                                                       longitude: spot.lon)
                        mapView.addAnnotation(annotation)
            
        }
        
    }
    
    private func setupButtons() {
        
        // 🔧 ⑤ 버튼도 spots 배열을 기반으로 생성
               for (index, spot) in spots.enumerated() {
                   var config = UIButton.Configuration.plain()
                   config.title = spot.name
                   config.contentInsets = NSDirectionalEdgeInsets(top: 8,
                                                                   leading: 12,
                                                                   bottom: 8,
                                                                   trailing: 12)
                   let button = UIButton(configuration: config, primaryAction: nil)
                   button.tag = index
                   button.addTarget(self,
                                    action: #selector(spotButtonTapped(_:)),
                                    for: .touchUpInside)
            
            // 버튼 스타일링
            button.layer.cornerRadius = 15
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.systemBlue.cgColor
            button.backgroundColor = .systemBackground
            button.setTitleColor(.systemBlue, for: .normal)
            
            stackView.addArrangedSubview(button)
        }
    }
    
    
    @objc private func spotButtonTapped(_ sender: UIButton){
        // 🔧 ⑥ spots 배열에서 좌표를 읽어와 지도 이동
        let selected = spots[sender.tag]
        let coord = CLLocationCoordinate2D(latitude: selected.lat,
                                           longitude: selected.lon)
        let region = MKCoordinateRegion(center: coord,
                                        latitudinalMeters: 500,
                                        longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)

        // 핀 선택 표시
        for ann in mapView.annotations.compactMap({ $0 as? MKPointAnnotation }) {
            if ann.title == selected.name {
                mapView.selectAnnotation(ann, animated: true)
                break
            }
        }
    }
    
//    {
//        let spotIndex = sender.tag
//        let selectedSpot = spots[spotIndex]
//        
//        let coordinate = CLLocationCoordinate2D(latitude: selectedSpot.1, longitude: selectedSpot.2)
//        
//        // 지도의 중심을 선택된 스팟으로 이동
//        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
//        mapView.setRegion(region, animated: true)
//        
//        // 해당 스팟 핀을 선택하여 콜아웃 표시
//        if let annotation = mapView.annotations.first(where: {
//            $0.title == selectedSpot.0 &&
//            $0.coordinate.latitude == selectedSpot.1 &&
//            $0.coordinate.longitude == selectedSpot.2
//        }) {
//            mapView.selectAnnotation(annotation, animated: true)
//        }
//    }
    
    
    
    
    
    
    
    
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
        
        //            mapView.setRegion(region, animated: true)
        
        // 한 번 위치를 잡은 후에는 업데이트를 중지합니다 (배터리 소모 방지).
        // 계속해서 위치를 추적하려면 이 줄을 주석 처리하세요.
        //            manager.stopUpdatingLocation()
        //            //        }   if의 중괄호임
        //        }
        //
        //        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //            print("📍 위치를 가져오지 못했습니다: \(error.localizedDescription)")
        
        // --- 익산역 가상 위치 설정 ---
        //        let iksanStationLatitude: CLLocationDegrees = 35.9458 // 익산역 위도
        //        let iksanStationLongitude: CLLocationDegrees = 126.9467 // 익산역 경도
        //
        //        let iksanLocation = CLLocation(latitude: iksanStationLatitude, longitude: iksanStationLongitude)
        //
        //        // 핀에 label 달아주기
        //        reverseGeocodeAndAddPin(at: iksanLocation, title: "나의위치")
        //
        //        // 지도의 중심을 익산역으로 설정하고 확대/축소 레벨을 조절합니다.
        //        let region = MKCoordinateRegion(center: iksanLocation.coordinate,
        //                                        latitudinalMeters: 3000,
        //                                        longitudinalMeters: 3000)
        //
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
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            // 🔧 1) 시뮬레이터(또는 실제 기기)가 제공하는 현재 위치 사용
            guard let currentLocation = locations.first else { return }
            
            // 🔧 2) 현재 위치에 핀 추가 (reverse geocode)
            reverseGeocodeAndAddPin(at: currentLocation, title: "나의위치")
            
            // 🔧 3) 지도 중심을 현재 위치로 설정
            let region = MKCoordinateRegion(
                center: currentLocation.coordinate,
                latitudinalMeters: 2000,
                longitudinalMeters: 2000
            )
            mapView.setRegion(region, animated: true)
            
            // 🔧 4) 위치 업데이트 한 번만 받고 정지
            manager.stopUpdatingLocation()
        }
    }
    }
    
    
    
    // MARK: - MKMapViewDelegate 확장
    extension MapView: MKMapViewDelegate {
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            // MKUserLocation (시스템의 파란색 사용자 위치 점)은 기본 뷰를 사용
            if annotation is MKUserLocation {
                return nil
            }
            
            // 나의위치 핀 (MKPointAnnotation으로 추가된 경우) 및 다른 스팟 핀 처리
            if annotation is MKPointAnnotation {
                let identifier = "spotPin"
                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
                
                if annotationView == nil {
                    annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                    annotationView?.canShowCallout = false // 콜아웃 비활성화
                    annotationView?.animatesWhenAdded = true
                } else {
                    annotationView?.annotation = annotation
                    // 뷰 재사용 시 기존에 추가된 pulseView를 찾아 제거하고 새로 시작합니다.
                    annotationView?.subviews.filter { $0.tag == 999 }.forEach { $0.removeFromSuperview() }
                }
                
                
                // "나의위치" 핀은 빨간색, 그 외 스팟 핀은 파란색
                if annotation.title == "나의위치" {
                    annotationView?.markerTintColor = .red
                } else {
                    annotationView?.markerTintColor = .blue
                }
                
                // 모든 MKPointAnnotation에 지속적인 맥박 애니메이션 추가
                // pulseView를 새로 생성하여 핀 뷰의 서브뷰로 추가합니다.
                let size: CGFloat = annotationView!.bounds.width * 1.8 // 핀 크기의 약 1.8배
                let pulseView = UIView(frame: CGRect(x: 0, y: 0, width: size, height: size))
                pulseView.center = CGPoint(x: annotationView!.bounds.midX, y: annotationView!.bounds.midY - annotationView!.bounds.height / 4) // 핀의 아래쪽에 위치
                pulseView.layer.cornerRadius = size / 2 // 원형으로
                pulseView.backgroundColor = UIColor.blue.withAlphaComponent(0.3) // 투명한 파란색
                pulseView.alpha = 0.0 // 초기 투명
                pulseView.tag = 999 // 나중에 이 뷰를 쉽게 찾아서 제거하기 위한 태그
                
                annotationView?.insertSubview(pulseView, at: 0) // 핀 아래에 추가
                
                // 애니메이션 적용
                UIView.animate(withDuration: 1.5, delay: 0, options: [.repeat, .autoreverse, .allowUserInteraction], animations: {
                    pulseView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3) // 커지는 효과
                    pulseView.alpha = 0.6 // 투명도 (더 잘 보이게)
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
            if let pointAnnotation = annotation as? MKPointAnnotation, pointAnnotation.title == "나의위치" {
                print("나의위치 핀은 상세 뷰가 없습니다.")
                mapView.deselectAnnotation(annotation, animated: true)
                return
            }
            
            // 일반 스팟 핀(파란색)이 탭되면 SpotDetailView로 이동합니다.
            if let pointAnnotation = annotation as? MKPointAnnotation, let spotName = pointAnnotation.title {
                let detailVC = SpotDetailViewController()
                
                // 핀의 제목(spotName)을 상세 화면으로 전달
                detailVC.spotName = spotName
                // 만약 SpotDetailView에 스팟 정보(제목, 좌표 등)를 전달하고 싶다면
                // SpotDetailView 클래스에 해당 속성을 추가하고 여기서 값을 할당할 수 있습니다.
                // 예시:
                // detailVC.spotTitle = annotation.title
                // detailVC.spotCoordinate = annotation.coordinate
                
                self.navigationController?.pushViewController(detailVC, animated: true)
                
                // 핀을 탭한 후 바로 상세 뷰로 이동했으니, 핀 선택 상태를 해제하여 말풍선이 사라지게 합니다.
                mapView.deselectAnnotation(annotation, animated: true)
            }
        }
        
        
    }
    
    
    
  
