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
        setupNavigationBar()
        setupButtonActions()
    }

    private func setupNavigationBar() {
        // 내비게이션 바 숨기기
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func setupButtonActions() {
        // 버튼에 액션 연결
        if let mapButton = homeView.navigationStackView.arrangedSubviews[0] as? UIButton {
            mapButton.addTarget(self, action: #selector(didTapMapButton), for: .touchUpInside)
        }
        if let questButton = homeView.navigationStackView.arrangedSubviews[1] as? UIButton {
            questButton.addTarget(self, action: #selector(didTapQuestButton), for: .touchUpInside)
        }
        if let recordsButton = homeView.navigationStackView.arrangedSubviews[2] as? UIButton {
            recordsButton.addTarget(self, action: #selector(didTapRecordsButton), for: .touchUpInside)
        }
    }

    @objc private func didTapMapButton() {
        let mapVC = MapViewController()
        navigationController?.pushViewController(mapVC, animated: true)
    }

    @objc private func didTapQuestButton() {
        let questVC = QuestListViewController()
        navigationController?.pushViewController(questVC, animated: true)
    }

    @objc private func didTapRecordsButton() {
        // 기록 화면으로 이동
    }
}
