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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)

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
    
    
    
    @objc private func didTapBackButton() {
        //        navigationController?.popViewController(animated: true)        //버튼을 누르면 시나리오 화면으로 넘어가는 함수
        
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
