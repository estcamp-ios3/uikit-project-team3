//
//  PrologueViewController.swift
//  LociTravel
//
//  Created by dkkim on 8/6/25.
//

import UIKit

class PrologueViewController: UIViewController {

    private var prologueView: PrologueView!
    var chapterIndex = 0
    var isFastForwarding = false

    // 기본 애니메이션 타이밍 설정
    private let defaultTextDuration: TimeInterval = 4.0
    private let fastForwardTextDuration: TimeInterval = 1.0

    override func loadView() {
        prologueView = PrologueView()
        view = prologueView

        // 버튼 액션 클로저 설정
        prologueView.onSkipButtonTapped = { [weak self] in
            self?.navigateToMapView()
        }

        prologueView.onFastForwardButtonTapped = { [weak self] in
            guard let self = self else { return }
            self.isFastForwarding.toggle()
            self.prologueView.fastForwardButton.setTitle(self.isFastForwarding ? "정상 속도" : "빨리 감기", for: .normal)
        }

        prologueView.onStartExplorationButtonTapped = { [weak self] in
            self?.navigateToMapView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        prologueView.showButtons(true) // 버튼 표시
        showNextChapter()
    }
    
    private func showNextChapter() {
        guard chapterIndex < StoryModel.prologueChapters.count else {
            // 모든 프롤로그가 끝난 후 "탐험 시작" 버튼 표시
            prologueView.showStartExplorationButton()
            return
        }
        
        let currentChapterText = StoryModel.prologueChapters[chapterIndex]
        
        // 현재 빨리 감기 상태에 따라 애니메이션 시간 결정
        let duration = isFastForwarding ? fastForwardTextDuration : defaultTextDuration

        prologueView.showPrologueText(currentChapterText, duration: 1.0, delay: duration) {
            self.chapterIndex += 1
            self.showNextChapter()
        }
    }

    // MARK: - 화면 전환 로직 (수정된 부분)
    private func navigateToMapView() {
        print("맵뷰로 이동합니다.")

        // 네비게이션 컨트롤러를 사용하여 화면 전환
        let mapVC = MapViewController()
        navigationController?.pushViewController(mapVC, animated: true)
    }
}
