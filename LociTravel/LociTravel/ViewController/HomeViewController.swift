//
//  HomeViewController.swift
//  LociTravel
//
//  Created by suji chae on 8/5/25.
//

import UIKit

class HomeViewController: UIViewController {
    private let homeView = HomeView()
    
    
    override func loadView() {
        view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        setupButtonActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func setupButtonActions() {
        homeView.startButton.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
        
        //0806 questlistbutton -> loadbutton으로 수정
        homeView.loadButton.addTarget(self, action: #selector(didTapQuestListButton), for: .touchUpInside)
    }
    
    //시작하기 버튼 함수
    @objc private func didTapStartButton() {
        //let mapVC = MapViewController()
        //0806 시작하기 버튼 클릭하면 PrologueView 화면으로 이동하게 만들기
        let prologueVC = PrologueViewController()
        navigationController?.pushViewController(prologueVC, animated: true)
    }
    
    //추후에 이어하기 버튼으로 변경
    @objc private func didTapQuestListButton() {
        //let questListVC = QuestListViewController()
        //navigationController?.pushViewController(questListVC, animated: true)
    }
}
