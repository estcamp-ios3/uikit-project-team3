//
//  SpotDetailviewController.swift
//  TimeTravel
//
//  Created by suji chae on 8/4/25.
//

import UIKit
import CoreLocation

// LocationNavigator는 외부 도우미 클래스라고 가정
class LocationNavigator {
    func navigateTo(latitude: Double, longitude: Double, siteName: String, viewController: UIViewController) {
        let spotName = siteName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        if let kakaoMapURL = URL(string: "kakaomap://look?p=\(latitude),\(longitude)") {
            if UIApplication.shared.canOpenURL(kakaoMapURL) {
                UIApplication.shared.open(kakaoMapURL, options: [:], completionHandler: nil)
                return
            }
        }
        
        if let naverMapURL = URL(string: "nmap://search?query=\(spotName)&appname=com.yourcompany.YourApp") {
            if UIApplication.shared.canOpenURL(naverMapURL) {
                UIApplication.shared.open(naverMapURL, options: [:], completionHandler: nil)
                return
            }
        }
        
        let appleMapsURL = URL(string: "http://maps.apple.com/?ll=\(latitude),\(longitude)&q=\(spotName)")!
        if UIApplication.shared.canOpenURL(appleMapsURL) {
            UIApplication.shared.open(appleMapsURL, options: [:], completionHandler: nil)
            return
        }
        
        let alert = UIAlertController(title: "오류", message: "설치된 지도 앱이 없습니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
}


// 이 클래스는 컨트롤러 역할을 담당하며, 뷰와 모델을 연결하고 사용자 상호작용을 처리
class SpotDetailViewController: UIViewController {

    // MARK: - Properties
    var spotData: Spot? // 외부에서 전달받을 데이터
    var theme: String? // 테마 가져오기
    var spotName: String? //
    
    private var isDescriptionExpanded = false
    
    // 뷰(View) 인스턴스를 생성하고 컨트롤러의 view로 설정합니다.
    private let spotDetailView = SpotDetailView()
    
    // 자동 스크롤을 위한 타이머와 상태변수
    private var imageTimer: Timer?
    private var isAutoScrolling = true
    
    // MARK: - View Lifecycle
    
    // 뷰 컨트롤러의 뷰를 로드할 때 호출됩니다.
    // 뷰 컨트롤러의 메인 뷰를 SpotDetailView의 인스턴스로 설정합니다.
    override func loadView() {
        self.view = spotDetailView
    }

    // 뷰가 메모리에 로드된 후 호출됩니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        
        // 뷰의 델리케이트를 컨트롤러 자신으로 설정
        spotDetailView.imageScrollView.delegate = self
        
        
        // getSpotData 메서드 호출로 변경하고 옵셔널 바인딩을 사용
        if let spotName = self.spotName, let spot = SpotModel.shared.getSpotData(spot: spotName) {
            spotData = spot
            configure(with: spot)
            

            let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
            spotDetailView.imageScrollView.addGestureRecognizer(imageTapGesture)
        }
        }
    
    
    // 뷰의 레이아웃이 설정된 후에 호출. 오류가 안남
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 뷰의 프레임이 확정된 후에 이미지 레이아웃 다시 설정
        spotDetailView.updateScrollViewContent()
    }
    
    // 뷰 컨트롤러가 사라질 떄 타이머를 멈춤
    deinit {
        imageTimer?.invalidate()
    }
    
    
    // MARK: - Data Configuration
    
    // 뷰에 데이터를 바인딩하는 메서드
    private func configure(with spot: Spot) {
        spotDetailView.siteNameLabel.text = spot.spotName
        spotDetailView.descriptionLabel.text = spot.spotDetail
        spotDetailView.visitorInfoDetailLabel.text = """
        주소: \(spot.info.address)
        전화번호: \(spot.info.phone)
        웹사이트: \(spot.info.website)
        이용료: \(spot.info.cost)
        운영시간: \(spot.info.openTime)
        """
        
        //setupImages 메서드 호출
        spotDetailView.setupImages(with: spot.spotImage)
    }
    
    // MARK: - Setup Actions
    
    // 모든 UI 컴포넌트의 액션(버튼 탭, 제스처)을 설정하는 메서드
    private func setupActions() {
        spotDetailView.navigateButton.addTarget(self, action: #selector(navigateButtonTapped), for: .touchUpInside)
        spotDetailView.moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        spotDetailView.startButton.addTarget(self, action: #selector(storyButtonTapped), for: .touchUpInside)
        
        // 재생/정지 버튼 액션 연결
        spotDetailView.playPauseButton.addTarget(self, action: #selector(playPauseButtonTapped), for: .touchUpInside)
    }

    // MARK: - Button Actions
    
    // 이미지 갤러리를 전체 화면으로 띄우는 액션
    @objc private func imageTapped() {
        guard let images = spotData?.spotImage else { return }
        let tappedIndex = Int(spotDetailView.imageScrollView.contentOffset.x / view.frame.width)
        
        //뷰에서 이미지 이름 배열을 받아 UITmage 배열로 변환 후 전달
        let uiImages = images.compactMap { UIImage(named: $0) }
        
        let galleryVC = ImageGalleryViewController(images: images, initialIndex: tappedIndex)
        galleryVC.modalPresentationStyle = .fullScreen
        self.present(galleryVC, animated: true, completion: nil)
    }
    
    // 지도 바로가기 버튼 탭 액션
    @objc private func navigateButtonTapped() {
        guard let spot = spotData else { return }
        let navigator = LocationNavigator()
        navigator.navigateTo(
            latitude: spot.coordinate.latitude,
            longitude: spot.coordinate.longitude,
            siteName: spot.spotName,
            viewController: self
        )
    }
    
    // 더보기/접기 버튼 탭 액션
    @objc private func moreButtonTapped() {
        isDescriptionExpanded.toggle()
        spotDetailView.descriptionLabel.numberOfLines = isDescriptionExpanded ? 0 : 7
        spotDetailView.moreButton.setTitle(isDescriptionExpanded ? "...접기" : "...더보기", for: .normal)
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    // 퀘스트 시작 버튼 탭 액션
    @objc private func storyButtonTapped() {
        let storyVC = StoryView(themeName: "잊혀진 유적", spotName: "미륵사지") // StoryView는 다른 화면의 뷰 컨트롤러라고 가정
        if let navigationController = self.navigationController {
            navigationController.pushViewController(storyVC, animated: true)
        } else {
            let alert = UIAlertController(title: "오류", message: "네비게이션 컨트롤러가 없어 '이야기 보기' 화면을 띄울 수 없습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Auto Scroll Actions
    
    // 자동 스크롤 타이머 시작 메서드
    private func startImageTimer() {
        imageTimer?.invalidate()
        imageTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.autoScrollImages()
        }
    }
    
    // 타이머에 의해 이미지를 스크롤하는 메서드
    private func autoScrollImages() {
        // 페이지가 0개면 함수를 바로 종료
        guard spotDetailView.pageControl.numberOfPages > 0 else { return }
        
        let currentPage = spotDetailView.pageControl.currentPage
        let nextPage = (currentPage + 1) % spotDetailView.pageControl.numberOfPages
        
        let offsetX = CGFloat(nextPage) * spotDetailView.bounds.width
        spotDetailView.imageScrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
    
    // 재생/정지 버튼 탭 액션
    @objc private func playPauseButtonTapped() {
        // 이미지가 1개 이하일 떄 버튼 동작 x
        guard spotData?.spotImage.count ?? 0 > 1 else { return }
        
        isAutoScrolling.toggle()
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .large)
        if isAutoScrolling {
            startImageTimer()
            spotDetailView.playPauseButton.setImage(UIImage(systemName: "pause.circle.fill", withConfiguration: config), for: .normal)
        } else {
            imageTimer?.invalidate()
            spotDetailView.playPauseButton.setImage(UIImage(systemName: "play.circle.fill", withConfiguration: config), for: .normal)
        }
    }
    
}

// MARK: - UIScrollViewDelegate
extension SpotDetailViewController: UIScrollViewDelegate {
    // 수동 스크롤이 멈췄을 때 호출되어 페이지 컨트롤만 업데이트합니다.
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == spotDetailView.imageScrollView {
            let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
            spotDetailView.pageControl.currentPage = Int(pageIndex)
        }
    }

    // 수동 스크롤이 시작되면 자동 스크롤 타이머를 중지합니다.
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == spotDetailView.imageScrollView {
            imageTimer?.invalidate()
        }
    }
}
