//
//  ImagePreViewController.swift
//  TimeTravel
//
//  Created by dkkim on 8/3/25.
//

import UIKit

/// HomeView의 이미지를 클릭하면 전체 화면으로 이미지를 보여 주는 뷰 컨트롤러
class ImagePreviewViewController: UIViewController {
  private let imageView = UIImageView()
  private let closeButton = UIButton(type: .system)
  private let image: UIImage

  // ③ 커스텀 이니셜라이저로 이미지를 전달받음
  init(image: UIImage) {
    self.image = image
    super.init(nibName: nil, bundle: nil)
  }
  required init?(coder: NSCoder) { fatalError() }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .black

    // ④ 이미지 뷰 설정
    imageView.image = image
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(imageView)

    // ⑤ 닫기 버튼 설정
    closeButton.setTitle("닫기", for: .normal)
    closeButton.setTitleColor(.white, for: .normal)
    closeButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
    closeButton.translatesAutoresizingMaskIntoConstraints = false
    closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
    view.addSubview(closeButton)

    // ⑥ 레이아웃
    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

      closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
      closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      closeButton.heightAnchor.constraint(equalToConstant: 44)
    ])
  }

  // ⑦ 닫기 액션
  @objc private func didTapClose() {
    dismiss(animated: true)
  }
}
