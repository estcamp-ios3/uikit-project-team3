//
//  SpotDetailView.swift
//  LociTravel
//
//  Created by suji chae on 8/5/25.
//

import UIKit

class SpotDetailView: UIView {
    
    // MARK: - UI 요소들 정의
    
    // 1. 배경 이미지 뷰 (질감 있는 갈색)
    let texturedBackgroundImageView = UIImageView()
    
    // 2. 상단 스팟 이름 레이블
    let spotNameLabel = UILabel()
    
    // 3. 뒤로가기 버튼
    let backButton = UIButton(type: .system)
    
    // 4. 이미지 캐러셀 (자동 스크롤 및 닷 표시)
    let imageScrollView = UIScrollView()
    let pageControl = UIPageControl()
    private var imageViews: [UIImageView] = [] // 캐러셀에 들어갈 이미지 뷰들
    
    // 5. 이미지 캐러셀 플레이/스탑 버튼
    let playPauseButton = UIButton(type: .system)
    
    // 6. 설명 텍스트 영역
    let descriptionTextView = UITextView()
    let nextDescriptionButton = UIButton(type: .system) // 설명 다음 페이지 버튼

    // MARK: - 설명 텍스트 배경 이미지 뷰 추가
    let descriptionBackgroundImageView = UIImageView()
    
    // MARK: - 초기화 및 UI 설정
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white // 기본 배경색
        
        // 뷰 계층 구조 설정 (순서 중요: 배경 -> 다른 요소들)
        // 배경 이미지가 가장 아래에 위치하도록 먼저 추가합니다.
        addSubview(texturedBackgroundImageView)
        // 그 위에 다른 UI 요소들을 추가합니다.
        addSubview(spotNameLabel)
        addSubview(backButton)
        addSubview(imageScrollView)
        addSubview(pageControl)
        addSubview(playPauseButton) // 플레이/스탑 버튼 추가
        
        // 설명 텍스트 배경 이미지를 텍스트 뷰보다 먼저 추가하여 뒤에 오도록 합니다.
        addSubview(descriptionBackgroundImageView)
        addSubview(descriptionTextView)
        addSubview(nextDescriptionButton)
        
        // 모든 뷰에 Auto Layout 사용 설정 (필수!)
        texturedBackgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        spotNameLabel.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false // Auto Layout 설정
        descriptionBackgroundImageView.translatesAutoresizingMaskIntoConstraints = false // 설명 배경 이미지 Auto Layout 설정
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        nextDescriptionButton.translatesAutoresizingMaskIntoConstraints = false
        
        // MARK: - 1. 배경 이미지 뷰 설정 (질감 있는 갈색)
        // "old_paper_texture"는 Assets.xcassets에 추가해야 할 질감 이미지 파일명입니다.
        texturedBackgroundImageView.image = UIImage(named: "old_paper_texture") // 갈색 질감 이미지
        texturedBackgroundImageView.contentMode = .scaleAspectFill // 이미지가 뷰를 꽉 채우도록 설정
        texturedBackgroundImageView.clipsToBounds = true // 뷰 경계를 벗어나는 부분은 잘라냅니다.
        NSLayoutConstraint.activate([
            texturedBackgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            texturedBackgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            texturedBackgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            texturedBackgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        // MARK: - 2. 상단 스팟 이름 레이블 설정 (가운데)
        spotNameLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        spotNameLabel.textColor = .darkGray // 이미지처럼 어두운 색상
        spotNameLabel.textAlignment = .center // 가운데 정렬
        NSLayoutConstraint.activate([
            spotNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor), // 가로 중앙
            spotNameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10) // 상단 안전 영역에서 10포인트 아래
        ])
        
        // MARK: - 3. 뒤로가기 버튼 설정 (왼쪽 상단으로 변경, 가시성 확보)
        // "button_back_icon" 이미지를 사용하도록 변경
        backButton.setImage(UIImage(named: "button_back_icon"), for: .normal) // 커스텀 이미지 사용
        backButton.tintColor = UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1.0) // 브라운색으로 변경
        backButton.backgroundColor = .clear // 배경색 제거 (이미지 자체의 배경을 사용)
        backButton.layer.cornerRadius = 0 // 둥근 모서리 제거 (이미지 자체의 형태를 사용)
        // setPreferredSymbolConfiguration은 시스템 심볼에만 적용되므로 제거
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16), // 왼쪽에서 16포인트 안쪽
            backButton.centerYAnchor.constraint(equalTo: spotNameLabel.centerYAnchor), // 스팟 이름과 수직 중앙 정렬
            backButton.widthAnchor.constraint(equalToConstant: 44), // 너비 고정
            backButton.heightAnchor.constraint(equalToConstant: 44) // 높이 고정
        ])
        
        // MARK: - 4. 이미지 캐러셀 설정 (자동 스크롤 및 닷 표시)
        imageScrollView.isPagingEnabled = true // 페이지 단위로 스크롤되도록 설정
        imageScrollView.showsHorizontalScrollIndicator = false // 가로 스크롤 인디케이터 숨김
        imageScrollView.showsVerticalScrollIndicator = false // 세로 스크롤 인디케이터 숨김
        imageScrollView.clipsToBounds = true // 이미지 스크롤 뷰 경계를 벗어나는 부분은 잘라냅니다.
        imageScrollView.layer.cornerRadius = 15 // 둥근 모서리
        
        NSLayoutConstraint.activate([
            imageScrollView.topAnchor.constraint(equalTo: spotNameLabel.bottomAnchor, constant: 20), // 스팟 이름 아래 20포인트
            imageScrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20), // 왼쪽에서 20포인트 안쪽
            imageScrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20), // 오른쪽에서 20포인트 안쪽
            imageScrollView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.35) // 화면 높이의 35%
        ])
        
        // 페이지 컨트롤 설정 (닷 표시)
        pageControl.currentPageIndicatorTintColor = .brown // 현재 페이지 점 색상
        pageControl.pageIndicatorTintColor = .lightGray // 다른 페이지 점 색상
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor), // 가로 중앙
            pageControl.topAnchor.constraint(equalTo: imageScrollView.bottomAnchor, constant: 10) // 이미지 스크롤 뷰 아래 10포인트
        ])
        
        // MARK: - 5. 이미지 캐러셀 플레이/스탑 버튼 설정
        playPauseButton.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal) // 초기 아이콘은 '일시정지'
        playPauseButton.tintColor = UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1.0) // 브라운색으로 변경
        playPauseButton.backgroundColor = UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 0.5) // 반투명 브라운색 배경
        playPauseButton.layer.cornerRadius = 20
        playPauseButton.setPreferredSymbolConfiguration(.init(pointSize: 30), forImageIn: .normal)
        
        NSLayoutConstraint.activate([
            playPauseButton.trailingAnchor.constraint(equalTo: imageScrollView.trailingAnchor, constant: -10), // 이미지 스크롤 뷰 오른쪽 상단
            playPauseButton.topAnchor.constraint(equalTo: imageScrollView.topAnchor, constant: 10),
            playPauseButton.widthAnchor.constraint(equalToConstant: 40),
            playPauseButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // MARK: - 6. 설명 텍스트 영역 설정 (페이지네이션)
        // 설명 배경 이미지 뷰 설정
        descriptionBackgroundImageView.image = UIImage(named: "description_background_parchment") // 새로운 배경 이미지
        // 이미지 로드 실패 시 디버깅 메시지 추가
        if descriptionBackgroundImageView.image == nil {
            print("Error: description_background_parchment image not found in Assets.xcassets.")
        }

        descriptionBackgroundImageView.contentMode = .scaleToFill // 뷰에 맞춰 늘리거나 줄임
        descriptionBackgroundImageView.clipsToBounds = true
        descriptionBackgroundImageView.layer.cornerRadius = 15 // 텍스트 뷰와 동일한 둥근 모서리
        
        NSLayoutConstraint.activate([
            descriptionBackgroundImageView.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 10), // 페이지 컨트롤 아래 10포인트
            descriptionBackgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20), // 왼쪽에서 20포인트 안쪽
            descriptionBackgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20), // 오른쪽에서 20포인트 안쪽
            descriptionBackgroundImageView.bottomAnchor.constraint(equalTo: nextDescriptionButton.topAnchor, constant: -10) // 다음 버튼 위 10포인트
        ])

        // 텍스트 뷰 배경색을 투명으로 유지 (불투명 박스 제거)
        descriptionTextView.backgroundColor = .clear // 배경 투명
        descriptionTextView.textColor = .black
        descriptionTextView.font = UIFont.systemFont(ofSize: 16)
        descriptionTextView.isEditable = false // 편집 불가능
        descriptionTextView.isSelectable = false // 선택 불가능
        descriptionTextView.textAlignment = .center // 가운데 정렬
        descriptionTextView.layer.cornerRadius = 10 // 텍스트 뷰에도 둥근 모서리 추가
        
        // ⭐️ 텍스트 뷰 스크롤 기능 비활성화
        descriptionTextView.isScrollEnabled = false
        
        NSLayoutConstraint.activate([
            // 설명 배경 이미지 뷰의 내부 여백을 고려하여 텍스트 뷰 배치
            descriptionTextView.topAnchor.constraint(equalTo: descriptionBackgroundImageView.topAnchor, constant: 20),
            descriptionTextView.bottomAnchor.constraint(equalTo: descriptionBackgroundImageView.bottomAnchor, constant: -20),
            descriptionTextView.leadingAnchor.constraint(equalTo: descriptionBackgroundImageView.leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint(equalTo: descriptionBackgroundImageView.trailingAnchor, constant: -20)
        ])
        
        // 설명 다음 페이지 버튼 설정
        nextDescriptionButton.setTitle("다음", for: .normal)
        nextDescriptionButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        nextDescriptionButton.backgroundColor = UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1.0) // 갈색 계열
        nextDescriptionButton.setTitleColor(.white, for: .normal)
        nextDescriptionButton.layer.cornerRadius = 25
        NSLayoutConstraint.activate([
            nextDescriptionButton.centerXAnchor.constraint(equalTo: centerXAnchor), // 가로 중앙
            nextDescriptionButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30), // 하단 안전 영역에서 30포인트 위
            nextDescriptionButton.widthAnchor.constraint(equalToConstant: 150), // 너비 고정
            nextDescriptionButton.heightAnchor.constraint(equalToConstant: 50) // 높이 고정
        ])
    }
    
    // MARK: - 데이터 설정 함수
    
    // Spot 데이터를 받아와 뷰를 구성하는 함수
    func configure(with spot: Spot) {
        spotNameLabel.text = spot.spotName // 스팟 이름 설정
        setupImageCarousel(with: spot.spotImage) // 이미지 캐러셀 설정
        // descriptionTextView.text는 SpotDetailViewController에서 직접 설정합니다.
    }
    
    // 이미지 캐러셀 설정 함수
    private func setupImageCarousel(with imageNames: [String]) {
        // 기존 이미지 뷰들을 모두 제거하여 중복 추가 방지
        imageViews.forEach { $0.removeFromSuperview() }
        imageViews.removeAll()
        
        // 새로운 이미지 뷰들을 추가
        var previousImageView: UIImageView?
        for (index, imageName) in imageNames.enumerated() {
            let imageView = UIImageView()
            imageView.image = UIImage(named: imageName) // 이미지 로드 시도
            if imageView.image == nil {
                print("Error: Image '\(imageName)' not found in Assets.xcassets.")
                // 대체 이미지 설정 또는 오류 처리
                imageView.backgroundColor = .lightGray // 이미지를 찾지 못했을 때 회색 배경
            }
            imageView.contentMode = .scaleAspectFill // 화질 유지 (이미지가 뷰를 꽉 채우고 비율 유지)
            imageView.clipsToBounds = true // 뷰 경계를 벗어나는 부분은 잘라냅니다.
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageScrollView.addSubview(imageView)
            imageViews.append(imageView)
            
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: imageScrollView.topAnchor),
                imageView.bottomAnchor.constraint(equalTo: imageScrollView.bottomAnchor),
                imageView.widthAnchor.constraint(equalTo: imageScrollView.widthAnchor), // 스크롤 뷰의 너비와 동일
                imageView.heightAnchor.constraint(equalTo: imageScrollView.heightAnchor) // 스크롤 뷰의 높이와 동일
            ])
            
            if let previous = previousImageView {
                // 이전 이미지 뷰의 오른쪽에 현재 이미지 뷰를 배치
                imageView.leadingAnchor.constraint(equalTo: previous.trailingAnchor).isActive = true
            } else {
                // 첫 번째 이미지 뷰는 스크롤 뷰의 왼쪽에 배치
                imageView.leadingAnchor.constraint(equalTo: imageScrollView.leadingAnchor).isActive = true
            }
            
            previousImageView = imageView
        }
        
        // 마지막 이미지 뷰가 스크롤 뷰의 contentSize를 결정하도록 설정
        if let lastImageView = imageViews.last {
            imageScrollView.trailingAnchor.constraint(equalTo: lastImageView.trailingAnchor).isActive = true
        }
        
        pageControl.numberOfPages = imageNames.count // 페이지 컨트롤의 총 페이지 수 설정
        pageControl.currentPage = 0 // 초기 페이지는 0 (첫 번째 이미지)
    }
}
