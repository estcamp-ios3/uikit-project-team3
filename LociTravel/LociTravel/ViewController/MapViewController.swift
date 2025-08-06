//
//  MapViewController.swift
//  LociTravel
//
//  Created by suji chae on 8/5/25.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    private let mapView = MapView()
    
    private var isQuestCompleted = true // 임시 상태
    
    override func loadView() {
        view = mapView
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
            mapView.optionButton.menu = menu
            mapView.optionButton.showsMenuAsPrimaryAction = true
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
    
    
    
    private func setupButtonActions() {
        mapView.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        mapView.seodongParkButton.addTarget(self, action: #selector(didTapPinButton), for: .touchUpInside)
        mapView.wanggungriButton.addTarget(self, action: #selector(didTapPin2Button), for: .touchUpInside)
        mapView.jewelryButton.addTarget(self, action: #selector(didTapPin3Button), for: .touchUpInside)
        mapView.mireuksaButton.addTarget(self, action: #selector(didTapPin4Button), for: .touchUpInside)
        mapView.seodongMarketButton.addTarget(self, action: #selector(didTapPin5Button), for: .touchUpInside)
    }
    
    private func optionButtonActions() {
        mapView.optionButton.addTarget(self, action: #selector(didTapOptionButton), for: .touchUpInside)
    }
    
    
    
    
    @objc private func didTapBackButton() {
        navigationController?.popToRootViewController(animated: true)  //뒤로가기 버튼을 누르면 홈뷰 화면으로 넘어가는 함수
    }
    
    @objc private func didTapOptionButton() {
    }
        
        
        
        @objc private func didTapPinButton() {
            print("seodong park button")
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
