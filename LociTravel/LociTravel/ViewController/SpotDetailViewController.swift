//
//  SpotDetailViewController.swift
//  LociTravel
//
//  Created by suji chae on 8/5/25.
//

import UIKit

class SpotDetailViewController: UIViewController, UIScrollViewDelegate {
    
    private let spotDetailView = SpotDetailView()
    
    // MARK: - 데이터 관련 속성
    var spotName: String?
    private var currentSpot: Spot?
    
    private var descriptionPages: [String] = []
    private var currentDescriptionPageIndex = 0
    
    private var imageScrollTimer: Timer?
    private var isAutoScrolling = true
    
    // MARK: - 초기화 및 뷰 라이프사이클
    
    override func loadView() {
        view = spotDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        setupButtonActions()
        setupImageCarouselDelegate()
        loadSpotData()
        setupDescriptionPagination()
        startImageAutoScroll()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopImageAutoScroll()
    }
    
    // MARK: - 데이터 로드
    
    private func loadSpotData() {
        guard let name = spotName,
              let spot = SpotModel.shared.getSpotData(spot: name) else {
            print("Error: Spot data not found for name: \(spotName ?? "nil")")
            navigationController?.popViewController(animated: true)
            return
        }
        self.currentSpot = spot
        spotDetailView.configure(with: spot)
    }
    
    // MARK: - 버튼 액션 설정
    
    private func setupButtonActions() {
        spotDetailView.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        spotDetailView.previousDescriptionButton.addTarget(self, action: #selector(didTapPreviousDescriptionButton), for: .touchUpInside)
        spotDetailView.nextDescriptionButton.addTarget(self, action: #selector(didTapNextDescriptionButton), for: .touchUpInside)
        spotDetailView.playPauseButton.addTarget(self, action: #selector(didTapPlayPauseButton), for: .touchUpInside)
    }
    
    // 뒤로가기 버튼 액션
    @objc private func didTapBackButton() {
        //navigationController?.popViewController(animated: true)
        dismiss(animated: true)
    }
    
    // MARK: - 이미지 캐러셀 자동 스크롤
    
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
    
    // MARK: - UIScrollViewDelegate (이미지 캐러셀)
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == spotDetailView.imageScrollView {
            let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
            spotDetailView.pageControl.currentPage = Int(pageIndex)
        }
    }
    
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
    
    // MARK: - 설명 텍스트 페이지네이션
    
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
    
    // 현재 설명 페이지를 뷰에 표시합니다.
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
        
        // 이전 버튼 상태 업데이트
        let isPrevEnabled = (currentDescriptionPageIndex > 0)
        spotDetailView.previousDescriptionButton.isEnabled = isPrevEnabled
        spotDetailView.previousDescriptionButton.tintColor = isPrevEnabled ? activeColor : disabledColor
        
        // 다음 버튼 상태 업데이트
        let isNextEnabled = (currentDescriptionPageIndex < descriptionPages.count - 1)
        spotDetailView.nextDescriptionButton.isEnabled = isNextEnabled
        spotDetailView.nextDescriptionButton.tintColor = isNextEnabled ? activeColor : disabledColor
    }
    
    // "다음" 설명 페이지 버튼 액션
    @objc private func didTapNextDescriptionButton() {
        if currentDescriptionPageIndex < descriptionPages.count - 1 {
            currentDescriptionPageIndex += 1
            displayCurrentDescriptionPage()
        }
    }
    
    // "이전" 설명 페이지 버튼 액션
    @objc private func didTapPreviousDescriptionButton() {
        if currentDescriptionPageIndex > 0 {
            currentDescriptionPageIndex -= 1
            displayCurrentDescriptionPage()
        }
    }
}
