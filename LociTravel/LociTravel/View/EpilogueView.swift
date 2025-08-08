//
//  EpilogueView.swift.swift
//  LociTravel
//
//  Created by 송서윤 on 8/8/25.
//

import UIKit

class EpilogueView: UIView {
    
    let label = UILabel()
    let skipButton = UIButton(type: .system)
    let fastForwardButton = UIButton(type: .system)
    let endButton = UIButton(type: .system) // "시작 화면으로" 버튼
    let backgroundImageView = UIImageView()
    
    var onSkipButtonTapped: (() -> Void)?
    var onFastForwardButtonTapped: (() -> Void)?
    var onEndButtonTapped: (() -> Void)?
    
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
        sendSubviewToBack(backgroundImageView)
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
        
        // "시작 화면으로" 버튼 설정
        endButton.setTitle("시작 화면으로", for: .normal)
        endButton.setTitleColor(.white, for: .normal)
        endButton.backgroundColor = .systemBrown
        endButton.layer.cornerRadius = 25
        endButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        endButton.translatesAutoresizingMaskIntoConstraints = false
        endButton.isHidden = true
        
        // 뷰 계층 구조 설정
        addSubview(label)
        addSubview(skipButton)
        addSubview(fastForwardButton)
        addSubview(endButton)
        
        // 오토 레이아웃 설정
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            
            skipButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            skipButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            skipButton.widthAnchor.constraint(equalToConstant: 100),
            skipButton.heightAnchor.constraint(equalToConstant: 30),
            
            fastForwardButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            fastForwardButton.trailingAnchor.constraint(equalTo: skipButton.leadingAnchor, constant: -8),
            fastForwardButton.widthAnchor.constraint(equalToConstant: 100),
            fastForwardButton.heightAnchor.constraint(equalToConstant: 30),
            
            endButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            endButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -50),
            endButton.widthAnchor.constraint(equalToConstant: 180),
            endButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // 버튼 액션 연결
        skipButton.addTarget(self, action: #selector(didTapSkipButton), for: .touchUpInside)
        fastForwardButton.addTarget(self, action: #selector(didTapFastForwardButton), for: .touchUpInside)
        endButton.addTarget(self, action: #selector(didTapEndButton), for: .touchUpInside)
    }
    
    @objc private func didTapSkipButton() {
        onSkipButtonTapped?()
    }
    
    @objc private func didTapFastForwardButton() {
        onFastForwardButtonTapped?()
    }
    
    @objc private func didTapEndButton() {
        onEndButtonTapped?()
    }
    
    func showButtons(_ show: Bool) {
        skipButton.isHidden = !show
        fastForwardButton.isHidden = !show
    }
    
    func showDialogueText(_ text: String, duration: TimeInterval, delay: TimeInterval, completion: @escaping () -> Void) {
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
    
    func showEndButton() {
        endButton.isHidden = false
        showButtons(false)
    }
}
