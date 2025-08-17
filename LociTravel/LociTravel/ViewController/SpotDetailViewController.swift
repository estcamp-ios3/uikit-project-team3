//
//  SpotDetailViewController.swift
//  LociTravel
//
//  Created by suji chae on 8/5/25.
//

import UIKit

class SpotDetailViewController: PortraitOnlyViewController, UIScrollViewDelegate {
    
    // MARK: - Properties
    
    private let spotDetailView = SpotDetailView()
    
    var currentSpot: Spot?
    
    private var descriptionPages: [String] = []
    private var currentDescriptionPageIndex = 0
    
    private var imageScrollTimer: Timer?
    private var isAutoScrolling = true
    
    // MARK: - View Lifecycle
    
    override func loadView() {
        view = spotDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        loadSpotData()
        setupButtonActions()
        setupImageCarouselDelegate()
        setupDescriptionPagination()
        startImageAutoScroll()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopImageAutoScroll()
    }
    
    // MARK: - Data Loading
    
    private func loadSpotData() {
        guard let spot = self.currentSpot else {
            print("Error: Spot data not found.")
            navigationController?.popViewController(animated: true)
            return
        }
        spotDetailView.configure(with: spot)
    }
    
    // MARK: - Button Actions
    
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
    
    // MARK: - Description Text Pagination
    
    private func setupDescriptionPagination() {
        guard let description = currentSpot?.spotDetail else { return }
        
        descriptionPages = description.components(separatedBy: "\n\n").filter { !$0.isEmpty }
        displayCurrentDescriptionPage()
    }
    
    private func displayCurrentDescriptionPage() {
        guard !descriptionPages.isEmpty else {
            spotDetailView.descriptionTextView.text = ""
            spotDetailView.previousDescriptionButton.isHidden = true
            spotDetailView.nextDescriptionButton.isHidden = true
            return
        }
        
        let currentText = descriptionPages[currentDescriptionPageIndex]
        
        // 줄 간격을 설정할 attributed string 생성
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5.0 // 원하는 줄 간격으로 설정
        paragraphStyle.alignment = .left // 왼쪽 정렬 유지
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16),
            .paragraphStyle: paragraphStyle
        ]
        
        let attributedString = NSAttributedString(string: currentText, attributes: attributes)
        
        
        spotDetailView.descriptionTextView.text = descriptionPages[currentDescriptionPageIndex]
        
        // tintColor를 직접 변경하는 코드를 삭제하고 isEnabled만 변경
        let isPrevEnabled = (currentDescriptionPageIndex > 0)
        spotDetailView.previousDescriptionButton.isEnabled = isPrevEnabled
        
        let isNextEnabled = (currentDescriptionPageIndex < descriptionPages.count - 1)
        spotDetailView.nextDescriptionButton.isEnabled = isNextEnabled
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
