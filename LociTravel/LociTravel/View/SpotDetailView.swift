//
//  SpotDetailView.swift
//  LociTravel
//
//  Created by suji chae on 8/5/25.
//

// SpotDetailView.swift
import UIKit

class SpotDetailView: UIView {
    
    // MARK: - UI 요소들 정의
    
    let texturedBackgroundImageView = UIImageView()
    let spotNameLabel = UILabel()
    let backButton = UIButton(type: .system)
    let imageScrollView = UIScrollView()
    let pageControl = UIPageControl()
    private var imageViews: [UIImageView] = []
    let playPauseButton = UIButton(type: .system)
    let descriptionTextView = UITextView()
    
    // MARK: - 설명 텍스트 버튼 (이미지 버튼으로 변경)
    let previousDescriptionButton = UIButton(type: .system)
    let nextDescriptionButton = UIButton(type: .system)
    
    let descriptionBackgroundImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let darkerBrownColor = UIColor(red: 78/255, green: 52/255, blue: 28/255, alpha: 1.0)
        backgroundColor = darkerBrownColor
        addSubview(texturedBackgroundImageView)
        addSubview(spotNameLabel)
        addSubview(backButton)
        addSubview(imageScrollView)
        addSubview(pageControl)
        addSubview(playPauseButton)
        addSubview(descriptionBackgroundImageView)
        addSubview(descriptionTextView)
        addSubview(previousDescriptionButton)
        addSubview(nextDescriptionButton)
        
        texturedBackgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        spotNameLabel.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false
        descriptionBackgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        previousDescriptionButton.translatesAutoresizingMaskIntoConstraints = false
        nextDescriptionButton.translatesAutoresizingMaskIntoConstraints = false
        
        // MARK: - 1. 배경 이미지 뷰 설정
        texturedBackgroundImageView.image = UIImage(named: "old_paper_texture")
        texturedBackgroundImageView.contentMode = .scaleAspectFill
        texturedBackgroundImageView.clipsToBounds = true
        NSLayoutConstraint.activate([
            texturedBackgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            texturedBackgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            texturedBackgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            texturedBackgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        // MARK: - 2. 상단 스팟 이름 레이블 설정
        spotNameLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        spotNameLabel.textColor = .darkGray
        spotNameLabel.textAlignment = .center
        NSLayoutConstraint.activate([
            spotNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            spotNameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10)
        ])
        
        // MARK: - 3. 뒤로가기 버튼 설정
        if let originalImage = UIImage(named: "button_back_icon") {
            let tintedImage = originalImage.withRenderingMode(.alwaysTemplate)
            backButton.setImage(tintedImage, for: .normal)
        } else {
            print("Error: 'button_back_icon' image not found.")
        }
        backButton.tintColor = UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1.0)
        backButton.backgroundColor = .clear
        backButton.layer.cornerRadius = 0
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            backButton.centerYAnchor.constraint(equalTo: spotNameLabel.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        // MARK: - 4. 이미지 캐러셀 설정
        imageScrollView.isPagingEnabled = true
        imageScrollView.showsHorizontalScrollIndicator = false
        imageScrollView.showsVerticalScrollIndicator = false
        imageScrollView.clipsToBounds = true
        imageScrollView.layer.cornerRadius = 15
        
        NSLayoutConstraint.activate([
            imageScrollView.topAnchor.constraint(equalTo: spotNameLabel.bottomAnchor, constant: 20),
            imageScrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            imageScrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            imageScrollView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.35)
        ])
        
        // 페이지 컨트롤 설정
        pageControl.currentPageIndicatorTintColor = .brown
        pageControl.pageIndicatorTintColor = .lightGray
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            pageControl.topAnchor.constraint(equalTo: imageScrollView.bottomAnchor, constant: 10)
        ])
        
        // MARK: - 5. 이미지 캐러셀 플레이/스탑 버튼 설정
        playPauseButton.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
        playPauseButton.tintColor = UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1.0)
        playPauseButton.backgroundColor = UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 0.5)
        playPauseButton.layer.cornerRadius = 20
        playPauseButton.setPreferredSymbolConfiguration(.init(pointSize: 30), forImageIn: .normal)
        
        NSLayoutConstraint.activate([
            playPauseButton.trailingAnchor.constraint(equalTo: imageScrollView.trailingAnchor, constant: -10),
            playPauseButton.topAnchor.constraint(equalTo: imageScrollView.topAnchor, constant: 10),
            playPauseButton.widthAnchor.constraint(equalToConstant: 40),
            playPauseButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // MARK: - 6. 설명 텍스트 영역 설정 (수정된 부분)
        
        // 양피지 배경 이미지 뷰 설정
        descriptionBackgroundImageView.image = UIImage(named: "")
        if descriptionBackgroundImageView.image == nil {
            print("Error: description_background_parchment image not found in Assets.xcassets.")
        }
        
        descriptionBackgroundImageView.contentMode = .scaleToFill
        descriptionBackgroundImageView.clipsToBounds = true
        descriptionBackgroundImageView.layer.cornerRadius = 15
        
        NSLayoutConstraint.activate([
            descriptionBackgroundImageView.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 10),
            descriptionBackgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            descriptionBackgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            // 양피지 배경의 높이를 키우고 하단 여백을 확보
            descriptionBackgroundImageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        // 텍스트 뷰 설정 (양피지 내부 여백 추가)
        descriptionTextView.backgroundColor = .clear
        descriptionTextView.textColor = UIColor(red: 245/255, green: 245/255, blue: 220/255, alpha: 1.0)
        descriptionTextView.font = UIFont.systemFont(ofSize: 16)
        descriptionTextView.isEditable = false
        descriptionTextView.isSelectable = false
        descriptionTextView.textAlignment = .center
        descriptionTextView.layer.cornerRadius = 10
        descriptionTextView.isScrollEnabled = false
        
        NSLayoutConstraint.activate([
            // 양피지 배경 위아래로 여백을 남기도록 수정
            descriptionTextView.topAnchor.constraint(equalTo: descriptionBackgroundImageView.topAnchor, constant: 40),
            descriptionTextView.bottomAnchor.constraint(equalTo: descriptionBackgroundImageView.bottomAnchor, constant: -40),
            descriptionTextView.leadingAnchor.constraint(equalTo: descriptionBackgroundImageView.leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint(equalTo: descriptionBackgroundImageView.trailingAnchor, constant: -20)
        ])
        
        // MARK: - 이전/다음 이미지 버튼 설정 (수정된 부분)
        
        // 이전 버튼 설정
        if let prevImage = UIImage(named: "button_prev_description")?.withRenderingMode(.alwaysTemplate) {
            previousDescriptionButton.setImage(prevImage, for: .normal)
        }
        previousDescriptionButton.tintColor = UIColor(red: 245/255, green: 245/255, blue: 220/255, alpha: 1.0)
        

        previousDescriptionButton.backgroundColor = .clear
        
        // 다음 버튼 설정
        if let nextImage = UIImage(named: "button_next_description")?.withRenderingMode(.alwaysTemplate) {
            nextDescriptionButton.setImage(nextImage, for: .normal)
        }
        nextDescriptionButton.tintColor = UIColor(red: 245/255, green: 245/255, blue: 220/255, alpha: 1.0)
        nextDescriptionButton.backgroundColor = .clear
        
        // 버튼들을 양피지 배경 위에 배치
        NSLayoutConstraint.activate([
            previousDescriptionButton.centerYAnchor.constraint(equalTo: descriptionBackgroundImageView.centerYAnchor),
            previousDescriptionButton.leadingAnchor.constraint(equalTo: descriptionBackgroundImageView.leadingAnchor, constant: 10),
            previousDescriptionButton.widthAnchor.constraint(equalToConstant: 70),
            previousDescriptionButton.heightAnchor.constraint(equalToConstant: 70),
            
            nextDescriptionButton.centerYAnchor.constraint(equalTo: descriptionBackgroundImageView.centerYAnchor),
            nextDescriptionButton.trailingAnchor.constraint(equalTo: descriptionBackgroundImageView.trailingAnchor, constant: -10),
            nextDescriptionButton.widthAnchor.constraint(equalToConstant: 70),
            nextDescriptionButton.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    // MARK: - 데이터 설정 함수
    
    func configure(with spot: Spot) {
        spotNameLabel.text = spot.spotName
        setupImageCarousel(with: spot.spotImage)
    }
    
    private func setupImageCarousel(with imageNames: [String]) {
        imageViews.forEach { $0.removeFromSuperview() }
        imageViews.removeAll()
        
        var previousImageView: UIImageView?
        for (index, imageName) in imageNames.enumerated() {
            let imageView = UIImageView()
            imageView.image = UIImage(named: imageName)
            if imageView.image == nil {
                print("Error: Image '\(imageName)' not found in Assets.xcassets.")
                imageView.backgroundColor = .lightGray
            }
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageScrollView.addSubview(imageView)
            imageViews.append(imageView)
            
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: imageScrollView.topAnchor),
                imageView.bottomAnchor.constraint(equalTo: imageScrollView.bottomAnchor),
                imageView.widthAnchor.constraint(equalTo: imageScrollView.widthAnchor),
                imageView.heightAnchor.constraint(equalTo: imageScrollView.heightAnchor)
            ])
            
            if let previous = previousImageView {
                imageView.leadingAnchor.constraint(equalTo: previous.trailingAnchor).isActive = true
            } else {
                imageView.leadingAnchor.constraint(equalTo: imageScrollView.leadingAnchor).isActive = true
            }
            
            previousImageView = imageView
        }
        
        if let lastImageView = imageViews.last {
            imageScrollView.trailingAnchor.constraint(equalTo: lastImageView.trailingAnchor).isActive = true
        }
        
        pageControl.numberOfPages = imageNames.count
        pageControl.currentPage = 0
    }
}


#Preview {
SpotDetailView()
}
