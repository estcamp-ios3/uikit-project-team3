//
//  FullMapViewController.swift
//  TimeTravel
//
//  Created by dkkim on 7/30/25.
//

import UIKit

class FullMapViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let imageView = UIImageView(image: UIImage(named: "testMiniMap"))
        imageView.contentMode = .scaleAspectFit
        imageView.frame = view.bounds
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(imageView)

        let closeButton = UIButton(type: .system)
        closeButton.setTitle("닫기", for: .normal)
        
        closeButton.setTitleColor(.label, for: .normal)
                // ✏️ 배경 반투명 검정으로 하면 더 눈에 띕니다.
                closeButton.backgroundColor = UIColor.black.withAlphaComponent(0.4)
                closeButton.layer.cornerRadius = 5
                closeButton.frame = CGRect(x: 16, y: view.safeAreaInsets.top + 75, width: 60, height: 40)
                closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
                view.addSubview(closeButton)
        
    
    }

    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
}
