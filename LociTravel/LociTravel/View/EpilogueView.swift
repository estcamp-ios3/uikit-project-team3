//
//  EpilogueView.swift
//  LociTravel
//
//  Created by 송서윤 on 8/8/25.
//

import UIKit

class EpilogueView: UIView {
    
    
    let label = UILabel()
    let skipButton = UIButton(type: .system)
    let fastForwardButton = UIButton(type: .system)
    let endButton = UIButton(type: .system)
    
    let backgroundImageView = UIImageView()
    let storyImageView = UIImageView()
    
    
    private var labelBelowImageConstraint: NSLayoutConstraint!
    private var labelCenterYConstraint: NSLayoutConstraint!
    
    
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
        
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.image = UIImage(named: "All_Background")
        addSubview(backgroundImageView)
        sendSubviewToBack(backgroundImageView)
        
        storyImageView.contentMode = .scaleAspectFit
        storyImageView.translatesAutoresizingMaskIntoConstraints = false
        storyImageView.alpha = 0
        addSubview(storyImageView)
        
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.alpha = 0
        if let customFont = UIFont(name: "NanumMyeongjo", size: 22) {
            label.font = customFont
        } else {
            label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        }
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 3.0
        label.layer.shadowOpacity = 0.8
        label.layer.shadowOffset = CGSize(width: 2, height: 2)
        label.layer.masksToBounds = false
        
        skipButton.setTitle("넘어가기", for: .normal)
        skipButton.setTitleColor(.white, for: .normal)
        skipButton.backgroundColor = .systemRed.withAlphaComponent(0.7)
        skipButton.layer.cornerRadius = 15
        skipButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.isHidden = true
        
        fastForwardButton.setTitle("빨리 감기", for: .normal)
        fastForwardButton.setTitleColor(.white, for: .normal)
        fastForwardButton.backgroundColor = .systemBlue.withAlphaComponent(0.7)
        fastForwardButton.layer.cornerRadius = 15
        fastForwardButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        fastForwardButton.translatesAutoresizingMaskIntoConstraints = false
        fastForwardButton.isHidden = true
        
        endButton.setTitle("시작 화면으로", for: .normal)
        endButton.setTitleColor(.white, for: .normal)
        endButton.backgroundColor = .systemBrown
        endButton.layer.cornerRadius = 25
        endButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        endButton.translatesAutoresizingMaskIntoConstraints = false
        endButton.isHidden = true
        
        addSubview(label)
        addSubview(skipButton)
        addSubview(fastForwardButton)
        addSubview(endButton)
        
        // 레이블 위치 제약 조건 정의
        labelCenterYConstraint = label.centerYAnchor.constraint(equalTo: centerYAnchor)
        labelBelowImageConstraint = label.topAnchor.constraint(equalTo: storyImageView.bottomAnchor, constant: 20)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            storyImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            storyImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -100),
            storyImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            storyImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
            
            // 초기 레이아웃은 이미지 아래에 레이블을 배치
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
            
            endButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            endButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -50),
            endButton.widthAnchor.constraint(equalToConstant: 180),
            endButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // 기본 레이아웃은 이미지 아래에 배치
        labelBelowImageConstraint.isActive = true
        
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
    
    
    func updateImage(name: String?) {
        // 이미지가 없으면 alpha를 0으로 만들고, 있으면 1로 만듭니다.
        let targetAlpha: CGFloat = name == nil ? 0 : 1
        let image = name == nil ? nil : UIImage(named: name!)
        
        UIView.transition(with: storyImageView,
                          duration: 1.0,
                          options: .transitionCrossDissolve,
                          animations: {
            self.storyImageView.image = image
            self.storyImageView.alpha = targetAlpha
        }, completion: nil)
    }
    
    
    
    func showEpilogueText(_ text: String, isLastDialogue: Bool, duration: TimeInterval, delay: TimeInterval, completion: @escaping () -> Void) {
        
        if isLastDialogue {
            labelBelowImageConstraint.isActive = false
            labelCenterYConstraint.isActive = true
        } else {
            labelCenterYConstraint.isActive = false
            labelBelowImageConstraint.isActive = true
        }
        
        if let customFont = UIFont(name: "NanumMyeongjo", size: 22) {
            label.font = customFont
        }
        label.text = text
        label.alpha = 0
        
        UIView.animate(withDuration: 1.0, animations: {
            self.label.alpha = 1.0
            
            self.layoutIfNeeded()
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
    
    func showButtons(_ show: Bool) {
        skipButton.isHidden = !show
        fastForwardButton.isHidden = !show
    }
    
    func showEndButton() {
        endButton.isHidden = false
        showButtons(false)
    }
}
