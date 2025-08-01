//
//  SpotDetailView.swift
//  TimeTravel
//
//  Created by chohoseo on 7/30/25.
//

import UIKit
import CoreLocation // 지도를 위해 CoreLocation 임포트

class SpotDetailView: UIViewController {

    // MARK: - UI Components

    // 1. 유적지 사진 (상단)
    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor(red: 0.6, green: 0.8, blue: 0.6, alpha: 1.0) // UI 구분을 위한 색상
        return imageView
    }()

    // 2. 유적지 이름
    private let siteNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 1
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(red: 0.6, green: 0.8, blue: 1.0, alpha: 1.0) // UI 구분을 위한 색상
        label.text = "익산 미륵사지" // 임시 텍스트 (실제 이름)
        return label
    }()

    // 3. 길찾기 버튼
    private let navigateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("길찾기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0.2, green: 0.5, blue: 0.8, alpha: 1.0) // UI 구분을 위한 색상
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(navigateButtonTapped), for: .touchUpInside) // 액션 연결
        return button
    }()

    // 4. 스크롤 뷰 (설명, 방문안내를 담을 컨테이너)
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true // 스크롤바 표시
        scrollView.backgroundColor = .clear // 투명하게
        return scrollView
    }()
    
    // 스크롤 뷰 안에 들어갈 실제 콘텐츠 뷰
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()

    // 5. 설명 텍스트 (UILabel로 변경, 줄임표 처리)
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.numberOfLines = 7 // 7줄로 제한, 넘치면 ... 처리
        label.lineBreakMode = .byTruncatingTail // 꼬리 자름표
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(red: 0.8, green: 0.9, blue: 0.95, alpha: 1.0) // UI 구분을 위한 색상
        label.text = """
        익산 미륵사지는 백제 무왕 때 창건된 백제 최대 규모의 사찰 터로, 한국 석탑의 시원(始原)으로 평가받는 미륵사지 석탑(국보)이 남아있습니다. 웅장한 가람 배치와 뛰어난 건축 기술을 엿볼 수 있으며, 백제 불교 문화의 정수를 보여주는 중요한 유적입니다. 최근 복원 작업을 통해 본래의 웅장한 모습을 되찾아 역사적 가치와 아름다움을 동시에 느낄 수 있는 곳입니다. 또한, 발굴 과정에서 발견된 사리장엄구는 당시 백제 왕실의 뛰어난 공예 기술을 보여주며, 미륵사지의 중요성을 더욱 부각시킵니다.
        """ // 임시 텍스트
        return label
    }()
    
    // 6. 더보기 버튼 (설명 옆)
    private let moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("...더보기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside) // 액션 연결
        return button
    }()

    // 7. 방문안내 섹션 제목 라벨
    private let visitorInfoTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "방문안내" // 임시 텍스트
        return label
    }()

    // 8. 방문안내 상세 내용 라벨
    private let visitorInfoDetailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(red: 0.95, green: 0.9, blue: 0.8, alpha: 1.0) // UI 구분을 위한 색상
        label.text = """
        영업시간: 09:00 - 18:00 (연중무휴)
        입장료: 무료
        전화번호: 063-859-3852 (익산시청 문화유산과)
        주차장: 유적지 옆 대형 주차장 완비
        """ // 임시 텍스트
        return label
    }()

    // 9. 이야기 보기 버튼
    private let storyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("퀘스트 시작", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 1.0, green: 0.4, blue: 0.6, alpha: 1.0) // 핑크색 계열
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(storyButtonTapped), for: .touchUpInside) // 액션 연결
        return button
    }()

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // 네비게이션 바 제목 설정 (옵션)
        self.navigationItem.title = "유적지 상세"
    }

    // MARK: - UI Setup

    private func setupUI() {
        view.backgroundColor = .white

        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor(red: 0.8, green: 1.0, blue: 1.0, alpha: 1.0)
        view.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0), // 네비게이션 바 바로 아래에 붙도록
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
        
        // --- UI 요소 배치 (컨테이너 뷰 내에) ---

        // 1. 유적지 사진
        containerView.addSubview(heroImageView)
        NSLayoutConstraint.activate([
            heroImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            heroImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            heroImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            heroImageView.heightAnchor.constraint(equalToConstant: 250) // 사진 높이 고정 (조절 가능)
        ])

        // 2. 유적지 이름
        containerView.addSubview(siteNameLabel)
        NSLayoutConstraint.activate([
            siteNameLabel.topAnchor.constraint(equalTo: heroImageView.bottomAnchor, constant: 10),
            siteNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            siteNameLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.55),
            siteNameLabel.heightAnchor.constraint(equalToConstant: 50)
        ])

        // 3. 길찾기 버튼
        containerView.addSubview(navigateButton)
        NSLayoutConstraint.activate([
            navigateButton.topAnchor.constraint(equalTo: heroImageView.bottomAnchor, constant: 10),
            navigateButton.leadingAnchor.constraint(equalTo: siteNameLabel.trailingAnchor, constant: 10),
            navigateButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            navigateButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // 4. 스크롤 뷰
        containerView.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: siteNameLabel.bottomAnchor, constant: 10),
            scrollView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        // 스크롤 뷰 안에 콘텐츠 뷰 추가
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
        
        // 5. 설명 텍스트 뷰 (contentView 내에 배치)
        contentView.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])

        // 6. 더보기 버튼
        contentView.addSubview(moreButton)
        NSLayoutConstraint.activate([
            moreButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5),
            moreButton.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),
            moreButton.heightAnchor.constraint(equalToConstant: 25)
        ])

        // 7. 방문안내 섹션 (contentView 내에 배치)
        contentView.addSubview(visitorInfoTitleLabel)
        NSLayoutConstraint.activate([
            visitorInfoTitleLabel.topAnchor.constraint(equalTo: moreButton.bottomAnchor, constant: 20),
            visitorInfoTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            visitorInfoTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])

        contentView.addSubview(visitorInfoDetailLabel)
        NSLayoutConstraint.activate([
            visitorInfoDetailLabel.topAnchor.constraint(equalTo: visitorInfoTitleLabel.bottomAnchor, constant: 5),
            visitorInfoDetailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            visitorInfoDetailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            visitorInfoDetailLabel.heightAnchor.constraint(equalToConstant: 100) // 필요에 따라 이 높이 제약조건 제거 가능 (텍스트에 따라 자동 높이)
        ])
        
        // 8. 이야기 보기 버튼 (contentView 내에 배치)
        contentView.addSubview(storyButton)
        NSLayoutConstraint.activate([
            storyButton.topAnchor.constraint(equalTo: visitorInfoDetailLabel.bottomAnchor, constant: 40),
            storyButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            storyButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            storyButton.heightAnchor.constraint(equalToConstant: 50),
            storyButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40) // 콘텐츠 뷰의 바닥과 연결 (스크롤 높이 결정에 중요)
        ])
    }

    // MARK: - Actions (실제 기능 구현)

    @objc private func navigateButtonTapped() {
        
        let spot = SpotModel.shared.arrSpot.filter{
            $0.spotName == self.siteNameLabel.text ?? ""
        }[0]
        
        let siteName = siteNameLabel.text ?? "익산 미륵사지"
        let latitude: Double = spot.coordinate.latitude // spotmodel에서 불러온 해당 유적지에 맞는 위도
        let longitude: Double = spot.coordinate.latitude // 해당 유적지에 맞는 경도

        // 1. 카카오맵 앱 시도
        if let kakaoMapURL = URL(string: "kakaomap://look?p=\(latitude),\(longitude)") {
            if UIApplication.shared.canOpenURL(kakaoMapURL) {
                UIApplication.shared.open(kakaoMapURL, options: [:], completionHandler: nil)
                return
            }
        }

        // 2. 네이버 지도 앱 시도
        // 네이버 지도 URL scheme은 더 복잡할 수 있으므로, 예시로 검색 쿼리를 사용
        if let naverMapURL = URL(string: "nmap://search?query=\(siteName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&appname=com.yourcompany.YourApp") { // "com.yourcompany.YourApp"을 앱 번들 ID로 변경
             if UIApplication.shared.canOpenURL(naverMapURL) {
                 UIApplication.shared.open(naverMapURL, options: [:], completionHandler: nil)
                 return
             }
         }

        // 3. 애플 지도 앱 시도
        let appleMapsURL = URL(string: "http://maps.apple.com/?ll=\(latitude),\(longitude)&q=\(siteName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")")!
        if UIApplication.shared.canOpenURL(appleMapsURL) {
            UIApplication.shared.open(appleMapsURL, options: [:], completionHandler: nil)
            return
        }

        // 모든 지도 앱이 없거나 열리지 않을 경우 사용자에게 알림
        let alert = UIAlertController(title: "길찾기 앱 없음", message: "카카오맵, 네이버 지도 또는 애플 지도 앱을 찾을 수 없습니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    @objc private func moreButtonTapped() {
        // descriptionLabel의 전체 텍스트를 모달에 전달
        let fullDescription = (descriptionLabel.text ?? "") + """

        이것은 전체 설명의 두 번째 단락입니다.
        유적지의 역사적 배경과 발견 과정, 그리고 보존 노력에 대한 상세한 내용을 포함합니다.
        방문객들이 유적지에 대해 더 깊이 이해할 수 있도록 도와주는 정보들이 여기에 모두 표시됩니다.
        """
        
        let modalVC = DescriptionModalViewController(fullDescription: fullDescription)
        modalVC.modalPresentationStyle = .pageSheet
        if #available(iOS 15.0, *) {
            if let sheet = modalVC.sheetPresentationController {
                //sheet.detents = [.medium(), .large()] // 높이 조절 :절반(), 전체화면의()
                
                sheet.detents = [.custom { context in
                    return context.maximumDetentValue * 0.7 // context.maximumDetentValue는 large()와 같음
                }]
                
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                sheet.prefersGrabberVisible = true
            }
        }
        present(modalVC, animated: true, completion: nil)
    }

    @objc private func storyButtonTapped() {
        // 새로운 (빈) 뷰 컨트롤러를 푸시하여 화면 전환을 보여줌
        let storyVC = StoryView()
        
        // 네비게이션 컨트롤러가 존재할 경우에만 푸시
        if let navigationController = self.navigationController {
            navigationController.pushViewController(storyVC, animated: true)
        } else {
            // 네비게이션 컨트롤러가 없을 경우 (예: SceneDelegate에서 직접 루트로 설정 시)
            print("Warning: NavigationController not found. Cannot push storyVC.")
            let alert = UIAlertController(title: "오류", message: "네비게이션 컨트롤러가 없어 '이야기 보기' 화면을 띄울 수 없습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}

#Preview {
    SpotDetailView()
}
