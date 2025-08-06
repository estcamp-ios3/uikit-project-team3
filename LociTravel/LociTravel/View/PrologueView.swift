//
//  PrologueView.swift
//  LociTravel
//
//  Created by dkkim on 8/6/25.
//

import UIKit


class PrologueView: UIView {
    let backgroundImageView = UIImageView()
    let skipButton = UIButton(type: .system)
    
    //스크롤뷰 테스트
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = false // 사용자 스크롤 방지
        return scrollView
    }()
    
    //스크롤뷰 안에 내용
    let prologueLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.font = .systemFont(ofSize: 18)
        lbl.textColor = .black
        lbl.text = """
                제버려진 왕의 마지막 염원
                고조선의 마지막 왕 준왕은 믿었던 위만에게 배신당해 홀로 익산 땅으로 도망친다. 그는 죽음을 앞두고, 목걸이를 쪼개며 마지막 염원을 남긴다.
                
                "이 목걸이가 합쳐지는 날, 이 땅에 피가 아닌 평화의 염원을 이을 왕이 통치하는 시대가 올것이다."
                
                목걸이의 한 조각은 한 고승에 의해 서동의 어머니에게 전해진다. 고승은 울고 있는 어린 서동을 안고 있는 어머니에게 목걸이를 건네며, 훗날 이 아이가 평화의 시대를 열 운명을 지닌 아이가 될 것임을 암시한다.
                
                다른 한 조각은 다른 고승에 의해 신라의 왕과 왕비에게 전달된다. 고승은 갓 태어난 선화공주를 안고 행복해하는 두 사람에게 목걸이를 건네며, 이 아이가 평화의 염원을 잇는 중요한 존재가 될 것임을 예고한다.
                """
        return lbl
    }()
    
    private var labelTop: NSLayoutConstraint!
    
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        
        // 뷰 계층 구조 설정
        addSubview(backgroundImageView)
        addSubview(scrollView)
        scrollView.addSubview(prologueLabel)
        addSubview(skipButton)
       
        
        
        // 모든 뷰에 Auto Layout 사용 설정 (필수!)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        // 배경 이미지 설정
        backgroundImageView.image = UIImage(named: "home_background_illustration")
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        // 스킵 버튼 설정
        skipButton.setTitle("넘어가기", for: .normal)
        skipButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        skipButton.backgroundColor = .systemBlue
        skipButton.setTitleColor(.white, for: .normal)
        skipButton.layer.cornerRadius = 25
        NSLayoutConstraint.activate([
            skipButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            skipButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            skipButton.widthAnchor.constraint(equalToConstant: 100),
            skipButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // 스크롤 뷰 설정
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        // 프롤로그 라벨 설정
        NSLayoutConstraint.activate([
        prologueLabel.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 20),
        prologueLabel.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -20)
        
        ])
        
        // 초기 위치는 뷰 맨 아래
        labelTop = prologueLabel.topAnchor.constraint(equalTo: scrollView.bottomAnchor)
        labelTop.isActive = true
        
        //콘텐츠 끝(bottom) 제약 추가
        prologueLabel.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor).isActive = true
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 컨텐츠 사이즈 갱신
        let maxW = bounds.width - 40
        let size = prologueLabel.sizeThatFits(CGSize(width: maxW, height: .greatestFiniteMagnitude))
        scrollView.contentSize = CGSize(width: bounds.width, height: bounds.height + size.height)
    }
    func startCreditsAnimation() {
        layoutIfNeeded()
        // 최종 오프셋
        let endY = scrollView.contentSize.height - scrollView.bounds.height
        UIView.animate(withDuration: TimeInterval(scrollView.contentSize.height / 30),
                       delay: 1.0,
                       options: .curveLinear) {
            self.scrollView.setContentOffset(CGPoint(x: 0, y: endY), animated: false)
        }
    
    }

}
