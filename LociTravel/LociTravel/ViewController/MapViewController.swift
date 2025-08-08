//
//  MapViewController.swift
//  LociTravel
//
//  Created by suji chae on 8/5/25.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    private let customMapView = MapView()
    // 완료된 퀘스트를 저장할 Set 변수 추가
    private var completedQuests: Set<String> = []
    
    private var questProgress: [String] = [""]
    // 퀘스트 순서를 정의합니다.
    private let questOrder: [String] = ["서동시장", "보석박물관", "미륵사지", "서동공원", "왕궁리유적"]
    
    private var isQuestCompleted = true // 임시 상태
    
    
    override func loadView() {
        view = customMapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtonActions()
        
        configureOptionMenu()
    }
    
    // MARK: - UIMenu 설정 (새로 추가)
    private func configureOptionMenu() {
        
        // 1️⃣ 에셋 이름을 실제 이미지 이름으로 수정하세요 추후 에셋에 이미지업로드한 이름 사용
        // let mapIcon     = UIImage(named: "jewelry") //에셋 주얼리
        let journalIcon = UIImage(named: "mireuksa")
        let recordIcon  = UIImage(named: "pin")
        
        // 2️⃣ UIAction 생성 시 title과 image를 지정
        //            let mapAction = UIAction(title: "지도", image: mapIcon) { [weak self] _ in
        //                self?.showMap()
        //            }
        let journalAction = UIAction(title: "탐험일지", image: journalIcon) { [weak self] _ in
            self?.showJournal()
        }
        let recordAction = UIAction(title: "리코드북", image: recordIcon) { [weak self] _ in
            self?.showRecordBook()
        }
        
        // 3️⃣ 메뉴 생성 후 버튼에 연결
        let menu = UIMenu(title: "",
                          options: .displayInline,    // 메뉴 옵션: 인라인으로 표시
                          children: [//mapAction,
                            journalAction, recordAction])
        customMapView.optionButton.menu = menu
        customMapView.optionButton.showsMenuAsPrimaryAction = true
    }
    
    // MARK: - Actions Setup
    private func setupActions() {
    }
    
    
    /// '지도' 선택 시 현재 화면 재로드 혹은 상세 지도로 이동
    @objc private func showMap() {
        let detailVC = MapViewController()  // 실제 지도 화면
        navigationController?.pushViewController(detailVC,
                                                 animated: true)
    }
    
    /// '탐험일지' 선택 시 퀘스트 목록 화면으로 이동
    @objc private func showJournal() {
        let journalVC = QuestListViewController()
        navigationController?.pushViewController(journalVC,
                                                 animated: true)
    }
    
    /// '리코드북' 선택 시 스팟 상세 화면으로 이동
    @objc private func showRecordBook() {
        let recordVC = SpotDetailViewController()
        navigationController?.pushViewController(recordVC,
                                                 animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        questProgress = UserModel.shared.getQuestProgress()
        // 퀘스트 진행 상황에 따라 버튼 상태를 업데이트합니다.
        updateButtonStates()
    }
    
    
    
    
    private func updateButtonStates() {
        let completedQuests = Set(UserModel.shared.getQuestProgress())
        let questOrder: [String] = ["서동시장", "보석박물관", "미륵사지", "서동공원", "왕궁리유적"]
        
        for (index, questName) in questOrder.enumerated() {
            let button: UIButton
            
            switch questName {
            case "서동시장":
                button = customMapView.seodongMarketButton
            case "보석박물관":
                button = customMapView.jewelryButton
            case "미륵사지":
                button = customMapView.mireuksaButton
            case "서동공원":
                button = customMapView.seodongParkButton
            case "왕궁리유적":
                button = customMapView.wanggungriButton
            default:
                continue
            }
            
            // 퀘스트 완료 여부를 확인
            let isQuestCompleted = completedQuests.contains(questName)
            
            // 이전 퀘스트가 완료되었는지 확인
            // 첫 번째 퀘스트는 이전 퀘스트가 없으므로 항상 true로 간주합니다.
            let isPreviousQuestCompleted = (index == 0) || completedQuests.contains(questOrder[index - 1])
            let shouldEnable = isQuestCompleted || (isPreviousQuestCompleted && !isQuestCompleted)
            
            button.isEnabled = shouldEnable
            button.alpha = shouldEnable ? 1.0 : 0.3
        }
    }
    
    
    
    
    private func setupButtonActions() {
        customMapView.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        customMapView.seodongParkButton.addTarget(self, action: #selector(didTapParkButton), for: .touchUpInside)
        customMapView.wanggungriButton.addTarget(self, action: #selector(didTapWanggungriButton), for: .touchUpInside)
        customMapView.jewelryButton.addTarget(self, action: #selector(didTapJewelryButton), for: .touchUpInside)
        customMapView.mireuksaButton.addTarget(self, action: #selector(didTapMireuksaButton), for: .touchUpInside)
        customMapView.seodongMarketButton.addTarget(self, action: #selector(didTapMarketButton), for: .touchUpInside)
    }
    
    private func optionButtonActions() {
        customMapView.optionButton.addTarget(self, action: #selector(didTapOptionButton), for: .touchUpInside)
    }
    
    @objc private func didTapOptionButton() {
    }
    
    @objc private func didTapBackButton() {
        navigationController?.popToRootViewController(animated: true)
        print("back button")
    }
    
    
    @objc private func didTapMarketButton() {
        print("seodong market button")
        let scenarioVC = ScenarioViewController(spotName: "서동시장")
        navigationController?.pushViewController(scenarioVC, animated: true)
    }
    
    @objc private func didTapJewelryButton() {
        print("jewelry button")
        let scenarioVC = ScenarioViewController(spotName: "보석박물관")
        navigationController?.pushViewController(scenarioVC, animated: true)
    }
    
    @objc private func didTapMireuksaButton() {
        print("mireuksa button")
        let scenarioVC = ScenarioViewController(spotName: "미륵사지")
        navigationController?.pushViewController(scenarioVC, animated: true)
    }
    
    @objc private func didTapParkButton() {
        print("seodong park button")
        let scenarioVC = ScenarioViewController(spotName: "서동공원")
        navigationController?.pushViewController(scenarioVC, animated: true)
    }
    
    @objc private func didTapWanggungriButton() {
        print("wanggungri button")
        let scenarioVC = ScenarioViewController(spotName: "왕궁리유적")
        navigationController?.pushViewController(scenarioVC, animated: true)
    }
    
    
    
    
    
    
}



//#Preview {
//    MapViewController()
//}


#Preview {
    // 1. 임시로 모든 퀘스트를 완료 상태로 만듭니다.
    UserModel.shared.clearAll() // 기존 데이터 초기화 (선택 사항)
    UserModel.shared.addQuestProgress("서동시장")
    UserModel.shared.addQuestProgress("보석박물관")
    UserModel.shared.addQuestProgress("미륵사지")
    UserModel.shared.addQuestProgress("서동공원")
    
    // 2. MapViewController를 생성합니다.
    let mapVC = MapViewController()
    
    // 3. 네비게이션 컨트롤러에 담아 반환합니다.
    return UINavigationController(rootViewController: mapVC)
}

