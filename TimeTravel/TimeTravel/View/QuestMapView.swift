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

class QuestMapView: UIViewController {
    var themeName: String
    var spotName: String
    var quest: Quest
    
    init(themeName: String, spotName: String) {
        self.themeName = themeName
        self.spotName = spotName
        self.quest = ScenarioModel.shared.getQuest(themeName: themeName, spotName: spotName)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //bgm
    var bgmPlayer: AVAudioPlayer?
    let musicToggleButton = UIButton()
    var isMusicOn = true
    
    //ui
    let mapView = MKMapView()
    let locationManager = CLLocationManager()
    
    let closeButton = UIButton()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let progressView = UIProgressView(progressViewStyle: .default)
    
    let iksanMarket = CLLocationCoordinate2D(latitude: 35.953040, longitude: 126.957370)
    var foundItems: Set<Int> = []
    
    // 임의 아이템 위치 (익산역 중심 반경 100m 이내)
    lazy var itemLocations: [(coordinate: CLLocationCoordinate2D, id: Int)] = {
        return [
            (offsetCoord(lat: 0.0003, lon: 0.0003), 0),
            (offsetCoord(lat: -0.0004, lon: 0.0005), 1),
            (offsetCoord(lat: 0.0008, lon: -0.0008), 2),
            (offsetCoord(lat: -0.0003, lon: -0.0006), 3)
        ]
    }()
    
    func offsetCoord(lat: Double, lon: Double) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: iksanMarket.latitude + lat,
                                      longitude: iksanMarket.longitude + lon)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupMap()
        setupItems()
        playBackgroundMusic()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 화면이 사라질 때 자동으로 음악 종료
        bgmPlayer?.stop()
    }
    
    func playBackgroundMusic() {
        guard let url = Bundle.main.url(forResource: quest.bgm, withExtension: "mp3") else {
            print("❗️배경음악 파일을 찾을 수 없습니다.")
            return
        }
        
        do {
            bgmPlayer = try AVAudioPlayer(contentsOf: url)
            bgmPlayer?.numberOfLoops = -1 // 무한 반복
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
            
            if player.volume < 0.6 {
                player.volume += 0.02
            } else {
                player.volume = 1.0
                timer.invalidate()
            }
        }
    }
    
    @objc func toggleMusic() {
        if isMusicOn {
            bgmPlayer?.pause()
            musicToggleButton.setImage(UIImage(systemName: "headphones.slash"), for: .normal)
        } else {
            bgmPlayer?.play()
            musicToggleButton.setImage(UIImage(systemName: "headphones"), for: .normal)
        }
        isMusicOn.toggle()
    }

}

extension QuestMapView {
    
    func setupUI() {
        [closeButton, musicToggleButton, titleLabel, descriptionLabel, progressView, mapView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        closeButton.setTitle("✕", for: .normal)
        closeButton.titleLabel?.font = .boldSystemFont(ofSize: 30)
        closeButton.setTitleColor(.black, for: .normal)
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        musicToggleButton.setImage(UIImage(systemName: "headphones"), for: .normal)
        musicToggleButton.tintColor = .black
        musicToggleButton.addTarget(self, action: #selector(toggleMusic), for: .touchUpInside)

        
        titleLabel.text = "퀘스트: \(quest.questName)"
        titleLabel.font = .boldSystemFont(ofSize: 24)
        
        descriptionLabel.text = quest.questDetail
        descriptionLabel.font = .systemFont(ofSize: 18)
        descriptionLabel.numberOfLines = 0
        
        progressView.progress = 0.0
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            // 헤드셋 버튼 (같은 높이, 오른쪽)
                musicToggleButton.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor),
                musicToggleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                musicToggleButton.widthAnchor.constraint(equalToConstant: 30),
                musicToggleButton.heightAnchor.constraint(equalToConstant: 30),
            
            titleLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            progressView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            progressView.heightAnchor.constraint(equalToConstant: 8),
            
            mapView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 10),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc func close() {
        dismiss(animated: true)
    }
}

extension QuestMapView: MKMapViewDelegate, CLLocationManagerDelegate {
    
    func setupMap() {
        mapView.delegate = self
        mapView.showsUserLocation = false //사용자 위치 잠시 꺼둠
        
        let region = MKCoordinateRegion(center: iksanMarket,
                                        latitudinalMeters: 250,
                                        longitudinalMeters: 250)
        mapView.setRegion(region, animated: false)
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        //가짜 나의 위치
        let fakeMyPosition = MKPointAnnotation()
        fakeMyPosition.coordinate = iksanMarket
        fakeMyPosition.title = "나"
        mapView.addAnnotation(fakeMyPosition)
    }
    
    //퀘스트 아이템 위치 생성
    func setupItems() {
        for (i, item)in quest.item.enumerated() {
            let annotation = MKPointAnnotation()
            annotation.coordinate.longitude = item.itemLongtitude
            annotation.coordinate.latitude = item.itemLatitude
            annotation.title = "\(item.itemName) \(i)"
            mapView.addAnnotation(annotation)
        }
    }
    
    // 핀 색상 설정
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
        
        if let title = annotation.title, title == "me" {
            let id = "me"
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: id) as? MKMarkerAnnotationView
            if view == nil {
                view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: id)
            }
            view?.markerTintColor = .red
            return view
        }
        
        if let title = annotation.title, title?.starts(with: quest.item[0].itemName) == true {
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
        guard let title = view.annotation?.title ?? "", title.starts(with: "보물상자") else { return }
        
        if let idString = title.split(separator: " ").last,
           let id = Int(idString), !foundItems.contains(id) {
            foundItems.insert(id)
            progressView.progress = Float(foundItems.count) / 4.0
        }
        
        if foundItems.count == 4 {
            showCompletionAlert()
        }
    }

    func showCompletionAlert() {
        let alert = UIAlertController(title: "퀘스트 완료!", message: "모든 금가락지를 찾았습니다!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

#Preview {
    QuestMapView(themeName: "잊혀진 유적", spotName: "미륵사지")
}
