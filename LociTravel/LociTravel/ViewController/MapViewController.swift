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
    private var questProgress: [String] = [""]
    // 퀘스트 순서를 정의합니다.
       private let questOrder: [String] = ["seodongMarket", "jewelry", "mireuksa", "seodongPark", "wanggungri"]

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
            let journalIcon = UIImage(named: "questlisticon")
            let recordIcon  = UIImage(named: "recordbookicon")

            // 2️⃣ UIAction 생성 시 title과 image를 지정
            let journalAction = UIAction(title: "탐험일지", image: journalIcon) { [weak self] _ in
                self?.showJournal()
            }
            let recordAction = UIAction(title: "리코드북", image: recordIcon) { [weak self] _ in
                self?.showRecordBook()
            }

            // 3️⃣ 메뉴 생성 후 버튼에 연결
            let menu = UIMenu(title: "",
                              options: .displayInline,    // 메뉴 옵션: 인라인으로 표시
                              children: [journalAction, recordAction])
            customMapView.optionButton.menu = menu
            customMapView.optionButton.showsMenuAsPrimaryAction = true
        }
    
    // MARK: - Actions Setup
        private func setupActions() {
        }


        /// '지도' 선택 시 현재 화면 재로드 혹은 상세 지도로 이동
//        @objc private func showMap() {
//            let detailVC = MapViewController()  // 실제 지도 화면
//            navigationController?.pushViewController(detailVC,
//                                                     animated: true)
//        }

        /// '탐험일지' 선택 시 퀘스트 목록 화면으로 이동
        @objc private func showJournal() {
            let journalVC = QuestListViewController()
            self.navigationController?.pushViewController(journalVC,
                                                     animated: true)
        }

        /// '리코드북' 선택 시 스팟 상세 화면으로 이동
        @objc private func showRecordBook() {
            let recordVC = SpotDetailViewController()
            
            // ✅ [추가] SpotDetailViewController는 spotName이 없으면 바로 pop 됩니다.
                //    그래서 최소 한 개의 유효한 스팟 이름을 넘겨줘야 합니다.
                //    최근 진행한 스팟이 있으면 그걸, 없으면 기본값으로 "서동시장".
                let lastVisited = UserModel.shared.getQuestProgress().last
                recordVC.spotName = lastVisited ?? "서동시장"
            
            self.navigationController?.pushViewController(recordVC,
                                                     animated: true)
        }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false) // false로 수정함

        questProgress = UserModel.shared.getQuestProgress()
        // 퀘스트 진행 상황에 따라 버튼 상태를 업데이트합니다.
               updateButtonStates()
    }
    
  
    
    private func updateButtonStates() {
        let completedQuestions = Set(questProgress)
        
        for (index, quest) in questOrder.enumerated() {
            let button: UIButton
            let isEnabled: Bool
            
            switch quest {
            case "seodongMarket":
                button = customMapView.seodongMarketButton
                isEnabled = true
            case "jewelry":
                button = customMapView.jewelryButton
                isEnabled = completedQuestions.contains("seodongMarket")
            case "mireuksa":
                button = customMapView.mireuksaButton
                isEnabled = completedQuestions.contains("jewelry")
            case "seodongPark":
                button = customMapView.seodongParkButton
                isEnabled = completedQuestions.contains("mireuksa")
            case "wanggungri":
                button = customMapView.wanggungriButton
                isEnabled = completedQuestions.contains("seodongPark")
            default:
                continue
            }
            
            
            button.isEnabled = isEnabled
            button.alpha = isEnabled ? 1.0 : 0.3
            
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
            navigationController?.popToRootViewController(animated: true)        //버튼을 누르면 시나리오 화면으로 넘어가는 함수
        
        print("back button")
    }
    
    //    @objc private func didTapParkButton() {
    //        print("seodong park button")
    //    }
    
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



#Preview {
    MapViewController()
}
