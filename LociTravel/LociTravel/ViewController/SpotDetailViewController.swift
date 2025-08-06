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
    var spotName: String? // MapViewController에서 전달받을 유적지 이름
    private var currentSpot: Spot? // SpotModel에서 불러온 실제 Spot 데이터
    
    private var descriptionPages: [String] = [] // 설명 텍스트를 페이지별로 나눈 배열
    private var currentDescriptionPageIndex = 0 // 현재 설명 페이지 인덱스
    
    private var imageScrollTimer: Timer? // 이미지 자동 스크롤 타이머
    private var isAutoScrolling = true // 자동 스크롤 상태 추적
    
    // MARK: - 초기화 및 뷰 라이프사이클
    
    override func loadView() {
        view = spotDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 뷰 컨트롤러가 로드될 때 내비게이션 바 숨기기 (전체 화면처럼 보이게)
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        setupButtonActions() // 버튼 액션 설정
        setupImageCarouselDelegate() // 이미지 캐러셀 델리게이트 설정
        loadSpotData() // 유적지 데이터 불러오기 및 뷰 구성
        setupDescriptionPagination() // 설명 텍스트 페이지네이션 설정
        startImageAutoScroll() // 이미지 자동 스크롤 시작
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopImageAutoScroll() // 뷰가 사라질 때 타이머 중지
    }
    
    // MARK: - 데이터 로드
    
    private func loadSpotData() {
        // `spotName`을 통해 `SpotModel`에서 해당 유적지 데이터를 불러옵니다.
        guard let name = spotName,
              let spot = SpotModel.shared.getSpotData(spot: name) else {
            // 유적지 데이터를 불러오지 못하면 오류를 출력하고 이전 화면으로 돌아갑니다.
            print("Error: Spot data not found for name: \(spotName ?? "nil")")
            navigationController?.popViewController(animated: true)
            return
        }
        self.currentSpot = spot // 불러온 데이터를 `currentSpot`에 저장
        spotDetailView.configure(with: spot) // 뷰에 데이터 설정 (이름, 이미지 캐러셀)
    }
    
    // MARK: - 버튼 액션 설정
    
    private func setupButtonActions() {
        spotDetailView.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        spotDetailView.nextDescriptionButton.addTarget(self, action: #selector(didTapNextDescriptionButton), for: .touchUpInside)
        spotDetailView.playPauseButton.addTarget(self, action: #selector(didTapPlayPauseButton), for: .touchUpInside) // 플레이/스탑 버튼 액션 추가
    }
    
    // 뒤로가기 버튼 액션
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - 이미지 캐러셀 자동 스크롤
    
    private func setupImageCarouselDelegate() {
        spotDetailView.imageScrollView.delegate = self // UIScrollViewDelegate 설정
    }
    
    // 이미지 자동 스크롤 타이머 시작
    private func startImageAutoScroll() {
        // 기존 타이머가 있다면 중지하고 새로 시작합니다.
        imageScrollTimer?.invalidate()
        // 3초마다 `scrollToNextImage` 함수를 호출합니다.
        imageScrollTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(scrollToNextImage), userInfo: nil, repeats: true)
        isAutoScrolling = true
        spotDetailView.playPauseButton.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal) // 아이콘 업데이트
    }
    
    // 이미지 자동 스크롤 타이머 중지
    private func stopImageAutoScroll() {
        imageScrollTimer?.invalidate() // 타이머를 무효화합니다.
        imageScrollTimer = nil // 타이머 참조를 nil로 설정합니다.
        isAutoScrolling = false
        spotDetailView.playPauseButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal) // 아이콘 업데이트
    }
    
    // 다음 이미지로 스크롤하는 로직
    @objc private func scrollToNextImage() {
        let currentPage = spotDetailView.pageControl.currentPage // 현재 페이지
        let numberOfPages = spotDetailView.pageControl.numberOfPages // 총 페이지 수
        
        // 이미지가 없거나 한 장뿐이면 스크롤하지 않습니다.
        guard numberOfPages > 1 else { return }
        
        // 다음 페이지 계산 (마지막 페이지면 첫 페이지로 돌아감)
        let nextPage = (currentPage + 1) % numberOfPages
        
        // 다음 페이지로 스크롤 뷰의 contentOffset을 설정합니다.
        let offsetX = CGFloat(nextPage) * spotDetailView.imageScrollView.frame.width
        spotDetailView.imageScrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        
        // 페이지 컨트롤의 현재 페이지도 업데이트합니다.
        spotDetailView.pageControl.currentPage = nextPage
    }
    
    // MARK: - 플레이/스탑 버튼 액션
    @objc private func didTapPlayPauseButton() {
        if isAutoScrolling {
            stopImageAutoScroll()
        } else {
            startImageAutoScroll()
        }
    }
    
    // MARK: - UIScrollViewDelegate (이미지 캐러셀)
    
    // 사용자가 스크롤 뷰를 스크롤했을 때 호출됩니다.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 스크롤 뷰가 이미지 캐러셀 스크롤 뷰인지 확인합니다.
        if scrollView == spotDetailView.imageScrollView {
            // 스크롤 위치에 따라 현재 페이지를 계산하고 페이지 컨트롤을 업데이트합니다.
            let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
            spotDetailView.pageControl.currentPage = Int(pageIndex)
        }
    }
    
    // 사용자가 스크롤을 시작할 때 자동 스크롤 타이머를 중지합니다.
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == spotDetailView.imageScrollView {
            stopImageAutoScroll()
        }
    }
    
    // 사용자가 스크롤을 멈췄을 때 자동 스크롤 타이머를 다시 시작합니다.
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == spotDetailView.imageScrollView {
            startImageAutoScroll()
        }
    }
    
    // MARK: - 설명 텍스트 페이지네이션
    
    private func setupDescriptionPagination() {
        guard let description = currentSpot?.spotDetail else { return }
        
        // 텍스트를 적절한 길이로 나누는 로직 (예시: 300자 단위)
        // 실제 앱에서는 문단 단위, 문장 단위 등으로 더 자연스럽게 나누는 복잡한 로직이 필요할 수 있습니다.
        let chunkSize = 300 // 한 페이지에 표시할 글자 수
        var startIndex = description.startIndex
        while startIndex < description.endIndex {
            let endIndex = description.index(startIndex, offsetBy: chunkSize, limitedBy: description.endIndex) ?? description.endIndex
            let chunk = String(description[startIndex..<endIndex])
            descriptionPages.append(chunk)
            startIndex = endIndex
        }
        
        displayCurrentDescriptionPage() // 첫 페이지 표시
    }
    
    // 현재 설명 페이지를 뷰에 표시합니다.
    private func displayCurrentDescriptionPage() {
        guard currentDescriptionPageIndex < descriptionPages.count else {
            // 모든 페이지를 다 읽었을 때 "다음" 버튼 숨기기 또는 텍스트 변경
            spotDetailView.nextDescriptionButton.setTitle("설명 끝", for: .normal)
            spotDetailView.nextDescriptionButton.isEnabled = false // 버튼 비활성화
            return
        }
        
        spotDetailView.descriptionTextView.text = descriptionPages[currentDescriptionPageIndex]
        
        // 마지막 페이지가 아니면 "다음" 버튼 활성화, 마지막 페이지면 "설명 끝"으로 변경
        if currentDescriptionPageIndex < descriptionPages.count - 1 {
            spotDetailView.nextDescriptionButton.setTitle("다음", for: .normal)
            spotDetailView.nextDescriptionButton.isEnabled = true
        } else {
            spotDetailView.nextDescriptionButton.setTitle("설명 끝", for: .normal)
            spotDetailView.nextDescriptionButton.isEnabled = false
        }
    }
    
    // "다음" 설명 페이지 버튼 액션
    @objc private func didTapNextDescriptionButton() {
        currentDescriptionPageIndex += 1 // 다음 페이지로 이동
        displayCurrentDescriptionPage() // 다음 페이지 표시
    }
}
