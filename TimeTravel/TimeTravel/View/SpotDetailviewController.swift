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
    private var isDescriptionExpanded = false
    
    // 뷰(View) 인스턴스를 생성하고 컨트롤러의 view로 설정합니다.
    private let spotDetailView = SpotDetailView()

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
        
        // spotData에 데이터가 있으면 UI를 설정하는 메서드 호출
        if let spot = spotData {
            configure(with: spot)
        }
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
        
        let images = spot.spotImage
        spotDetailView.pageControl.numberOfPages = images.count
        
        // 이미지 스크롤뷰에 이미지들을 동적으로 추가
        for (index, imageName) in images.enumerated() {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.image = UIImage(named: imageName)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            spotDetailView.imageScrollView.addSubview(imageView)
            
            // 이미지뷰의 레이아웃 설정
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalTo: spotDetailView.widthAnchor),
                imageView.heightAnchor.constraint(equalTo: spotDetailView.imageScrollView.heightAnchor),
                imageView.topAnchor.constraint(equalTo: spotDetailView.imageScrollView.topAnchor),
                imageView.leadingAnchor.constraint(equalTo: spotDetailView.imageScrollView.leadingAnchor, constant: view.frame.width * CGFloat(index))
            ])
        }
    }
    
    // MARK: - Setup Actions
    
    // 모든 UI 컴포넌트의 액션(버튼 탭, 제스처)을 설정하는 메서드
    private func setupActions() {
        spotDetailView.navigateButton.addTarget(self, action: #selector(navigateButtonTapped), for: .touchUpInside)
        spotDetailView.moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        spotDetailView.startButton.addTarget(self, action: #selector(storyButtonTapped), for: .touchUpInside)
        
        // 이미지 탭 제스처 추가
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        spotDetailView.imageScrollView.addGestureRecognizer(imageTapGesture)

        // 이미지 스크롤뷰의 델리게이트 설정
        spotDetailView.imageScrollView.delegate = self
    }

    // MARK: - Button Actions
    
    // 이미지 갤러리를 전체 화면으로 띄우는 액션
    @objc private func imageTapped() {
        guard let images = spotData?.spotImage else { return }
        let tappedIndex = Int(spotDetailView.imageScrollView.contentOffset.x / view.frame.width)
        
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
        let storyVC = StoryView() // StoryView는 다른 화면의 뷰 컨트롤러라고 가정
        if let navigationController = self.navigationController {
            navigationController.pushViewController(storyVC, animated: true)
        } else {
            let alert = UIAlertController(title: "오류", message: "네비게이션 컨트롤러가 없어 '이야기 보기' 화면을 띄울 수 없습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - UIScrollViewDelegate
extension SpotDetailViewController: UIScrollViewDelegate {
    // 스크롤이 끝날 때마다 페이지 컨트롤의 현재 페이지를 업데이트
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == spotDetailView.imageScrollView {
            let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
            spotDetailView.pageControl.currentPage = Int(pageIndex)
        }
    }
}
