//
//  EpilogueViewController.swift
//  LociTravel
//
//  Created by 송서윤 on 8/8/25.
//

import UIKit

class EpilogueViewController: UIViewController {
    
    private var epilogueView: EpilogueView!
    var dialogueIndex = 0
    var isFastForwarding = false
    
    // 기본 애니메이션 타이밍 설정
    private let defaultTextDuration: TimeInterval = 4.0
    private let fastForwardTextDuration: TimeInterval = 1.0
    
    // MARK: - 에필로그 대사 데이터
    // StoryModel의 dialogues_Palace_Epilogue를 사용합니다.
    private let epilogueDialogues = dialogues_Palace_Epilogue
    
    override func loadView() {
        epilogueView = EpilogueView()
        view = epilogueView
        
        // ✅ '넘어가기' 버튼을 누르면 시작 화면으로 이동하도록 수정
        epilogueView.onSkipButtonTapped = { [weak self] in
            self?.navigateToRootView()
        }
        
        epilogueView.onFastForwardButtonTapped = { [weak self] in
            guard let self = self else { return }
            self.isFastForwarding.toggle()
            self.epilogueView.fastForwardButton.setTitle(self.isFastForwarding ? "정상 속도" : "빨리 감기", for: .normal)
        }
        
        epilogueView.onEndButtonTapped = { [weak self] in
            self?.navigateToRootView()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        epilogueView.showButtons(true)
        showNextDialogue()
    }
    
    private func showNextDialogue() {
        guard dialogueIndex < epilogueDialogues.count else {
            // 모든 대화가 끝나면 "시작 화면으로" 버튼 표시
            epilogueView.showEndButton()
            return
        }
        
        let currentDialogue = epilogueDialogues[dialogueIndex]
        let dialogueText = "\(currentDialogue.speaker): \(currentDialogue.line)"
        
        let duration = isFastForwarding ? fastForwardTextDuration : defaultTextDuration
        
        epilogueView.showDialogueText(dialogueText, duration: 1.0, delay: duration) {
            self.dialogueIndex += 1
            self.showNextDialogue()
        }
    }
    
    private func navigateToRootView() {
        print("시작 화면으로 이동합니다.")
        navigationController?.popToRootViewController(animated: true)
        
        // 퀘스트 완료 기록을 초기화하여 다음 플레이를 대비합니다.
        UserModel.shared.clearAll()
    }
}
