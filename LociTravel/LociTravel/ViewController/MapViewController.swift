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
    
    private var isQuestCompleted = true // 임시 상태
    
    override func loadView() {
        view = customMapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtonActions()
    }
    
    private func setupButtonActions() {
        customMapView.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        customMapView.seodongParkButton.addTarget(self, action: #selector(didTapPinButton), for: .touchUpInside)
        customMapView.wanggungriButton.addTarget(self, action: #selector(didTapPin2Button), for: .touchUpInside)
        customMapView.jewelryButton.addTarget(self, action: #selector(didTapPin3Button), for: .touchUpInside)
        customMapView.mireuksaButton.addTarget(self, action: #selector(didTapPin4Button), for: .touchUpInside)
        customMapView.seodongMarketButton.addTarget(self, action: #selector(didTapPin5Button), for: .touchUpInside)
    }
    
    @objc private func didTapBackButton() {
        //navigationController?.popViewController(animated: true)
        //버튼을 누르면 시나리오 화면으로 넘어가는 함수
        
        print("back button")
    }
    
    @objc private func didTapPinButton() {
        print("seodong park button")
        let scenarioVC = ScenarioViewController(spotName: "서동공원")
        navigationController?.pushViewController(scenarioVC, animated: true)
    }
    
    @objc private func didTapPin2Button() {
        print("wanggungri button")
    }
    
    @objc private func didTapPin3Button() {
        print("jewelry button")
    }
    
    @objc private func didTapPin4Button() {
        print("mireuksa button")
    }
    
    @objc private func didTapPin5Button() {
        print("seodong market button")
    }
}

#Preview {
    MapViewController()
}
