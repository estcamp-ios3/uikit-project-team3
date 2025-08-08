//
//  QuestMapView.swift
//  TimeTravel
//
//  Created by chohoseo on 7/30/25.
//

import UIKit
import MapKit
import CoreLocation
import AVFoundation

class QuestMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    var spotName: String
    var quest: Quest
    
    var itemPosition: CLLocationCoordinate2D
    var itemPositions: [CLLocationCoordinate2D] = []
    var foundItems: Set<Int> = []
    
    var isMusicOn = true
    var bgmPlayer: AVAudioPlayer?
    
    let questView = QuestMapView()
    let locationManager = CLLocationManager()
    
    lazy var itemRandomOffsets: [(lat: Double, lon: Double, id: Int)] = [
        (0.0003, 0.0003, 0),
        (-0.0004, 0.0005, 1),
        (0.0008, -0.0008, 2),
        (-0.0003, -0.0006, 3)
    ]
    init(spotName: String) {
        self.spotName = spotName
        self.quest = QuestModel.shared.getQuest(spotName: spotName)
        self.itemPosition = CLLocationCoordinate2D(latitude: quest.item[0].itemLatitude, longitude: quest.item[0].itemLongtitude)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = questView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        questView.mapView.delegate = self
        locationManager.delegate = self
        
        questView.titleLabel.text = "퀘스트: \(quest.questName)"
        questView.descriptionLabel.text = quest.questDetail
        
        setupActions()
        setupMap()
        setupItems()
        playBackgroundMusic()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        bgmPlayer?.stop()
    }
    
    func offsetCoord(lat: Double, lon: Double) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: itemPosition.latitude + lat, longitude: itemPosition.longitude + lon)
    }
    
    func playBackgroundMusic() {
        guard let url = Bundle.main.url(forResource: quest.bgm, withExtension: "mp3") else {
            print("❗️배경음악 파일을 찾을 수 없습니다.")
            return
        }
        do {
            bgmPlayer = try AVAudioPlayer(contentsOf: url)
            bgmPlayer?.numberOfLoops = -1
            bgmPlayer?.volume = 0.0
            bgmPlayer?.prepareToPlay()
            bgmPlayer?.play()
            fadeInVolume()
        } catch {
            print("🎧 배경음악 재생 오류:", error)
        }
    }
    
    func fadeInVolume() {
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
            guard let player = self.bgmPlayer else {
                timer.invalidate()
                return
            }
            if player.volume < 0.08 {
                player.volume += 0.02
            } else {
                player.volume = 0.08
                timer.invalidate()
            }
        }
    }
    
    func setupActions() {
        questView.closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        questView.musicToggleButton.addTarget(self, action: #selector(toggleMusic), for: .touchUpInside)
        questView.questionButton.addTarget(self, action: #selector(showDetailView), for: .touchUpInside)
    }
    
    @objc func showDetailView() {
        bgmPlayer?.stop()
        let detailVC = SpotDetailViewController()
        detailVC.spotName = spotName
        present(detailVC, animated: true)
    }
    
    @objc func close() {
        //dismiss(animated: true)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func toggleMusic() {
        if isMusicOn {
            bgmPlayer?.pause()
            questView.musicToggleButton.setImage(UIImage(systemName: "headphones.slash"), for: .normal)
        } else {
            bgmPlayer?.play()
            questView.musicToggleButton.setImage(UIImage(systemName: "headphones"), for: .normal)
        }
        isMusicOn.toggle()
    }
    
    func setupMap() {
        questView.mapView.showsUserLocation = false
        
        let region = MKCoordinateRegion(center: itemPosition, latitudinalMeters: 200, longitudinalMeters: 200)
        questView.mapView.setRegion(region, animated: false)
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let fakeMyPosition = MKPointAnnotation()
        fakeMyPosition.coordinate = CLLocationCoordinate2D(latitude: 35.954300, longitude: 126.957150)
        fakeMyPosition.title = "나"
        questView.mapView.addAnnotation(fakeMyPosition)
    }
    
    func setupItems() {
        itemPositions.removeAll()
        questView.mapView.removeAnnotations(questView.mapView.annotations.filter { $0 !== questView.mapView.userLocation && $0.title != "나" })
        
        if quest.item[0].isRandom {
            for i in itemRandomOffsets {
                let coord = offsetCoord(lat: i.lat, lon: i.lon)
                itemPositions.append(coord)
            }
        } else {
            // 실제 퀘스트 아이템 위치 추가
            for item in quest.item {
                itemPositions.append(CLLocationCoordinate2D(latitude: item.itemLatitude,
                                                            longitude: item.itemLongtitude))
            }
        }
        for (i, pos) in itemPositions.enumerated() {
            let annotation = MKPointAnnotation()
            annotation.coordinate = pos
            annotation.title = "보물 \(quest.item[0].itemName) \(i)"
            questView.mapView.addAnnotation(annotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            let id = "me"
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: id) as? MKMarkerAnnotationView
            if view == nil {
                view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: id)
            }
            view?.markerTintColor = .red
            return view
        }
        
        if let title = annotation.title, title == "나" {
            let id = "me"
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: id) as? MKMarkerAnnotationView
            if view == nil {
                view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: id)
            }
            view?.markerTintColor = .red
            return view
        }
        
        if let title = annotation.title, title?.starts(with: "보물") == true {
            let id = "item"
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: id) as? MKMarkerAnnotationView
            if view == nil {
                view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: id)
                view?.canShowCallout = false
            }
            view?.markerTintColor = .systemYellow
            return view
        }
        
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let title = view.annotation?.title ?? "", title.starts(with: "보물") else { return }
        
        if let idString = title.split(separator: " ").last,
           let id = Int(idString), !foundItems.contains(id) {
            foundItems.insert(id)
            questView.progressView.progress = Float(foundItems.count) / 4.0
        }
        
        if foundItems.count == 4 {
            showCompletionAlert()
        }
    }
    
    func showCompletionAlert() {
        let alert = UIAlertController(title: "퀘스트 완료!", message: "모든 금가락지를 찾았습니다!", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            
            // 퀘스트 완료 상태를 UserModel에 저장합니다.
            UserModel.shared.addQuestProgress(self.spotName)
            
            
            // 마지막 퀘스트인 "왕궁리유적"인지 확인합니다.
            if self.spotName == "왕궁리유적" {
                // 마지막 퀘스트가 맞다면 EpilogueViewController로 이동합니다.
                let epilogueVC = EpilogueViewController()
                self.navigationController?.pushViewController(epilogueVC, animated: true)
            } else {
                // 마지막 퀘스트가 아니라면 MapViewController로 돌아갑니다.
                if let viewControllers = self.navigationController?.viewControllers {
                    for viewController in viewControllers {
                        if let mapVC = viewController as? MapViewController {
                            self.navigationController?.popToViewController(mapVC, animated: true)
                            return
                        }
                    }
                }
            }
        }
        
        
        //            // 1. 네비게이션 스택에 있는 모든 뷰 컨트롤러를 가져옵니다.
        //            if let viewControllers = self.navigationController?.viewControllers {
        //
        //                // 2. 뷰 컨트롤러 배열을 순회하며 MapViewController 인스턴스를 찾습니다.
        //                for viewController in viewControllers {
        //                    if let mapVC = viewController as? MapViewController {
        //                        // 3. MapViewController를 찾으면, 해당 인스턴스로 돌아갑니다.
        //                        self.navigationController?.popToViewController(mapVC, animated: true)
        //                        return
        //                    }
        //                }
        //            }
        
        alert.addAction(confirmAction)
        present(alert, animated: true)
    }
    
    
}

//#Preview {
//    QuestMapViewController(spotName: "서동시장")
//}
