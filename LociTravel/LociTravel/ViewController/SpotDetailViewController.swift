//
//  SpotDetailViewController.swift
//  LociTravel
//
//  Created by suji chae on 8/5/25.
//

import UIKit

class SpotDetailViewController: UIViewController {

    private let spotDetailView = SpotDetailView()
    
    // MARK: - 스토리 데이터 (예시)
    private let storyParts: [String: StoryPart] = [
        "start": StoryPart(
            speaker: "로키",
            text: "안녕! 나는 이 오래된 미륵사지에 숨겨진 이야기를 관리하는 로키라고 해.",
            image: "mireuksa_temple_photo",
            options: ["A. 이곳에 대해 더 자세히 알려줘.", "B. 로키, 너는 누구야?"]
        ),
        "A": StoryPart(
            speaker: "로키",
            text: "좋아! 이곳은 과거 백제 시대의 거대한 사찰이었어. 지금은 폐허만 남았지만, 그 흔적에는 많은 이야기가 담겨 있지.",
            image: nil,
            options: ["C. 그럼 그 이야기를 들려줘."]
        ),
        "B": StoryPart(
            speaker: "로키",
            text: "나는 시간의 기록을 지키는 쥐야. 시간의 흐름 속에서 잊힌 기억들을 찾아다니지.",
            image: nil,
            options: ["C. 그럼 그 이야기를 들려줘."]
        ),
        "C": StoryPart(
            speaker: "로키",
            text: "좋아, 이야기의 첫 장을 열어볼까? 이 이야기는 무왕과 선화공주의 사랑에서 시작돼...",
            image: nil,
            options: nil
        )
    ]
    
    private var currentStoryKey = "start"

    override func loadView() {
        view = spotDetailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtonActions()
        displayCurrentStoryPart()
    }
    
    private func setupButtonActions() {
        spotDetailView.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
    }
    
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }

    private func displayCurrentStoryPart() {
        guard let part = storyParts[currentStoryKey] else { return }
        
        // 여기에 storyContainerView에 대화 내용을 표시하는 로직 구현
        // 기존의 모든 뷰를 제거하고, 새로운 대화 UI를 동적으로 생성
        spotDetailView.storyContainerView.subviews.forEach { $0.removeFromSuperview() }
        
        // 예시 대화 UI 구성
        let dialogLabel = UILabel()
        dialogLabel.numberOfLines = 0
        dialogLabel.text = "[\(part.speaker)] \(part.text)"
        
        spotDetailView.storyContainerView.addSubview(dialogLabel)
        dialogLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(20)
        }
        
        let optionStackView = UIStackView()
        optionStackView.axis = .vertical
        optionStackView.spacing = 10
        spotDetailView.storyContainerView.addSubview(optionStackView)
        optionStackView.snp.makeConstraints { make in
            make.top.equalTo(dialogLabel.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview().inset(20)
        }
        
        part.options?.forEach { option in
            let button = UIButton(type: .system)
            button.setTitle(option, for: .normal)
            // 버튼 액션 추가
            optionStackView.addArrangedSubview(button)
        }
    }
}
