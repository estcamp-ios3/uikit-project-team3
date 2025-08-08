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
    
    private var questProgress: [String] = []
       
       // ⛏ FIX: 신호용 플래그 추가
           private var resumeMode = false
       
       // ✅ 마지막 진행 상태를 전달받기 위한 선택적 저장소
       private var bootProgress: GameProgress?
       
       
       // ⛏ FIX: 이어하기용 생성자 추가
           convenience init(resumeMode: Bool) {
               self.init(nibName: nil, bundle: nil)
               self.resumeMode = resumeMode
           }

    
    // 퀘스트 순서를 정의합니다.
    private let questOrder: [String] = ["서동시장", "보석 박물관", "미륵사지", "서동공원", "왕궁리 유적"]
    
    private var isQuestCompleted = true // 임시 상태
    
    
    override func loadView() {
        view = customMapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtonActions()
        
        configureOptionMenu()
        
        // ✅ 진행 상태 바뀌면 버튼 상태 갱신
              NotificationCenter.default.addObserver(self,
                                                     selector: #selector(onProgressChanged),
                                                     name: .progressDidChange,
                                                     object: nil)
          }
          
          
          
          override func viewWillAppear(_ animated: Bool) {
              super.viewWillAppear(animated)
              
              navigationController?.setNavigationBarHidden(true, animated: false)
              
              
              // ✅ 디스크/싱글톤에서 최신 진행 불러와 버튼 상태 반영
              questProgress = UserModel.shared.getQuestProgress()
              updateButtonStates()
              
           
          }
          
          override func viewDidAppear(_ animated: Bool) {
              super.viewDidAppear(animated)
              
              //⛏ FIX: 부울 플래그로 분기
              if resumeMode {
                          resumeMode = false  // 재호출 방지
                          if let next = nextUnclearedQuest() {
                              pushScenario(for: next)
                          } else {
                              // 모두 완료 시 처리
                          }
                      }
                  }
              
          
          
          
          // 2) 다음 미완료 퀘스트 찾기 함수 추가
          // 🔧 추가
          private func nextUnclearedQuest() -> String? {
              let completed = Set(UserModel.shared.getQuestProgress())
              return questOrder.first { !completed.contains($0) }

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
        
        
        
        
        private func updateButtonStates() {
            let completedQuests = Set(UserModel.shared.getQuestProgress())
            
            for (index, questName) in questOrder.enumerated() {
                let button: UIButton
                
                switch questName {
                case "서동시장":
                    button = customMapView.seodongMarketButton
                case "보석 박물관":
                    button = customMapView.jewelryButton
                case "미륵사지":
                    button = customMapView.mireuksaButton
                case "서동공원":
                    button = customMapView.seodongParkButton
                case "왕궁리 유적":
                    button = customMapView.wanggungriButton
                default:
                    continue
                }
                
      
                            let isCompleted = completedQuests.contains(questName)
                            let prevDone = (index == 0) ? true : completedQuests.contains(questOrder[index - 1])
                            
                            // ✅ 규칙:
                            // - 완료된 퀘스트: 비활성
                            // - 미완료 + 직전 완료: 활성 (즉 "다음 퀘스트"만 활성)
                            // - 그 외: 비활성
                            let shouldEnable = (!isCompleted && prevDone)

                
            }
        }
    
    @objc private func onProgressChanged() {
              questProgress = UserModel.shared.getQuestProgress()
              updateButtonStates()
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
            let scenarioVC = ScenarioViewController(spotName: "보석 박물관")
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
            let scenarioVC = ScenarioViewController(spotName: "왕궁리 유적")
            navigationController?.pushViewController(scenarioVC, animated: true)
        }
        
        
    /// 스팟 이름 → 해당 시나리오 화면으로 이동(중복 코드 제거)
            private func pushScenario(for spot: String) {
                let scenarioVC = ScenarioViewController(spotName: spot)
                navigationController?.pushViewController(scenarioVC, animated: true)
            }
            
            deinit {
                NotificationCenter.default.removeObserver(self)
            }

        
        
        
    }
    



//#Preview {
//    MapViewController()
//}


#Preview {
    // 1. 임시로 모든 퀘스트를 완료 상태로 만듭니다.
    UserModel.shared.clearAll() // 기존 데이터 초기화 (선택 사항)
    UserModel.shared.addQuestProgress("서동시장")
    UserModel.shared.addQuestProgress("보석 박물관")
    UserModel.shared.addQuestProgress("미륵사지")
    UserModel.shared.addQuestProgress("서동공원")
    
    // 2. MapViewController를 생성합니다.
    let mapVC = MapViewController()
    
    // 3. 네비게이션 컨트롤러에 담아 반환합니다.
    return UINavigationController(rootViewController: mapVC)
}

