//
//  HomeViewController.swift
//  LociTravel
//
//  Created by suji chae on 8/5/25.
//

import UIKit

class HomeViewController: UIViewController {
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
        //let mapVC = MapViewController()
        //0806 시작하기 버튼 클릭하면 PrologueView 화면으로 이동하게 만들기
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
