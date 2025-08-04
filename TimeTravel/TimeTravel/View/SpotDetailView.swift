//
//  SpotDetailView.swift
//  TimeTravel
//
//  Created by chohoseo on 7/30/25.
//

import UIKit

// 이 클래스는 순수하게 뷰(UI) 역할을 담당합니다.
// 화면에 보이는 모든 UI 컴포넌트와 그 레이아웃을 정의합니다.
// 데이터나 비즈니스 로직은 포함하지 않습니다.
class SpotDetailView: UIView {
    
    // MARK: - UI Components
    
    // 이미지를 좌우로 스크롤하여 볼 수 있는 스크롤뷰
    let imageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true // 페이지 단위로 스크롤되도록 설정
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    // 현재 보고 있는 이미지의 위치를 점(Dot)으로 보여주는 페이지 컨트롤
    let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = .lightGray
        return pageControl
    }()
    
    // 상세 정보 텍스트가 담기는 컨테이너 뷰. 위로 드래그하여 확장 가능합니다.
    let textContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // 상단 모서리만 둥글게 처리
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // 드래그 가능한 핸들(grabber) 역할의 뷰
    let grabberView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 2.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // 텍스트 컨테이너 내부에서 스크롤을 담당하는 스크롤뷰
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    // 텍스트 컨테이너의 모든 내용을 담는 컨텐츠 뷰
    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let siteNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let navigateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("지도 바로가기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0.2, green: 0.5, blue: 0.8, alpha: 1.0)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // 장소에 대한 상세 설명을 표시하는 레이블
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.numberOfLines = 7 // 초기에는 7줄만 표시
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // descriptionLabel의 내용이 길 때 전체 내용을 볼 수 있도록 하는 버튼
    let moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("...더보기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let visitorInfoTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "방문안내"
        return label
    }()
    
    let visitorInfoDetailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("퀘스트 시작", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 1.0, green: 0.4, blue: 0.6, alpha: 1.0)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initializers
    
    // 코드로 뷰를 생성할 때 호출되는 초기화 메서드
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    // 스토리보드 또는 XIB로 뷰를 생성할 때 호출되는 초기화 메서드
    // UIView를 상속받는 클래스에는 이 두 초기화 메서드가 반드시 필요합니다.
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - UI Setup
    
    // 모든 UI 컴포넌트와 레이아웃을 설정하는 메서드
    private func setupUI() {
        self.backgroundColor = .white
        
        // 뷰 계층 구조 설정
        self.addSubview(imageScrollView)
        self.addSubview(textContainerView)
        
        // Auto Layout 설정
        NSLayoutConstraint.activate([
            imageScrollView.topAnchor.constraint(equalTo: self.topAnchor),
            imageScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageScrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        textContainerView.addSubview(grabberView)
        textContainerView.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            grabberView.topAnchor.constraint(equalTo: textContainerView.topAnchor, constant: 10),
            grabberView.centerXAnchor.constraint(equalTo: textContainerView.centerXAnchor),
            grabberView.widthAnchor.constraint(equalToConstant: 40),
            grabberView.heightAnchor.constraint(equalToConstant: 5),
            
            scrollView.topAnchor.constraint(equalTo: grabberView.bottomAnchor, constant: 10),
            scrollView.leadingAnchor.constraint(equalTo: textContainerView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: textContainerView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: textContainerView.bottomAnchor)
        ])
        
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
        
        contentView.addSubview(siteNameLabel)
        contentView.addSubview(navigateButton)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(moreButton)
        contentView.addSubview(visitorInfoTitleLabel)
        contentView.addSubview(visitorInfoDetailLabel)
        contentView.addSubview(startButton)

        NSLayoutConstraint.activate([
            siteNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            siteNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            siteNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            navigateButton.topAnchor.constraint(equalTo: siteNameLabel.bottomAnchor, constant: 10),
            navigateButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            navigateButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            navigateButton.heightAnchor.constraint(equalToConstant: 50),
            
            descriptionLabel.topAnchor.constraint(equalTo: navigateButton.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            moreButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5),
            moreButton.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),
            
            visitorInfoTitleLabel.topAnchor.constraint(equalTo: moreButton.bottomAnchor, constant: 20),
            visitorInfoTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            visitorInfoDetailLabel.topAnchor.constraint(equalTo: visitorInfoTitleLabel.bottomAnchor, constant: 5),
            visitorInfoDetailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            visitorInfoDetailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            startButton.topAnchor.constraint(equalTo: visitorInfoDetailLabel.bottomAnchor, constant: 40),
            startButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            startButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            startButton.heightAnchor.constraint(equalToConstant: 50),
            startButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
        
        // 텍스트 컨테이너의 초기 높이 설정
        let initialTextHeight: CGFloat = UIScreen.main.bounds.height * 0.5
        
        let textContainerHeightConstraint = textContainerView.heightAnchor.constraint(equalToConstant: initialTextHeight)
        NSLayoutConstraint.activate([
            textContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            textContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            textContainerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            textContainerHeightConstraint
        ])
    }
}
