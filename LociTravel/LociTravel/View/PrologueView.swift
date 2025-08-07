//
//  PrologueView.swift
//  LociTravel
//
//  Created by dkkim on 8/6/25.
//

import UIKit

class PrologueView: UIView {

    let label = UILabel()
    let skipButton = UIButton(type: .system)
    let fastForwardButton = UIButton(type: .system)
    let startExplorationButton = UIButton(type: .system) // "탐험 시작" 버튼 추가
    let backgroundImageView = UIImageView()

    // 버튼 동작을 전달하기 위한 클로저
    var onSkipButtonTapped: (() -> Void)?
    var onFastForwardButtonTapped: (() -> Void)?
    var onStartExplorationButtonTapped: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .black

        // 배경 이미지뷰 설정
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.image = UIImage(named: "background/prologue_background")
        addSubview(backgroundImageView)
        sendSubviewToBack(backgroundImageView) // 배경 이미지가 다른 뷰 뒤에 오도록 설정
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])

        // 라벨 설정
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.alpha = 0
        // "나눔명조" 폰트 적용 (폰트 파일이 프로젝트에 추가되어야 합니다.)
        if let customFont = UIFont(name: "NanumMyeongjo", size: 22) {
            label.font = customFont
        } else {
            label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        }
        label.translatesAutoresizingMaskIntoConstraints = false

        // 스킵 버튼 설정
        skipButton.setTitle("넘어가기", for: .normal)
        skipButton.setTitleColor(.white, for: .normal)
        skipButton.backgroundColor = .systemRed.withAlphaComponent(0.7)
        skipButton.layer.cornerRadius = 15
        skipButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.isHidden = true

        // 빨리 감기 버튼 설정
        fastForwardButton.setTitle("빨리 감기", for: .normal)
        fastForwardButton.setTitleColor(.white, for: .normal)
        fastForwardButton.backgroundColor = .systemBlue.withAlphaComponent(0.7)
        fastForwardButton.layer.cornerRadius = 15
        fastForwardButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        fastForwardButton.translatesAutoresizingMaskIntoConstraints = false
        fastForwardButton.isHidden = true

        // "탐험 시작" 버튼 설정
        startExplorationButton.setTitle("탐험 시작", for: .normal)
        startExplorationButton.setTitleColor(.white, for: .normal)
        startExplorationButton.backgroundColor = .systemBrown
        startExplorationButton.layer.cornerRadius = 25
        startExplorationButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        startExplorationButton.translatesAutoresizingMaskIntoConstraints = false
        startExplorationButton.isHidden = true

        // 뷰 계층 구조 설정
        addSubview(label)
        addSubview(skipButton)
        addSubview(fastForwardButton)
        addSubview(startExplorationButton)

        // 오토 레이아웃 설정
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),

            skipButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            skipButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            skipButton.widthAnchor.constraint(equalToConstant: 90),
            skipButton.heightAnchor.constraint(equalToConstant: 30),

            fastForwardButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            fastForwardButton.trailingAnchor.constraint(equalTo: skipButton.leadingAnchor, constant: -8),
            fastForwardButton.widthAnchor.constraint(equalToConstant: 90),
            fastForwardButton.heightAnchor.constraint(equalToConstant: 30),

            startExplorationButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            startExplorationButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -50),
            startExplorationButton.widthAnchor.constraint(equalToConstant: 180),
            startExplorationButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        // 버튼 액션 연결
        skipButton.addTarget(self, action: #selector(didTapSkipButton), for: .touchUpInside)
        fastForwardButton.addTarget(self, action: #selector(didTapFastForwardButton), for: .touchUpInside)
        startExplorationButton.addTarget(self, action: #selector(didTapStartExplorationButton), for: .touchUpInside)
    }

    @objc private func didTapSkipButton() {
        onSkipButtonTapped?()
    }

    @objc private func didTapFastForwardButton() {
        onFastForwardButtonTapped?()
    }

    @objc private func didTapStartExplorationButton() {
        onStartExplorationButtonTapped?()
    }

    func showButtons(_ show: Bool) {
        skipButton.isHidden = !show
        fastForwardButton.isHidden = !show
    }

    func showPrologueText(_ text: String, duration: TimeInterval, delay: TimeInterval, completion: @escaping () -> Void) {
        label.text = text
        label.alpha = 0
        
        UIView.animate(withDuration: 1.0, animations: {
            self.label.alpha = 1.0
        }, completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                UIView.animate(withDuration: 1.0, animations: {
                    self.label.alpha = 0
                }, completion: { _ in
                    completion()
                })
            }
        })
    }
    
    func showStartExplorationButton() {
        startExplorationButton.isHidden = false
        showButtons(false) // 다른 버튼 숨기기
    }
}
