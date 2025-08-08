//
//  PrologueView.swift
//  LociTravel
//
//  Created by dkkim on 8/6/25.
//
import UIKit

class PrologueView: UIView {

    // MARK: - UI Components
    
    // 프롤로그 텍스트를 표시하는 라벨
    let label = UILabel()
    // 프롤로그를 건너뛰고 다음 화면으로 넘어가는 버튼
    let skipButton = UIButton(type: .system)
    // 텍스트 애니메이션 속도를 빠르게 하는 버튼
    let fastForwardButton = UIButton(type: .system)
    // 프롤로그가 끝난 후 '탐험 시작' 버튼
    let startExplorationButton = UIButton(type: .system)
    // 전체 화면 배경 이미지 뷰
    let backgroundImageView = UIImageView()
    // 챕터별로 바뀌는 프롤로그 이미지 뷰
    let prologueImageView = UIImageView()

    
    // 라벨의 레이아웃 제약 조건을 관리하기 위한 변수들
    private var labelDefaultTopConstraint: NSLayoutConstraint!
    private var labelDefaultBottomConstraint: NSLayoutConstraint!
    private var labelTitleCenterYConstraint: NSLayoutConstraint!
    
    // MARK: - Action Closures
    
    // 버튼 탭 이벤트들을 외부(ViewController)에 전달하기 위한 클로저
    var onSkipButtonTapped: (() -> Void)?
    var onFastForwardButtonTapped: (() -> Void)?
    var onStartExplorationButtonTapped: (() -> Void)?

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
        
        // 프롤로그 이미지 뷰 설정
        prologueImageView.contentMode = .scaleAspectFill
        prologueImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(prologueImageView)

        // 배경 이미지와 프롤로그 이미지를 가장 뒤에 배치
        sendSubviewToBack(prologueImageView)
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
        
        // 모든 텍스트에 적용되도록 라벨 그림자 효과를 setupUI에서 설정
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

        // 탐험 시작 버튼 설정
        startExplorationButton.setTitle("탐험 시작", for: .normal)
        startExplorationButton.setTitleColor(.white, for: .normal)
        startExplorationButton.backgroundColor = .systemBrown
        startExplorationButton.layer.cornerRadius = 25
        startExplorationButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        startExplorationButton.translatesAutoresizingMaskIntoConstraints = false
        startExplorationButton.isHidden = true // 초기에는 숨겨져 있음

        // UI 요소들을 뷰 계층에 추가
        addSubview(label)
        addSubview(skipButton)
        addSubview(fastForwardButton)
        addSubview(startExplorationButton)
        
        // 라벨의 기본(본문) 제약 조건을 미리 정의
        labelDefaultTopConstraint = label.topAnchor.constraint(equalTo: prologueImageView.bottomAnchor, constant: 20)
        labelDefaultBottomConstraint = label.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -150)
        // 제목용 제약 조건은 초기에는 비활성화 상태로 정의
        labelTitleCenterYConstraint = label.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -100)
        labelTitleCenterYConstraint.isActive = false // 처음에는 비활성화

        // 오토 레이아웃 제약 조건 활성화
        NSLayoutConstraint.activate([
            // 배경 이미지 뷰가 화면 전체를 덮도록 설정
            backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            // 버튼들 위치
            skipButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            skipButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            skipButton.widthAnchor.constraint(equalToConstant: 90),
            skipButton.heightAnchor.constraint(equalToConstant: 30),

            fastForwardButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            fastForwardButton.trailingAnchor.constraint(equalTo: skipButton.leadingAnchor, constant: -8),
            fastForwardButton.widthAnchor.constraint(equalToConstant: 90),
            fastForwardButton.heightAnchor.constraint(equalToConstant: 30),
            
            // 프롤로그 이미지 뷰의 위치 및 크기 제약 조건
            // 버튼 아래에 위치하고, 높이를 300pt로 고정
            prologueImageView.topAnchor.constraint(equalTo: fastForwardButton.bottomAnchor, constant: 20),
            prologueImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            prologueImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            prologueImageView.heightAnchor.constraint(equalToConstant: 300),

            // 라벨의 기본(본문) 제약 조건 활성화
            labelDefaultTopConstraint,
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            labelDefaultBottomConstraint,
            
//            // 라벨의 위치 및 크기 제약 조건
//            // 이미지 뷰 아래에 위치하고, 좌우 여백을 설정
//            label.topAnchor.constraint(equalTo: prologueImageView.bottomAnchor, constant: 20),
//            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
//            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
//            label.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -150),

            // 탐험 시작 버튼의 위치 및 크기 제약 조건
            startExplorationButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            startExplorationButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -50),
            startExplorationButton.widthAnchor.constraint(equalToConstant: 180),
            startExplorationButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        // 버튼에 액션 메서드 연결
        skipButton.addTarget(self, action: #selector(didTapSkipButton), for: .touchUpInside)
        fastForwardButton.addTarget(self, action: #selector(didTapFastForwardButton), for: .touchUpInside)
        startExplorationButton.addTarget(self, action: #selector(didTapStartExplorationButton), for: .touchUpInside)
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

    // 탐험 시작 버튼이 눌렸을 때 호출되는 메서드
    @objc private func didTapStartExplorationButton() {
        onStartExplorationButtonTapped?()
    }

    // MARK: - Public Methods
    
    // 프롤로그 제목을 가운데에 보여주고 사라지는 애니메이션을 처리하는 메서드
    func showTitle(_ text: String, completion: @escaping () -> Void) {
        label.text = text
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold) // 제목 폰트 스타일
        label.alpha = 0
        
        // 제목 전용 제약 조건 활성화 (더 위로 올림)
        labelDefaultTopConstraint.isActive = false
        labelDefaultBottomConstraint.isActive = false
        labelTitleCenterYConstraint.isActive = true
         
         // 글자에 그림자 효과 추가
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 3.0
        label.layer.shadowOpacity = 0.8
        label.layer.shadowOffset = CGSize(width: 2, height: 2)
        label.layer.masksToBounds = false
        
        // 뷰의 레이아웃을 즉시 업데이트하여 제목이 위로 이동
        self.layoutIfNeeded()
        
        UIView.animate(withDuration: 1.5, delay: 0.5, options: .curveEaseInOut, animations: {
            self.label.alpha = 1.0 // 서서히 나타나기
        }, completion: { _ in
            UIView.animate(withDuration: 1.5, delay: 2.0, options: .curveEaseInOut, animations: {
                self.label.alpha = 0 // 잠시 후 서서히 사라지기
            }, completion: { _ in
                // 제목 애니메이션이 끝나면 제약 조건을 다시 본문용으로 되돌립니다.
                self.labelTitleCenterYConstraint.isActive = false
                self.labelDefaultTopConstraint.isActive = true
                self.labelDefaultBottomConstraint.isActive = true
                
                // 다음 텍스트가 나타나기 전에 레이아웃을 즉시 업데이트하여 위치를 조정합니다.
                self.layoutIfNeeded()
                
                completion() // 애니메이션 종료 후 클로저 실행
            })
        })
    }
    
    // 프롤로그 텍스트를 애니메이션과 함께 표시하고 사라지게 합니다.
    func showPrologueText(_ text: String, duration: TimeInterval, delay: TimeInterval, completion: @escaping () -> Void) {
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

    // 번쩍이는 효과 없이 이미지를 바로 교체하는 메서드
    func updateImage(name: String?) {
        if let name = name {
            self.prologueImageView.image = UIImage(named: name)
            self.prologueImageView.alpha = 1.0 // 이미지를 바로 표시
        } else {
            self.prologueImageView.image = nil
            self.prologueImageView.alpha = 0.0 // 이미지가 없으면 숨김
        }
    }
    
    // '넘어가기'와 '빨리 감기' 버튼의 표시 여부를 제어하는 메서드
    func showButtons(_ show: Bool) {
        skipButton.isHidden = !show
        fastForwardButton.isHidden = !show
    }

    // '탐험 시작' 버튼을 표시하고 다른 버튼들을 숨기는 메서드
    func showStartExplorationButton() {
        startExplorationButton.isHidden = false
        showButtons(false)
    }
}
