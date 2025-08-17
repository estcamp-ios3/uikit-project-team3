//
//  PrologueViewController.swift
//  LociTravel
//
//  Created by dkkim on 8/6/25.
//

import UIKit

class PrologueViewController: PortraitOnlyViewController {

    // MARK: - Properties
    
    private var prologueView: PrologueView!
    var chapterIndex = 0
    var isFastForwarding = false
    private let defaultTextDuration: TimeInterval = 4.0
    private let fastForwardTextDuration: TimeInterval = 1.0
    
    // 마지막으로 보여준 이미지 이름을 추적하는 변수
    private var lastShownImageName: String?

    // MARK: - View Lifecycle
    
    override func loadView() {
        prologueView = PrologueView()
        view = prologueView

        prologueView.onSkipButtonTapped = { [weak self] in self?.navigateToMapView() }
        prologueView.onFastForwardButtonTapped = { [weak self] in
            guard let self = self else { return }
            self.isFastForwarding.toggle()
            let title = self.isFastForwarding ? "정상 속도" : "빨리 감기"
            self.prologueView.fastForwardButton.setTitle(title, for: .normal)
        }
        prologueView.onStartExplorationButtonTapped = { [weak self] in self?.navigateToMapView() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        prologueView.showButtons(true)
        showTitle() // 제목 애니메이션 먼저 시작
    }
    
    // MARK: - Private Methods
    
    private func showTitle() {
        let titleText = StoryModel.prologueTexts[0]
        prologueView.showTitle(titleText) { [weak self] in
            self?.chapterIndex = 1
            self?.showNextChapter()
        }
    }
    
    private func showNextChapter() {
        guard chapterIndex < StoryModel.prologueTexts.count else {
            prologueView.showStartExplorationButton()
            return
        }
        
        let currentChapterText = StoryModel.prologueTexts[chapterIndex]
        let duration = isFastForwarding ? fastForwardTextDuration : defaultTextDuration
        
        // 텍스트 인덱스를 기준으로 이미지와 연결하는 로직
        var targetImageName: String? = nil
        
        switch chapterIndex {
        case 1: // "고조선의 마지막 왕..."
            targetImageName = StoryModel.prologueImageNames[0]
        case 2, 3: // "그는 죽음을 앞두고...", "\"이 목걸이가..."
            targetImageName = StoryModel.prologueImageNames[2]
        case 4, 5, 6: // "목걸이의 한 조각은...", "고승은 울고 있는...", "훗날 이 아이가..."
            targetImageName = StoryModel.prologueImageNames[3]
        case 7, 8, 9: // "다른 한 조각은...", "고승은 갓 태어난...", "이 아이가 평화의..."
            targetImageName = StoryModel.prologueImageNames[4]
        default:
            break
        }
        
        // 이미지가 바뀌는 경우에만 업데이트
        if targetImageName != lastShownImageName {
            prologueView.updateImage(name: targetImageName)
            lastShownImageName = targetImageName
        }
        
        // 텍스트 애니메이션 시작
        prologueView.showPrologueText(currentChapterText, duration: 1.0, delay: duration) { [weak self] in
            guard let self = self else { return }
            
            // chapterIndex 1일 때만 이미지 2를 추가로 보여주는 로직
            if self.chapterIndex == 1 {
                let nextImageName = StoryModel.prologueImageNames[1]
                self.prologueView.updateImage(name: nextImageName)
                self.lastShownImageName = nextImageName
                
                // 두 번째 이미지도 정해진 시간 동안 화면에 유지
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    self.chapterIndex += 1
                    self.showNextChapter()
                }
            } else {
                self.chapterIndex += 1
                self.showNextChapter()
            }
        }
    }

    private func navigateToMapView() {
        print("맵뷰로 이동합니다.")
        let mapVC = MapViewController()
        navigationController?.pushViewController(mapVC, animated: true)
    }
}

#Preview{
    PrologueViewController()
}
