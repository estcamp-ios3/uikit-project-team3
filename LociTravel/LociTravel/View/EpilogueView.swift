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
    let photoButton = UIButton(type: .system) //기념사진촬영 버튼
    
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

        // 🎯 기념 촬영 버튼 스타일 설정
        // 기념 촬영 버튼 추가
        photoButton.setTitle(" 기념 촬영", for: .normal) // 앞에 공백을 넣어 글자와 아이콘 간격 확보
        photoButton.setTitleColor(.white, for: .normal)
        photoButton.backgroundColor = .systemGreen
        photoButton.layer.cornerRadius = 25
        photoButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        photoButton.translatesAutoresizingMaskIntoConstraints = false

        // 📷 카메라 아이콘 추가 (SF Symbols)
        let cameraImage = UIImage(systemName: "camera.fill")
        photoButton.setImage(cameraImage, for: .normal)
        photoButton.tintColor = .white // 아이콘 색상
        photoButton.imageView?.contentMode = .scaleAspectFit

        // 이미지와 텍스트 간격 조정
        photoButton.semanticContentAttribute = .forceLeftToRight
        photoButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)

        photoButton.isHidden = true
                
        addSubview(label)
        addSubview(skipButton)
        addSubview(fastForwardButton)
        
        // 📌 버튼들을 담을 StackView
        let bottomButtonStack = UIStackView(arrangedSubviews: [endButton, photoButton])
        bottomButtonStack.axis = .horizontal
        bottomButtonStack.spacing = 20
        bottomButtonStack.alignment = .center
        bottomButtonStack.distribution = .equalSpacing
        bottomButtonStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomButtonStack)
        
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
            
            // 📌 하단 버튼 스택 가운데 정렬
            bottomButtonStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            bottomButtonStack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -50),
            
            photoButton.widthAnchor.constraint(equalToConstant: 140),
            photoButton.heightAnchor.constraint(equalToConstant: 50),
            
            endButton.widthAnchor.constraint(equalToConstant: 140),
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
        photoButton.isHidden = false
        showButtons(false)
    }
}
