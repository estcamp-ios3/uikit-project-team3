//
//  EpilogueView.swift
//  LociTravel
//
//  Created by 송서윤 on 8/8/25.
//

import UIKit

class EpilogueView: UIView {
    
    // MARK: - UI Components
    
    // 에필로그 텍스트를 표시하는 라벨
    let label = UILabel()
    // 프롤로그와 동일한 '넘어가기' 버튼 (에필로그에서는 필요 없을 수 있으나, 구조 통일을 위해 유지)
    let skipButton = UIButton(type: .system)
    // 프롤로그와 동일한 '빨리 감기' 버튼 (에필로그에서는 필요 없을 수 있으나, 구조 통일을 위해 유지)
    let fastForwardButton = UIButton(type: .system)
    // 에필로그가 끝난 후 '시작 화면으로' 버튼
    let endButton = UIButton(type: .system)
    // 전체 화면 배경 이미지 뷰
    let backgroundImageView = UIImageView()
    
    // 라벨의 레이아웃 제약 조건을 관리하기 위한 변수
    private var labelCenterYConstraint: NSLayoutConstraint!
    
    // MARK: - Action Closures
    
    // 버튼 탭 이벤트들을 외부(ViewController)에 전달하기 위한 클로저
    var onSkipButtonTapped: (() -> Void)?
    var onFastForwardButtonTapped: (() -> Void)?
    var onEndButtonTapped: (() -> Void)?
    
    // MARK: - Initialization
    
    // 코드로 뷰를 생성할 때 호출되는 초기화 메서드
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    // 스토리보드로 뷰를 생성할 때 호출되지만, 현재 코드에서는 사용되지 않음
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    
    // 모든 UI 컴포넌트를 설정하고 오토 레이아웃 제약 조건을 정의하는 메서드
    private func setupUI() {
        backgroundColor = .black
        
        // 배경 이미지 뷰 설정
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.image = UIImage(named: "All_Background")
        addSubview(backgroundImageView)
        sendSubviewToBack(backgroundImageView)
        
        // 라벨 설정 (텍스트 스타일, 위치 등)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.alpha = 0 // 초기에는 투명하게 설정하여 애니메이션으로 나타나게 함
        if let customFont = UIFont(name: "NanumMyeongjo", size: 22) {
            label.font = customFont
        } else {
            label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        }
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // 글자에 그림자 효과 추가
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 3.0
        label.layer.shadowOpacity = 0.8
        label.layer.shadowOffset = CGSize(width: 2, height: 2)
        label.layer.masksToBounds = false
        
        // 스킵 버튼 설정
        skipButton.setTitle("넘어가기", for: .normal)
        skipButton.setTitleColor(.white, for: .normal)
        skipButton.backgroundColor = .systemRed.withAlphaComponent(0.7)
        skipButton.layer.cornerRadius = 15
        skipButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.isHidden = true // 초기에는 숨겨져 있음
        
        // 빨리 감기 버튼 설정
        fastForwardButton.setTitle("빨리 감기", for: .normal)
        fastForwardButton.setTitleColor(.white, for: .normal)
        fastForwardButton.backgroundColor = .systemBlue.withAlphaComponent(0.7)
        fastForwardButton.layer.cornerRadius = 15
        fastForwardButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        fastForwardButton.translatesAutoresizingMaskIntoConstraints = false
        fastForwardButton.isHidden = true // 초기에는 숨겨져 있음
        
        // "시작 화면으로" 버튼 설정
        endButton.setTitle("시작 화면으로", for: .normal)
        endButton.setTitleColor(.white, for: .normal)
        endButton.backgroundColor = .systemBrown
        endButton.layer.cornerRadius = 25
        endButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        endButton.translatesAutoresizingMaskIntoConstraints = false
        endButton.isHidden = true // 초기에는 숨겨져 있음
        
        // UI 요소들을 뷰 계층에 추가
        addSubview(label)
        addSubview(skipButton)
        addSubview(fastForwardButton)
        addSubview(endButton)
        
        // 라벨의 중앙 정렬 제약 조건
        labelCenterYConstraint = label.centerYAnchor.constraint(equalTo: centerYAnchor)
        
        // 오토 레이아웃 제약 조건 활성화
        NSLayoutConstraint.activate([
            // 배경 이미지 뷰가 화면 전체를 덮도록 설정
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            // 버튼들 위치
            skipButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            skipButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            skipButton.widthAnchor.constraint(equalToConstant: 90),
            skipButton.heightAnchor.constraint(equalToConstant: 30),
            
            fastForwardButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            fastForwardButton.trailingAnchor.constraint(equalTo: skipButton.leadingAnchor, constant: -8),
            fastForwardButton.widthAnchor.constraint(equalToConstant: 90),
            fastForwardButton.heightAnchor.constraint(equalToConstant: 30),
            
            // 라벨의 위치 및 크기 제약 조건
            labelCenterYConstraint,
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            
            // "시작 화면으로" 버튼의 위치 및 크기 제약 조건
            endButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            endButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -50),
            endButton.widthAnchor.constraint(equalToConstant: 180),
            endButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // 버튼에 액션 메서드 연결
        skipButton.addTarget(self, action: #selector(didTapSkipButton), for: .touchUpInside)
        fastForwardButton.addTarget(self, action: #selector(didTapFastForwardButton), for: .touchUpInside)
        endButton.addTarget(self, action: #selector(didTapEndButton), for: .touchUpInside)
    }
    
    // MARK: - Button Actions
    
    // 스킵 버튼이 눌렸을 때 호출되는 메서드
    @objc private func didTapSkipButton() {
        onSkipButtonTapped?()
    }
    
    // 빨리 감기 버튼이 눌렸을 때 호출되는 메서드
    @objc private func didTapFastForwardButton() {
        onFastForwardButtonTapped?()
    }
    
    // "시작 화면으로" 버튼이 눌렸을 때 호출되는 메서드
    @objc private func didTapEndButton() {
        onEndButtonTapped?()
    }
    
    // MARK: - Public Methods
    
    // 에필로그 텍스트를 애니메이션과 함께 표시하고 사라지게 합니다.
    func showEpilogueText(_ text: String, duration: TimeInterval, delay: TimeInterval, completion: @escaping () -> Void) {
        if let customFont = UIFont(name: "NanumMyeongjo", size: 22) {
            label.font = customFont // 본문 폰트 스타일
        }
        label.text = text
        label.alpha = 0
        
        // 텍스트가 나타나는 애니메이션
        UIView.animate(withDuration: 1.0, animations: {
            self.label.alpha = 1.0
        }, completion: { _ in
            // 지정된 시간(delay) 동안 텍스트가 노출된 후 사라지는 애니메이션
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                UIView.animate(withDuration: 1.0, animations: {
                    self.label.alpha = 0
                }, completion: { _ in
                    completion()
                })
            }
        })
    }
    
    // '넘어가기'와 '빨리 감기' 버튼의 표시 여부를 제어하는 메서드
    func showButtons(_ show: Bool) {
        skipButton.isHidden = !show
        fastForwardButton.isHidden = !show
    }
    
    // '시작 화면으로' 버튼을 표시하고 다른 버튼들을 숨기는 메서드
    func showEndButton() {
        endButton.isHidden = false
        showButtons(false)
    }
}
