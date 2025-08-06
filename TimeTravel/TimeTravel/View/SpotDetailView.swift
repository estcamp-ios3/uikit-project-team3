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
class SpotDetailView: UIView, UIScrollViewDelegate {
    
    // MARK: - UI Components
    
    // 이미지를 좌우로 스크롤하여 볼 수 있는 스크롤뷰
    let imageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true // 페이지 단위로 스크롤되도록 설정
        scrollView.showsHorizontalScrollIndicator = false//가로 스크롤 바 숨김
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    // 현재 보고 있는 이미지의 위치를 점(Dot)으로 보여주는 페이지 컨트롤
    let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = .white //.black
        pageControl.pageIndicatorTintColor = .lightGray
        return pageControl
    }()
    
    // 자동 스크롤 시작/정지 버튼
    let playPauseButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .large)
        button.setImage(UIImage(systemName: "pause.circle.fill", withConfiguration: config), for: .normal)
        button.tintColor = .white
        button.alpha = 0.7
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        label.font = UIFont.systemFont(ofSize: 24)
        label.numberOfLines = 0
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
    
    // 이미지 이름 배열을 저장할 변수
    var imageNames: [String] = []

    // MARK: - 텍스트 컨테이너 드래그 관련 프로퍼티
    private var panGesture: UIPanGestureRecognizer?
    private var textContainerTopConstraint: NSLayoutConstraint!
    private var isExpanded = false
    
    // MARK: - 이미지 자동 스크롤 관련 프로퍼티
    private var timer: Timer?
    private var isAutoScrolling = true
    
    // MARK: - Initializers
    
    // 코드로 뷰를 생성할 때 호출되는 초기화 메서드
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        startAutoScroll()
    }
    
    // 스토리보드 또는 XIB로 뷰를 생성할 때 호출되는 초기화 메서드
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    
    // 모든 UI 컴포넌트와 레이아웃을 설정하는 메서드
    private func setupUI() {
        self.backgroundColor = .white
        
        // 뷰 계층 구조 설정
        self.addSubview(imageScrollView)
        self.addSubview(textContainerView)
        self.addSubview(pageControl)
        self.addSubview(playPauseButton)
        
        // 텍스트 컨테이너 내부 뷰 계층 구조
        textContainerView.addSubview(grabberView)
        textContainerView.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // MARK: - 텍스트 및 레이아웃 관련
        
        // 1. 텍스트 컨테이너 드래그 가능하도록 GestureRecognizer 추가
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        textContainerView.addGestureRecognizer(panGesture!)
        
        // 2. 텍스트 박스 투명도
        textContainerView.backgroundColor = .systemBackground.withAlphaComponent(1.0)
        
        // 이미지 스크롤뷰의 델리게이트 설정
        imageScrollView.delegate = self
        
        // 재생/정지 버튼 액션 연결
        playPauseButton.addTarget(self, action: #selector(toggleAutoScroll), for: .touchUpInside)

        // 메인 레이아웃 설정
        textContainerTopConstraint = textContainerView.topAnchor.constraint(equalTo: imageScrollView.bottomAnchor)
        textContainerTopConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            imageScrollView.topAnchor.constraint(equalTo: self.topAnchor),
            imageScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageScrollView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.37),

            textContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            textContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            textContainerView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])

        // 페이지 컨트롤, 재생/정지 버튼 레이아웃
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: imageScrollView.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: imageScrollView.bottomAnchor, constant: -10),
            playPauseButton.trailingAnchor.constraint(equalTo: imageScrollView.trailingAnchor, constant: -16),
            playPauseButton.bottomAnchor.constraint(equalTo: imageScrollView.bottomAnchor, constant: -10),
            playPauseButton.widthAnchor.constraint(equalToConstant: 44),
            playPauseButton.heightAnchor.constraint(equalToConstant: 44)
        ])

        // 그랩바와 스크롤뷰 레이아웃
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

        // contentView 레이아웃
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])

        // MARK: - 컨텐츠 뷰 내부 레이아웃 (요청사항에 맞게 재구성)
        let headerStack = UIStackView(arrangedSubviews: [siteNameLabel, startButton])
        headerStack.axis = .horizontal
        headerStack.distribution = .equalSpacing
        headerStack.alignment = .center
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(headerStack)

        let detailTitle = UILabel()
        detailTitle.text = "상세안내"
        detailTitle.font = UIFont.boldSystemFont(ofSize: 18)
        detailTitle.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(detailTitle)
        
        let detailBox = UIView()
        detailBox.backgroundColor = UIColor.systemGray6
        detailBox.layer.cornerRadius = 12
        detailBox.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(detailBox)
        detailBox.addSubview(descriptionLabel)
        detailBox.addSubview(moreButton)

        let visitHeader = UIStackView(arrangedSubviews: [visitorInfoTitleLabel, navigateButton])
        visitHeader.axis = .horizontal
        visitHeader.distribution = .equalSpacing
        visitHeader.alignment = .center
        visitHeader.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(visitHeader)

        let visitorBox = UIView()
        visitorBox.backgroundColor = UIColor.systemGray6
        visitorBox.layer.cornerRadius = 12
        visitorBox.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(visitorBox)
        visitorBox.addSubview(visitorInfoDetailLabel)

        // 재구성된 레이아웃 제약
        NSLayoutConstraint.activate([
            headerStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            headerStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            headerStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            startButton.heightAnchor.constraint(equalToConstant: 44),
            startButton.widthAnchor.constraint(equalToConstant: 120),

            detailTitle.topAnchor.constraint(equalTo: headerStack.bottomAnchor, constant: 20),
            detailTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            detailBox.topAnchor.constraint(equalTo: detailTitle.bottomAnchor, constant: 10),
            detailBox.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            detailBox.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            descriptionLabel.topAnchor.constraint(equalTo: detailBox.topAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: detailBox.leadingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: detailBox.trailingAnchor, constant: -10),
            moreButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5),
            moreButton.trailingAnchor.constraint(equalTo: detailBox.trailingAnchor, constant: -10),
            moreButton.bottomAnchor.constraint(equalTo: detailBox.bottomAnchor, constant: -10),

            visitHeader.topAnchor.constraint(equalTo: detailBox.bottomAnchor, constant: 20),
            visitHeader.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            visitHeader.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            navigateButton.heightAnchor.constraint(equalToConstant: 44),
            navigateButton.widthAnchor.constraint(equalToConstant: 120),

            visitorBox.topAnchor.constraint(equalTo: visitHeader.bottomAnchor, constant: 10),
            visitorBox.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            visitorBox.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            visitorInfoDetailLabel.topAnchor.constraint(equalTo: visitorBox.topAnchor, constant: 10),
            visitorInfoDetailLabel.leadingAnchor.constraint(equalTo: visitorBox.leadingAnchor, constant: 10),
            visitorInfoDetailLabel.trailingAnchor.constraint(equalTo: visitorBox.trailingAnchor, constant: -10),
            visitorInfoDetailLabel.bottomAnchor.constraint(equalTo: visitorBox.bottomAnchor, constant: -10),

            visitorBox.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Data Binding
    
    func setupImages(with imageNames: [String]) {
        self.imageNames = imageNames
        pageControl.numberOfPages = imageNames.count
        updateScrollViewContent()
    }
    
    func updateScrollViewContent() {
        imageScrollView.subviews.forEach { $0.removeFromSuperview() }
        
        let viewWidth = self.bounds.width
        guard viewWidth > 0 else { return }
        
        for (index, imageName) in imageNames.enumerated() {
            let imageView = UIImageView()
            imageView.image = UIImage(named: imageName)
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageScrollView.addSubview(imageView)
            
            // 이미지뷰의 레이아웃 설정
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: viewWidth),
                imageView.heightAnchor.constraint(equalTo: imageScrollView.heightAnchor),
                imageView.topAnchor.constraint(equalTo: imageScrollView.topAnchor),
                imageView.leadingAnchor.constraint(equalTo: imageScrollView.leadingAnchor, constant: CGFloat(index) * viewWidth),
            ])
            
            if index == imageNames.count - 1 {
                imageView.trailingAnchor.constraint(equalTo: imageScrollView.trailingAnchor).isActive = true
            }
        }
        
        imageScrollView.contentSize = CGSize(width: viewWidth * CGFloat(imageNames.count), height: 0)
    }

    // MARK: - 드래그 제스처 처리 함수
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        let threshold: CGFloat = 100.0

        if gesture.state == .ended {
            if translation.y < -threshold {
                expandTextContainer()
            } else if translation.y > threshold {
                collapseTextContainer()
            }
        }
    }

    private func expandTextContainer() {
        guard !isExpanded else { return }
        isExpanded = true
        textContainerTopConstraint.constant = -self.bounds.height * 0.2
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
            // 텍스트 박스가 올라올 때 버튼과 페이지 컨트롤 숨기기
            self.playPauseButton.alpha = 0
            self.pageControl.alpha = 0
        }
    }

    private func collapseTextContainer() {
        guard isExpanded else { return }
        isExpanded = false
        textContainerTopConstraint.constant = 0
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
            // 텍스트 박스가 내려갈 때 버튼과 페이지 컨트롤 다시 보이게 하기
            self.playPauseButton.alpha = 0.7
            self.pageControl.alpha = 1.0
        }
    }

    // MARK: - 이미지 자동 스크롤 관련 함수
    @objc private func startAutoScroll() {
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(scrollToNextPage), userInfo: nil, repeats: true)
    }

    @objc private func stopAutoScroll() {
        timer?.invalidate()
        timer = nil
    }

    @objc private func scrollToNextPage() {
        let contentOffset = imageScrollView.contentOffset.x
        let pageWidth = imageScrollView.frame.size.width
        let currentPage = Int(contentOffset / pageWidth)

        let nextPage = (currentPage + 1) % imageNames.count
        let newContentOffset = CGPoint(x: pageWidth * CGFloat(nextPage), y: 0)

        UIView.animate(withDuration: 0.5) {
            self.imageScrollView.contentOffset = newContentOffset
        }
        pageControl.currentPage = nextPage
    }
    
    // 플레이/스탑 버튼 기능 구현
    @objc private func toggleAutoScroll() {
        isAutoScrolling.toggle()
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .large)
        if isAutoScrolling {
            startAutoScroll()
            playPauseButton.setImage(UIImage(systemName: "pause.circle.fill", withConfiguration: config), for: .normal)
        } else {
            stopAutoScroll()
            playPauseButton.setImage(UIImage(systemName: "play.circle.fill", withConfiguration: config), for: .normal)
        }
    }

    // MARK: - UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == imageScrollView {
            let pageIndex = round(scrollView.contentOffset.x/scrollView.frame.width)
            pageControl.currentPage = Int(pageIndex)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == imageScrollView {
            if isAutoScrolling {
                stopAutoScroll()
                let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .large)
                playPauseButton.setImage(UIImage(systemName: "play.circle.fill", withConfiguration: config), for: .normal)
            }
        }
    }
}

// MARK: - UIView Extension

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
