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
    private let defaultTextDuration: TimeInterval = 4.0
    private let fastForwardTextDuration: TimeInterval = 1.0
    
    private var lastShownImageName: String?
    
    
    private let epilogueDialogues: [String] = [
        "목걸이와 구슬이 맞춰지는 순간",
        "무왕이여, 백제를 다시 밝히라 – 예언의 문장이 허공에 떠오른다.",
        "선화 : 목걸이가… 빛나고 있어요…!",
        "서동 : 무왕이라… 이게 바로 그 예언의 끝이구나.",
        "두 조각의 목걸이가 합쳐지자, 고조선의 마지막 왕 준위왕이 남긴 염원이 빛을 발하며 새로운 역사의 서막을 알렸다.",
        "서동은 더 이상 시장의 어린아이가 아니었다. 그는 백제의 새로운 왕, 무왕으로서 백성을 이끌 운명을 깨달았다.",
        "신라의 공주 선화는 그저 예언이 정해준 대상이 아닌, 진정한 동반자였다.",
        "선화 : 당신은 피로 이어진 왕이 아닌, 믿음으로 선택된 왕이에요.",
        "서동 : 그렇소. 백제의 땅은 이미 수많은 피를 흘렸다오. 이제 그 피의 역사를 끝내고, 백성들의 믿음과 평화로 새로운 시대를 열어야 하오.",
        "선화 : 당신의 마음이 백성의 마음과 함께하는 한, 백제는 영원히 빛날 거예요.",
        "서동 : 이제, 우리가 함께 백제의 새로운 시대를 엽시다.",
        "서동의 목소리는 드넓은 왕궁을 넘어 백성들에게 닿았다. 백성들은 자신들의 삶을 보듬어 줄 진정한 왕의 탄생을 보며 환호했다.",
        "(백성들) : 만세! 만세! 무왕 만세!",
        "무왕은 선화와 함께 손을 잡고 백성들을 향해 걸어 나갔다.",
        "그들의 발걸음이 닿는 곳마다 평화의 기운이 싹트고, 새로운 희망이 피어났다.",
        "준위왕이 남긴 마지막 염원은 서동과 선화의 만남을 통해 평화와 화합의 백제를 완성하는 위대한 서사가 되었다.",
        "예언이 완성되었습니다. 당신의 이야기는 전설이 되었습니다."
    ]
    
    
    override func loadView() {
        epilogueView = EpilogueView()
        view = epilogueView
        
        epilogueView.onSkipButtonTapped = { [weak self] in self?.navigateToRootView() }
        epilogueView.onFastForwardButtonTapped = { [weak self] in
            guard let self = self else { return }
            self.isFastForwarding.toggle()
            self.epilogueView.fastForwardButton.setTitle(self.isFastForwarding ? "정상 속도" : "빨리 감기", for: .normal)
        }
        epilogueView.onEndButtonTapped = { [weak self] in self?.navigateToRootView() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        epilogueView.showButtons(true)
        showNextDialogue()
    }
    
    private func setupButtonActions() {
        epilogueView.photoButton.addTarget(self, action: #selector(handlePhotoButtonTapped), for: .touchUpInside)
    }
    
    @objc private func handlePhotoButtonTapped() {
        let overlay = UIImage(named: "bg")  // 투명 PNG 권장(없으면 nil)
        CameraService.shared.present(from: self, overlay: overlay) { [weak self] image in
            // 저장 (커스텀 앨범에 넣고 싶으면 이름 지정)
            PhotoSaver.save(image, toAlbum: "LociTravel") { result in
                switch result {
                case .success:
                    self?.toast("사진이 저장되었어요 📸")
                case .failure(let err):
                    self?.showAlert(title: "저장 실패", message: err.localizedDescription)
                }
            }
        }
    }
    
    private func showNextDialogue() {
        guard dialogueIndex < epilogueDialogues.count else {
            epilogueView.showEndButton()
            return
        }
        
        let currentDialogueText = epilogueDialogues[dialogueIndex]
        let duration = isFastForwarding ? fastForwardTextDuration : defaultTextDuration
        
        var targetImageName: String? = nil
        
        switch dialogueIndex {
        case 0...1:
            targetImageName = "epilogue99"
        case 2...3:
            targetImageName = "epilogue0"
        case 4:
            targetImageName = "epilogue1"
        case 5...10:
            targetImageName = "epiloguetwo"
        case 11...15:
            targetImageName = "epiloguelast"
        case 16:
            targetImageName = nil
        default:
            break
        }
        
        if targetImageName != lastShownImageName {
            epilogueView.updateImage(name: targetImageName)
            lastShownImageName = targetImageName
        }
        
        // 마지막 대사일 때 레이블 위치를 변경
        let isLastDialogue = dialogueIndex == epilogueDialogues.count - 1
        epilogueView.showEpilogueText(currentDialogueText, isLastDialogue: isLastDialogue, duration: 1.0, delay: duration) { [weak self] in
            guard let self = self else { return }
            self.dialogueIndex += 1
            self.showNextDialogue()
        }
    }
    
    private func navigateToRootView() {
        print("시작 화면으로 이동합니다.")
        navigationController?.popToRootViewController(animated: true)
        
        //UserModel.shared.clearAll()
    }
}


#Preview {
    EpilogueViewController()
}
