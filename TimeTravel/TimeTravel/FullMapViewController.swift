//
//  FullMapViewController.swift
//  TimeTravel
//
//  Created by dkkim on 7/30/25.
//

import UIKit

class FullMapViewController: UIViewController {
    
    var imageName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        // ⭐️ 6) 전달된 imageName을 사용, 없으면 기본 아이콘으로
                let name = imageName ?? "testMiniMap"
                let image = UIImage(named: name) ?? UIImage(systemName: "map")
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFit
                imageView.frame = view.bounds
                imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                view.addSubview(imageView)
        
        
        
        let closeButton = UIButton(type: .system)
               closeButton.setTitle("닫기", for: .normal)
               closeButton.setTitleColor(.label, for: .normal)
               closeButton.backgroundColor = UIColor.black.withAlphaComponent(0.4)
               closeButton.layer.cornerRadius = 5
               // ⭐️ safeAreaInsets를 고려해 Y 좌표 조정
               closeButton.frame = CGRect(x: 16,
                                          y:  view.safeAreaInsets.top + 75 ,
                                          width: 60,
                                          height: 32)
               closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
               view.addSubview(closeButton)
        
    
    }

    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
}
