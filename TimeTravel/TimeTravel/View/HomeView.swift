//
//  Untitled.swift
//  TimeTravel
//
//  Created by chohoseo on 7/30/25.
//

import UIKit
import MapKit
import CoreLocation // 🔧 1) 위치 정보를 사용하기 위해 CoreLocation 추가

class HomeViewController: UIViewController, CLLocationManagerDelegate {
    // MARK: – 모델 & 상태
    private let regions = Array(Set(LocalModel.shared.themeData.map { $0.local })).sorted()
    private var selectedRegionIndex = 0 { didSet { updateRegionUI() } }
    private var selectedThemeIndex  = 0 { didSet { updateThemeUI() } }
    private var themesForRegion: [Theme] {
        LocalModel.shared.themeData.filter { $0.local == regions[selectedRegionIndex] }
    }
    
    // 🔧 2) 위치 매니저 프로퍼티 추가
    private let locationManager = CLLocationManager()
    
    // MARK: – UI 컴포넌트 선언
    private let mascotImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "mascotLoci")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    private let regionButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = .systemOrange
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 8
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(nil, action: #selector(didTapRegion), for: .touchUpInside)
        return btn
    }()
    private let miniMapView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    private let themeStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.spacing = 8
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    private let goToThemeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("선택된 테마로 이동", for: .normal)
        btn.backgroundColor = .systemOrange
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 8
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(nil, action: #selector(didTapGoToTheme), for: .touchUpInside)
        return btn
    }()
    private var themeButtons: [UIButton] = []
    
    // MARK: – 라이프사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        // 🔧 4) 위치 권한 요청 설정
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation() // 단발성 위치 요청
        
        // 🔧 [여기를 수정] 기본 지역을 "익산"으로 설정
        if let defaultIndex = regions.firstIndex(of: "익산") {
            selectedRegionIndex = defaultIndex
        }
        
        setupLayout()
        updateRegionUI()
        
        // ───── ★ ① 초기 버튼 상태 설정 ─────
        // viewDidLoad 직후에 넣어주세요.
        goToThemeButton.isEnabled = true
        goToThemeButton.backgroundColor = .systemOrange
        goToThemeButton.setTitleColor(.white, for: .normal)
        // ───────────────────────────────────
        
        
        // ① 미니맵 이미지를 탭 가능하도록 설정
        miniMapView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapMapImage))
        miniMapView.addGestureRecognizer(tap)
    }
    
    // ② 탭 핸들러: 전체 화면으로 이미지 보여 주기
    @objc private func didTapMapImage() {
        guard let image = miniMapView.image else { return }
        let previewVC = ImagePreviewViewController(image: image)
        previewVC.modalPresentationStyle = .fullScreen    // 전체 화면 모달
        present(previewVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // HomeView가 화면에 나올 때 탭 바 숨기기
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // HomeView가 사라질 때 (다른 화면으로 갈 때) 탭 바 다시 보이기
        tabBarController?.tabBar.isHidden = false
    }
    
    
    // MARK: – 레이아웃 구성
    private func setupLayout() {
        [mascotImageView, regionButton, miniMapView, themeStackView, goToThemeButton].forEach {
            view.addSubview($0)
        }
        NSLayoutConstraint.activate([
            mascotImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            mascotImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mascotImageView.widthAnchor.constraint(equalToConstant: 100),
            mascotImageView.heightAnchor.constraint(equalToConstant: 100),
            
            regionButton.topAnchor.constraint(equalTo: mascotImageView.bottomAnchor, constant: 16),
            regionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            regionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            regionButton.heightAnchor.constraint(equalToConstant: 44),
            
            miniMapView.topAnchor.constraint(equalTo: regionButton.bottomAnchor, constant: 20),
            miniMapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            miniMapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            miniMapView.heightAnchor.constraint(equalTo: miniMapView.widthAnchor, multiplier: 0.99),
            
            themeStackView.topAnchor.constraint(equalTo: miniMapView.bottomAnchor, constant: 12),
            themeStackView.leadingAnchor.constraint(equalTo: miniMapView.leadingAnchor),
            themeStackView.trailingAnchor.constraint(equalTo: miniMapView.trailingAnchor),
            themeStackView.heightAnchor.constraint(equalToConstant: 44),
            
            goToThemeButton.topAnchor.constraint(equalTo: themeStackView.bottomAnchor, constant: 16),
            goToThemeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            goToThemeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            goToThemeButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    // MARK: – UI 업데이트
    private func updateRegionUI() {
        guard regions.indices.contains(selectedRegionIndex) else { return }
        let local = regions[selectedRegionIndex]
        regionButton.setTitle("📍 지역: \(local)", for: .normal)
        setupThemeButtons()
        selectedThemeIndex = 0
        
        // ───── ★ ② 지역 변경 시에도 버튼 활성·색상 초기화 ─────
        goToThemeButton.isEnabled = true
        goToThemeButton.backgroundColor = .systemOrange
        goToThemeButton.setTitleColor(.white, for: .normal)
        // ───────────────────────────────────────────────────────
        
    }
    private func setupThemeButtons() {
        themeStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        themeButtons.removeAll()
        for (i, theme) in themesForRegion.enumerated() {
            let btn = UIButton(type: .system)
            btn.setTitle(theme.theme, for: .normal)
            btn.backgroundColor = theme.color
            btn.setTitleColor(.white, for: .normal)
            btn.layer.cornerRadius = 6
            btn.tag = i
            btn.addTarget(self, action: #selector(handleThemeTap(_:)), for: .touchUpInside)
            btn.translatesAutoresizingMaskIntoConstraints = false
            themeStackView.addArrangedSubview(btn)
            themeButtons.append(btn)
        }
    }
    private func updateThemeUI() {
        // 선택된 테마 가져오기
        let theme = themesForRegion[selectedThemeIndex]
        
        // MKMapView 관련 코드는 모두 제거하고…
        // miniMapImageView에 미리 지정해 둔 코스 이미지 세팅
        miniMapView.image = UIImage(named: theme.imgCourse)
        
        // (나머지 버튼 테두리 표시 로직은 그대로)
        for (i, btn) in themeButtons.enumerated() {
            btn.layer.borderWidth = (i == selectedThemeIndex ? 2 : 0)
            btn.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    // MARK: – 액션 핸들러
    @objc private func didTapRegion() {
        let regionVC = RegionSelectionViewController(regions: regions)
        
        // 🔧 5) 일반 지역 선택 콜백 설정
        regionVC.didSelectRegion = { [weak self] idx in
            self?.selectedRegionIndex = idx
            self?.dismiss(animated: true)
        }
        // 🔧 6) 내 근처 선택 콜백 설정
        regionVC.didSelectRegionForNearby = { [weak self] in
            guard let self = self else { return }
            // 위치를 한 번 가져오고 가장 가까운 테마로 인덱스 변경
            self.locationManager.requestLocation()
        }
        
        let nav = UINavigationController(rootViewController: regionVC)
        nav.modalPresentationStyle = .pageSheet
        present(nav, animated: true)
    }
    @objc private func handleThemeTap(_ sender: UIButton) {
        selectedThemeIndex = sender.tag
        // ───── ★ ③ “전체 노선도” 일 때 버튼 비활성화/색 변경 ─────
        // sender.tag == 0 으로 “전체 노선도” 버튼을 구분하셨다면,
        // 이렇게 넣어주세요.
        if sender.tag == 0 {
            goToThemeButton.isEnabled = false
            goToThemeButton.backgroundColor = .white
            // 비활성화 상태 텍스트 색도 연하게 변경
            goToThemeButton.setTitleColor(.lightGray, for: .disabled)
        } else {
            // 나머지 테마 선택 시 복원
            goToThemeButton.isEnabled = true
            goToThemeButton.backgroundColor = .systemOrange
            goToThemeButton.setTitleColor(.white, for: .normal)
        }
        // ───────────────────────────────────────────────────────────
        
        
    }
    
    @objc private func didTapGoToTheme() {
        let theme = themesForRegion[selectedThemeIndex]
        //MapView.sharedTheme = theme
        
        //      navigationController?.pushViewController(vc, animated: true)
        
        self.tabBarController?.selectedIndex = 1
    }
    
    
    // 🔧 7) CLLocationManagerDelegate 메서드 구현
    @objc func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLoc = locations.first else { return }
        // 모든 테마의 모든 코스를 플랫하게 모은 뒤 거리 계산
        var nearestThemeIndex: Int = 0
        var minDist = CLLocationDistanceMax
        for theme in LocalModel.shared.themeData {
            for course in theme.arrCourse {
                // CLLocationCoordinate2D를 CLLocation으로 변환 후 거리 계산
                let courseLoc = CLLocation(latitude: course.coordinate.latitude,
                                           longitude: course.coordinate.longitude)
                let dist = courseLoc.distance(from: userLoc)
                if dist < minDist {
                    minDist = dist
                    if let idx = regions.firstIndex(of: theme.local) {
                        nearestThemeIndex = idx
                    }
                }
            }
        }
        // 가장 가까운 지역으로 선택
        selectedRegionIndex = nearestThemeIndex
        manager.stopUpdatingLocation()
        dismiss(animated: true)
    }
    @objc func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("위치 정보를 가져올 수 없습니다: \(error.localizedDescription)")
    }
}
