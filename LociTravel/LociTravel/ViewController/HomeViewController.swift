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
        homeView.questListButton.addTarget(self, action: #selector(didTapQuestListButton), for: .touchUpInside)
    }
    
    @objc private func didTapStartButton() {
        let mapVC = MapViewController()
        navigationController?.pushViewController(mapVC, animated: true)
    }
    
    @objc private func didTapQuestListButton() {
        let questListVC = QuestListViewController()
        navigationController?.pushViewController(questListVC, animated: true)
    }
}
