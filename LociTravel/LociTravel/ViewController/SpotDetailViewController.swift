//
//  SpotDetailViewController.swift
//  LociTravel
//
//  Created by suji chae on 8/5/25.
//

import UIKit

class SpotDetailViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - Properties
    
    // UI 요소를 관리하는 커스텀 뷰
    private let spotDetailView = SpotDetailView()
    
    // RecordBookViewController에서 직접 전달받을 Spot 객체
    var currentSpot: Spot?
    
    // 긴 설명을 페이지로 나누어 저장할 배열
    private var descriptionPages: [String] = []
    private var currentDescriptionPageIndex = 0
    
    // 이미지 캐러셀 자동 스크롤을 위한 타이머
    private var imageScrollTimer: Timer?
    private var isAutoScrolling = true
    
    // MARK: - View Lifecycle
    
    // 뷰 컨트롤러의 루트 뷰를 커스텀 뷰로 설정
    override func loadView() {
        view = spotDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 네비게이션 바 숨김
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // 뷰에 데이터 바인딩 및 UI 초기 설정
        loadSpotData()
        setupButtonActions()
        setupImageCarouselDelegate()
        setupDescriptionPagination()
        startImageAutoScroll()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 화면이 사라질 때 타이머 중지
        stopImageAutoScroll()
    }
    
    // MARK: - Data Loading
    
    // 전달받은 Spot 객체로 뷰를 구성
    private func loadSpotData() {
        guard let spot = self.currentSpot else {
            print("Error: Spot data not found.")
            navigationController?.popViewController(animated: true)
            return
        }
        spotDetailView.configure(with: spot)
    }
    
    // MARK: - Button Actions
    
    // 버튼 액션 타겟 설정
    private func setupButtonActions() {
        spotDetailView.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        spotDetailView.previousDescriptionButton.addTarget(self, action: #selector(didTapPreviousDescriptionButton), for: .touchUpInside)
        spotDetailView.nextDescriptionButton.addTarget(self, action: #selector(didTapNextDescriptionButton), for: .touchUpInside)
        spotDetailView.playPauseButton.addTarget(self, action: #selector(didTapPlayPauseButton), for: .touchUpInside)
    }
    
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Image Carousel Auto-Scroll
    
    private func setupImageCarouselDelegate() {
        spotDetailView.imageScrollView.delegate = self
    }
    
    private func startImageAutoScroll() {
        imageScrollTimer?.invalidate()
        imageScrollTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(scrollToNextImage), userInfo: nil, repeats: true)
        isAutoScrolling = true
        spotDetailView.playPauseButton.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
    }
    
    private func stopImageAutoScroll() {
        imageScrollTimer?.invalidate()
        imageScrollTimer = nil
        isAutoScrolling = false
        spotDetailView.playPauseButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
    }
    
    @objc private func scrollToNextImage() {
        let currentPage = spotDetailView.pageControl.currentPage
        let numberOfPages = spotDetailView.pageControl.numberOfPages
        
        guard numberOfPages > 1 else { return }
        
        let nextPage = (currentPage + 1) % numberOfPages
        let offsetX = CGFloat(nextPage) * spotDetailView.imageScrollView.frame.width
        spotDetailView.imageScrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        
        spotDetailView.pageControl.currentPage = nextPage
    }
    
    @objc private func didTapPlayPauseButton() {
        if isAutoScrolling {
            stopImageAutoScroll()
        } else {
            startImageAutoScroll()
        }
    }
    
    // MARK: - UIScrollViewDelegate (for Image Carousel)
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == spotDetailView.imageScrollView {
            guard scrollView.frame.width > 0 else { return }
            let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
            spotDetailView.pageControl.currentPage = Int(pageIndex)
        }    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == spotDetailView.imageScrollView {
            stopImageAutoScroll()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == spotDetailView.imageScrollView {
            startImageAutoScroll()
        }
    }
    
    // MARK: - Description Text Pagination
    
    private func setupDescriptionPagination() {
        guard let description = currentSpot?.spotDetail else { return }
        
        let chunkSize = 300
        var startIndex = description.startIndex
        while startIndex < description.endIndex {
            let endIndex = description.index(startIndex, offsetBy: chunkSize, limitedBy: description.endIndex) ?? description.endIndex
            let chunk = String(description[startIndex..<endIndex])
            descriptionPages.append(chunk)
            startIndex = endIndex
        }
        
        displayCurrentDescriptionPage()
    }
    
    private func displayCurrentDescriptionPage() {
        guard !descriptionPages.isEmpty else {
            spotDetailView.descriptionTextView.text = ""
            spotDetailView.previousDescriptionButton.isHidden = true
            spotDetailView.nextDescriptionButton.isHidden = true
            return
        }
        
        spotDetailView.descriptionTextView.text = descriptionPages[currentDescriptionPageIndex]
        
        let activeColor = UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1.0)
        let disabledColor = UIColor.lightGray
        
        let isPrevEnabled = (currentDescriptionPageIndex > 0)
        spotDetailView.previousDescriptionButton.isEnabled = isPrevEnabled
        spotDetailView.previousDescriptionButton.tintColor = isPrevEnabled ? activeColor : disabledColor
        
        let isNextEnabled = (currentDescriptionPageIndex < descriptionPages.count - 1)
        spotDetailView.nextDescriptionButton.isEnabled = isNextEnabled
        spotDetailView.nextDescriptionButton.tintColor = isNextEnabled ? activeColor : disabledColor
    }
    
    @objc private func didTapNextDescriptionButton() {
        if currentDescriptionPageIndex < descriptionPages.count - 1 {
            currentDescriptionPageIndex += 1
            displayCurrentDescriptionPage()
        }
    }
    
    @objc private func didTapPreviousDescriptionButton() {
        if currentDescriptionPageIndex > 0 {
            currentDescriptionPageIndex -= 1
            displayCurrentDescriptionPage()
        }
    }
}

    #Preview {
    SpotDetailViewController()
}
