//
//  HomeViewController.swift
//  LociTravel
//
//  Created by suji chae on 8/5/25.
//

import UIKit

class HomeViewController: PortraitOnlyViewController {
    private let rootView = HomeView() // 이미 쓰는 HomeView
    
    override func loadView() { view = rootView }

    override func viewDidLoad() {
        super.viewDidLoad()
        
       // rootView.loadButton.addTarget(self, action: #selector(didTapLoad), for: .touchUpInside)

        // 진행도 변경 실시간 반영
        NotificationCenter.default.addObserver(self,
            selector: #selector(updateLoadButtonState),
            name: .progressDidChange, object: nil)
        
        setupButtonActions()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateLoadButtonState() // 화면 복귀 시 반영
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func setupButtonActions() {
        rootView.startButton.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
        
        //0806 questlistbutton -> loadbutton으로 수정
        rootView.loadButton.addTarget(self, action: #selector(didTapLoad), for: .touchUpInside)
    }
    
    //시작하기 버튼 함수
    @objc private func didTapStartButton() {
       //0809 추가
        if UserModel.shared.hasResumeData {
                let alert = UIAlertController(
                    title: "새로 시작할까요?",
                    message: "기존 진행이 초기화됩니다.",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "취소", style: .cancel))
                alert.addAction(UIAlertAction(title: "시작하기", style: .destructive, handler: { _ in
                    UserModel.shared.clearAll()   // or resetForNewRun(keepItems: true)
                    let prologueVC = PrologueViewController()
                    self.navigationController?.pushViewController(prologueVC, animated: true)
                }))
                present(alert, animated: true)
                return
            }
        //0809 추가 (초기 실행 안전차원)
         UserModel.shared.clearAll()
           // ✅ 프롤로그부터 시작
           let prologueVC = PrologueViewController()
           navigationController?.pushViewController(prologueVC, animated: true)
         
           
        
    }
    
    @objc private func updateLoadButtonState() {
        let canResume = UserModel.shared.hasResumeData
                // 👉 만약 ‘퀘스트 기록만 있어도’ 활성화하고 싶으면 아래 주석 해제:
                // let hasProgress = (UserModel.shared.progress != nil) || (UserModel.shared.getQuestProgress().last != nil)

        
        rootView.loadButton.isEnabled = canResume
            rootView.loadButton.alpha = canResume ? 1.0 : 0.4
        
        }
    
    @objc private func didTapLoad() {
            //guard let p = UserModel.shared.progress else { return }
       
        let vc = MapViewController()
            navigationController?.pushViewController(vc, animated: true)
        }

        deinit { NotificationCenter.default.removeObserver(self) }
    
}
