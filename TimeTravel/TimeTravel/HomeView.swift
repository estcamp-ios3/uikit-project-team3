//
//  Untitled.swift
//  TimeTravel
//
//  Created by chohoseo on 7/30/25.
//

import UIKit

class HomeView: UIViewController {

    private var selectedRegion: String = "익산"  // 기본 지역
    private let missionStack = UIStackView()
    private let selectedRegionButton = UIButton() // ⭐️ 지역 선택용 버튼

    // ⭐️ 1) 미니맵 버튼을 프로퍼티로 선언해서 다른 메서드에서도 접근 가능하게 합니다.
       private let miniMapButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemTeal

        setupMascotImage()
        setupMiniMap()
        setupRegionDropdownButton()  // ⭐️ 지역 선택 버튼 추가
        setupMissionButtons(for: selectedRegion)
        updateMiniMap(for: selectedRegion) // ⭐️ 기본 지역(익산)에 맞춰 미니맵도 갱신
    }

    // 마스코트 이미지
    private func setupMascotImage() {
        let mascotImage = UIImageView(image: UIImage(named: "testMascot"))
        mascotImage.contentMode = .scaleAspectFit
        mascotImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mascotImage)

        NSLayoutConstraint.activate([
            mascotImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            mascotImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mascotImage.heightAnchor.constraint(equalToConstant: 100)
        ])
    }

    // 오른쪽 상단 미니맵
    private func setupMiniMap() {
        // 미니맵 버튼에 기본 이미지 설정
                miniMapButton.setImage(UIImage(named: "map_익산"), for: .normal)
                miniMapButton.translatesAutoresizingMaskIntoConstraints = false
                miniMapButton.addTarget(self, action: #selector(showFullMap), for: .touchUpInside)
                view.addSubview(miniMapButton)

                NSLayoutConstraint.activate([
                    miniMapButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
                    miniMapButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
                    miniMapButton.widthAnchor.constraint(equalToConstant: 60),
                    miniMapButton.heightAnchor.constraint(equalToConstant: 60)
                ])
    }

    @objc private func showFullMap() {
        // ① FullMapViewController 인스턴스로 바꿔서 생성
            let fullMapVC = FullMapViewController()
            
            // ② 전체 화면 모달로 띄우기 (default는 sheet 스타일이라 화면 일부만 올라올 수 있음)
            fullMapVC.modalPresentationStyle = .fullScreen
            
            // ③ 실제 프레젠트
            present(fullMapVC, animated: true, completion: nil)
    }

    // ⭐️ 지역 선택 버튼 (클릭 시 리스트 표시)
    private func setupRegionDropdownButton() {
        selectedRegionButton.setTitle("📍 지역: \(selectedRegion)", for: .normal)
        selectedRegionButton.setTitleColor(.white, for: .normal)
        selectedRegionButton.backgroundColor = .orange
        selectedRegionButton.layer.cornerRadius = 10
        selectedRegionButton.translatesAutoresizingMaskIntoConstraints = false
        selectedRegionButton.addTarget(self, action: #selector(showRegionList), for: .touchUpInside)

        view.addSubview(selectedRegionButton)

        NSLayoutConstraint.activate([
            selectedRegionButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 140),
            selectedRegionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selectedRegionButton.heightAnchor.constraint(equalToConstant: 45),
            selectedRegionButton.widthAnchor.constraint(equalToConstant: 200)
        ])
    }

    // ⭐️ 버튼 누르면 UIAlertController로 지역 선택
    @objc private func showRegionList() {
        let alert = UIAlertController(title: "지역 선택", message: nil, preferredStyle: .actionSheet)

        let regions = ["익산", "경주", "수원", "공주", "부여", "서울", "고양","김천","안산","대전", "용인", "화성"]

        for region in regions {
            alert.addAction(UIAlertAction(title: region, style: .default, handler: { _ in
                self.selectedRegion = region
                self.selectedRegionButton.setTitle("📍 지역: \(region)", for: .normal)
                self.setupMissionButtons(for: region)
            }))
        }

        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))

        // iPad 대응
        if let popover = alert.popoverPresentationController {
            popover.sourceView = selectedRegionButton
            popover.sourceRect = selectedRegionButton.bounds
        }

        present(alert, animated: true)
    }

    // 미션 버튼 생성
    private func setupMissionButtons(for region: String) {
        missionStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        missionStack.axis = .vertical
        missionStack.spacing = 20
        missionStack.translatesAutoresizingMaskIntoConstraints = false

        let titles = missions(for: region)

        for title in titles {
            let button = UIButton(type: .system)
            button.setTitle("〈가제〉 \(title)", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .orange
            button.layer.cornerRadius = 12
            button.heightAnchor.constraint(equalToConstant: 50).isActive = true
            button.addTarget(self, action: #selector(missionTapped(_:)), for: .touchUpInside)
            missionStack.addArrangedSubview(button)
        }

        if missionStack.superview == nil {
            view.addSubview(missionStack)
            NSLayoutConstraint.activate([
                missionStack.topAnchor.constraint(equalTo: selectedRegionButton.bottomAnchor, constant: 30),
                missionStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
                missionStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
            ])
        }
    }

    // 미션 선택 시 MapView로 이동
    @objc private func missionTapped(_ sender: UIButton) {
        let mapVC = MapView()
        mapVC.title = sender.currentTitle
        navigationController?.pushViewController(mapVC, animated: true)
    }

    // 지역별 미션 목록 반환
    private func missions(for region: String) -> [String] {
        switch region {
        case "경주":
            return ["신라 유적 1", "신라 유적 2", "신라 유적 3"]
        case "수원":
            return ["수원화성탐방 1", "수원화성탐방 2", "수원화성 3"]
        case "공주":
            return ["무령왕릉의 비밀", "공산성 이야기", "백제의 흔적"]
        case "부여":
            return ["정림사지 유물", "부소산성 탐방", "백제 금동대향로"]
        case "서울":
            return ["서울1", "서울2","서울3"]
        case "고양":
            return ["고양1", "고양2", "고양3"]
        case "김천":
            return ["김천1", "김천2", "김천3"]
        case "안산":
            return ["안산1", "안산2", "안산3"]
        case "화성":
            return ["화성1", "화성2", "화성3"]
        case "용인":
            return ["용인1", "용인2", "용인3"]
        case "대전":
            return ["대전1", "대전2","대전3"]

        default:
            return ["숨겨진 왕의 흔적", "잊혀진 시간 조각", "석탑의 수수께끼"]
        }
    }
    
    // ⭐️ 3) 선택된 지역에 맞춰 미니맵 이미지를 변경하는 메서드
    private func updateMiniMap(for region: String) {
        // ⭐️ region에 따라 사용할 이미지 이름 결정
        let imageName: String
        switch region {
        case "수원":
            imageName = "testMiniMapSuWon"       // Assets.xcassets에 등록한 이름
        case "경주":
            imageName = "testMiniMapGyeongju"    // Assets.xcassets에 등록한 이름
        default:
            imageName = "testMiniMap"            // 나머지 지역에 사용할 기본 이미지
        }
        
        // ⭐️ 이미지가 nil이면 system map 아이콘으로 대체
        let image = UIImage(named: imageName) ?? UIImage(systemName: "map")
        miniMapButton.setImage(image, for: .normal)
    }
    
    
    
}

#Preview {
    HomeView()
}
