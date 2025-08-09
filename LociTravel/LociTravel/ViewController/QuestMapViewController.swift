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
    var items: [Item]
    var itemPosition: CLLocationCoordinate2D
    var itemPositions: [CLLocationCoordinate2D] = []
    var foundItems: Set<Int> = []
    
    var isMusicOn = true
    var bgmPlayer: AVAudioPlayer?
    
    let questView = QuestMapView()
    let locationManager = CLLocationManager()
    
    private let proximityRadius: CLLocationDistance = 20 // 오차 범위
    private var mapRegionLogitude: Double = 300
    private var mapRegionLatitude: Double = 300
    private var itemAnnotations: [MKPointAnnotation] = []
    
    // MARK: - 디버그
    //디버그 용도
    let fakeMyPosition = MKPointAnnotation()
    private let step: CLLocationDegrees = 0.00003 // 로키 이동 거리
    private var isPresentingCompletion = false
    struct QuestLocation {
        let spotName: String
        let coordinate: CLLocationCoordinate2D
    }
#if DEBUG
    private lazy var debugCompleteButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("완료(디버그)", for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
        b.backgroundColor = UIColor.systemPink.withAlphaComponent(0.9)
        b.setTitleColor(.white, for: .normal)
        b.layer.cornerRadius = 10
        b.contentEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
        b.addTarget(self, action: #selector(debugCompleteQuest), for: .touchUpInside)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
#endif
    
    let questLocations: [QuestLocation] = [
        QuestLocation(spotName: "서동시장",
                      coordinate: CLLocationCoordinate2D(latitude: 35.953162, longitude: 126.957308)),
        QuestLocation(spotName: "보석 박물관",
                      coordinate: CLLocationCoordinate2D(latitude: 35.990587, longitude: 127.102335)),
        QuestLocation(spotName: "미륵사지",
                      coordinate: CLLocationCoordinate2D(latitude: 36.009675, longitude: 127.029928)),
        QuestLocation(spotName: "서동공원",
                      coordinate: CLLocationCoordinate2D(latitude: 36.001224, longitude: 127.058147)),
        QuestLocation(spotName: "왕궁리 유적",
                      coordinate: CLLocationCoordinate2D(latitude: 35.972822, longitude: 127.054597))
    ]
    
    
    lazy var itemRandomOffsets: [(lat: Double, lon: Double, id: Int)] = [
        (0.0003, 0.0003, 0),
        (-0.0004, 0.0005, 1),
        (0.0008, -0.0008, 2),
        (-0.0003, -0.0006, 3)
    ]
    
    init(spotName: String) {
        self.spotName = spotName
        self.quest = QuestModel.shared.getQuest(spotName: spotName)
        self.items = QuestModel.shared.getItems(questName: quest.questName)
        
        fakeMyPosition.coordinate = questLocations.first(where: { $0.spotName == spotName })?.coordinate
        ?? CLLocationCoordinate2D(latitude: 35.9535, longitude: 126.9573) // 안전 기본값
        
        if let first = items.first {
            self.itemPosition = CLLocationCoordinate2D(latitude: first.itemLatitude,
                                                       longitude: first.itemLongitude)
        } else {
            // 안전 기본값 (예: 서동시장 중심 좌표)
            self.itemPosition = CLLocationCoordinate2D(latitude: 35.9535, longitude: 126.9573)
            print("⚠️ items가 비었습니다. 기본 좌표로 대체합니다.")
        }
        
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
        setupMoveButtons()
        playBackgroundMusic()
        
#if DEBUG
        setupDebugCompleteButton()
#endif
    }
    
    // MARK: - 디버그용
#if DEBUG
    private func setupDebugCompleteButton() {
        // 맵 위 우하단에 띄우자 (다른 버튼과 안 겹치게)
        view.addSubview(debugCompleteButton)
        NSLayoutConstraint.activate([
            debugCompleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            debugCompleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
#endif
#if DEBUG
    @objc private func debugCompleteQuest() {
        // 아직 못 먹은 아이템 모두 확보 처리
        for i in 0..<itemPositions.count where !foundItems.contains(i) {
            foundItems.insert(i)
        }
        // 맵에서 아이템 어노테이션 제거
        if !itemAnnotations.isEmpty {
            questView.mapView.removeAnnotations(itemAnnotations)
            itemAnnotations.removeAll()
        }
        // 진행도 100%
        if itemPositions.count > 0 {
            questView.progressView.progress = 1.0
        }
        
        // 중복 알럿 방지 + 완료 알럿만 띄우기
        presentCompletionAlertSafely()
    }
#endif
    /* START */
    func setupMoveButtons() {
        let upButton = makeMoveButton(title: "⬆︎", action: #selector(moveUp))
        let downButton = makeMoveButton(title: "⬇︎", action: #selector(moveDown))
        let leftButton = makeMoveButton(title: "⬅︎", action: #selector(moveLeft))
        let rightButton = makeMoveButton(title: "➡︎", action: #selector(moveRight))
        
        // 첫 번째 줄: 위 버튼만 가운데 배치
        let topRow = UIStackView(arrangedSubviews: [UIView(), upButton, UIView()])
        topRow.axis = .horizontal
        topRow.distribution = .equalSpacing
        
        // 두 번째 줄: 좌 - 빈공간 - 우
        let middleRow = UIStackView(arrangedSubviews: [leftButton, UIView(), rightButton])
        middleRow.axis = .horizontal
        middleRow.alignment = .center
        middleRow.spacing = 30
        
        // 세 번째 줄: 아래 버튼만 가운데 배치
        let bottomRow = UIStackView(arrangedSubviews: [UIView(), downButton, UIView()])
        bottomRow.axis = .horizontal
        bottomRow.distribution = .equalSpacing
        
        // 전체 세로 스택
        let verticalStack = UIStackView(arrangedSubviews: [topRow, middleRow, bottomRow])
        verticalStack.axis = .vertical
        verticalStack.alignment = .center
        verticalStack.spacing = 10
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        
        questView.addSubview(verticalStack)
        NSLayoutConstraint.activate([
            verticalStack.leadingAnchor.constraint(equalTo: questView.leadingAnchor, constant: 15),
            verticalStack.bottomAnchor.constraint(equalTo: questView.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    func makeMoveButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 50),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
        return button
    }
    
    @objc func moveUp() {
        fakeMyPosition.coordinate.latitude += step
        questView.mapView.setCenter(fakeMyPosition.coordinate, animated: true)
        checkNearbyItems()
    }
    
    @objc func moveDown() {
        fakeMyPosition.coordinate.latitude -= step
        questView.mapView.setCenter(fakeMyPosition.coordinate, animated: true)
        checkNearbyItems()
    }
    
    @objc func moveLeft() {
        fakeMyPosition.coordinate.longitude -= step
        questView.mapView.setCenter(fakeMyPosition.coordinate, animated: true)
        checkNearbyItems()
    }
    
    @objc func moveRight() {
        fakeMyPosition.coordinate.longitude += step
        questView.mapView.setCenter(fakeMyPosition.coordinate, animated: true)
        checkNearbyItems()
    }
    
    //MARK: -
    /* END */
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
        
        //디버깅 용도
        let center = fakeMyPosition.coordinate
        
        let region = MKCoordinateRegion(center: center, latitudinalMeters: mapRegionLatitude, longitudinalMeters: mapRegionLogitude)
        questView.mapView.setRegion(region, animated: false)
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        fakeMyPosition.title = "나"
        questView.mapView.addAnnotation(fakeMyPosition)
    }
    
    func setupItems() {
        itemPositions.removeAll()
        itemAnnotations.removeAll()
        
        questView.mapView.removeAnnotations(questView.mapView.annotations.filter { $0 !== questView.mapView.userLocation && $0.title != "나" })
        
        if let first = items.first, first.isRandom {
            itemPositions = itemRandomOffsets.map { offsetCoord(lat: $0.lat, lon: $0.lon) }
        } else {
            itemPositions = items.map { CLLocationCoordinate2D(latitude: $0.itemLatitude,
                                                               longitude: $0.itemLongitude) }
        }
        for (i, pos) in itemPositions.enumerated() {
            let anno = MKPointAnnotation()
            anno.coordinate = pos
            let name = (i < items.count ? items[i].itemName : items.first?.itemName ?? "아이템")
            anno.title = "보물 \(name) \(i)"
            questView.mapView.addAnnotation(anno)
            itemAnnotations.append(anno)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            let id = "me"
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: id) as? MKMarkerAnnotationView
            if view == nil {
                view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: id)
                view?.canShowCallout = false
                view?.displayPriority = .required
            }
            view?.annotation = annotation
            view?.image = UIImage(named: "mouse")              // ← 에셋 이름
            view?.centerOffset = CGPoint(x: 0, y: -16)         // 핀 끝이 좌표를 가리키도록 살짝 올림
            return view
        }
        
        // 2) "나" (마우스 이미지)
        if annotation.title ?? nil == "나" {
            let id = "meImage"
            let view = (mapView.dequeueReusableAnnotationView(withIdentifier: id) as? MKAnnotationView)
            ?? MKAnnotationView(annotation: annotation, reuseIdentifier: id)
            view.annotation = annotation
            view.canShowCallout = false
            
            if let img = UIImage(named: "mouse") {
                let size = CGSize(width: 60, height: 60)
                UIGraphicsBeginImageContextWithOptions(size, false, 0)
                img.draw(in: CGRect(origin: .zero, size: size))
                let resized = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                view.image = resized
                view.centerOffset = CGPoint(x: 0, y: -size.height/2) // 끝점이 좌표
            } else {
                print("⚠️ mouse 이미지 에셋을 찾지 못했습니다.")
            }
            return view
        }
        
        // 3) 아이템(고구마 등)
        if let title = annotation.title ?? nil, title.starts(with: "보물") {
            let id = "itemImage"
            let view = (mapView.dequeueReusableAnnotationView(withIdentifier: id) as? MKAnnotationView)
            ?? MKAnnotationView(annotation: annotation, reuseIdentifier: id)
            view.annotation = annotation
            view.canShowCallout = false
            
            // 원하는 아이템 이미지 (여기선 첫 아이템 기준)
            let imageName = items.first?.itemImage ?? "sweetpotato"
            if let img = UIImage(named: imageName) {
                let size = CGSize(width: 60, height: 60)
                UIGraphicsBeginImageContextWithOptions(size, false, 0)
                img.draw(in: CGRect(origin: .zero, size: size))
                let resized = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                view.image = resized
                view.centerOffset = CGPoint(x: 0, y: -size.height/2)
            } else {
                print("⚠️ \(imageName) 이미지 에셋을 찾지 못했습니다.")
            }
            return view
        }
        
        return nil
    }
    
    private func pickup(index i: Int) {
        guard !foundItems.contains(i) else { return }
        foundItems.insert(i)
        
        // 지도에서 해당 어노테이션 제거
        if i < itemAnnotations.count {
            let ann = itemAnnotations[i]
            questView.mapView.removeAnnotation(ann)
        }
        
        // 진행도 갱신
        questView.progressView.progress = Float(foundItems.count) / Float(itemPositions.count)
        
        // 알림 (중복 표시 방지)
        let isAllCollected = (foundItems.count == itemPositions.count)
        
        if isAllCollected {
            // 마지막 아이템이면 획득 알림은 띄우지 말고, 완료 알림만!
            presentCompletionAlertSafely()
        } else {
            // 획득 알림은 기존처럼 단독일 때만 표시
            if presentedViewController == nil {
                showItemPickupAlert(itemIndex: i)
            }
        }
    }
    
    private func presentCompletionAlertSafely() {
        guard !isPresentingCompletion else { return }
        isPresentingCompletion = true
        
        // 이미 다른 알림이 떠있다면 먼저 내리고 완료 알림 표시
        if let presented = presentedViewController {
            presented.dismiss(animated: true) { [weak self] in
                self?.showCompletionAlert()
                self?.isPresentingCompletion = false
            }
        } else {
            showCompletionAlert()
            isPresentingCompletion = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let current = locations.last else { return }
        // (디바이스 모드가 아니라면 덮어쓰지 않도록 분기하는 걸 권장)
        // fakeMyPosition.coordinate = current.coordinate
        
        for (i, itemCoord) in itemPositions.enumerated() where !foundItems.contains(i) {
            let distance = current.distance(from: CLLocation(latitude: itemCoord.latitude, longitude: itemCoord.longitude))
            if distance <= proximityRadius { pickup(index: i) }
        }
    }
    
    func checkNearbyItems() {
        let current = CLLocation(latitude: fakeMyPosition.coordinate.latitude, longitude: fakeMyPosition.coordinate.longitude)
        for (i, itemCoord) in itemPositions.enumerated() where !foundItems.contains(i) {
            let distance = current.distance(from: CLLocation(latitude: itemCoord.latitude, longitude: itemCoord.longitude))
            if distance <= proximityRadius { pickup(index: i) }
        }
    }
    
    func showItemPickupAlert(itemIndex: Int) {
        let alert = UIAlertController(
            title: "아이템 획득!",
            message: "\(items[0].itemName) \(itemIndex + 1)을(를) 완료!",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    func showCompletionAlert() {
        let alert = UIAlertController(title: "퀘스트 완료!", message: "", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            // 퀘스트 완료 상태를 UserModel에 저장합니다.
            UserModel.shared.addQuestProgress(self.spotName)
            //퀘스트 완료 상태를 퀘스트모델에도 저장 -> 나중에 시간될때 바꾸기
            let dummy = QuestModel.shared.updateQuest(spotName: spotName)
            // 마지막 퀘스트인 "왕궁리유적"인지 확인합니다.
            let isLastQuest = (self.spotName == "왕궁리 유적") // ← 문자열 일치로 수정
            
            // 알럿이 닫힌 직후 안전하게 내비게이션
            DispatchQueue.main.async {
                if isLastQuest {
                    let epilogueVC = EpilogueViewController()
                    if let nav = self.navigationController {
                        nav.pushViewController(epilogueVC, animated: true)
                    } else {
                        self.present(epilogueVC, animated: true) // 혹시 네비가 없으면 모달
                    }
                    return
                }
                
                // 마지막 퀘스트가 아니면 맵으로 복귀
                if let nav = self.navigationController {
                    if let mapVC = nav.viewControllers.first(where: { $0 is MapViewController }) {
                        nav.popToViewController(mapVC, animated: true)
                    } else {
                        nav.popToRootViewController(animated: true) // 폴백
                    }
                } else {
                    // 네비게이션이 없으면 모달로 열렸던 것 → 닫기
                    self.dismiss(animated: true)
                }
            }
        }
        alert.addAction(confirmAction)
        present(alert, animated: true)
    }
}

#Preview {
    QuestMapViewController(spotName: "왕궁리 유적")
}
