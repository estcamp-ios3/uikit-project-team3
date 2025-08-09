//
//  CameraView.swift
//  LociTravel
//
//  Created by chohoseo on 8/9/25.
//

import UIKit

//상속 방지, 최적화
final class CameraView: UIView {
    
    // MARK: - UI
    let cameraButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("사진 촬영", for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let shareButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("공유하기", for: .normal)
        b.isHidden = true
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .white
        setupLayout()
    }
    
    // MARK: - Layout
    private func setupLayout() {
        addSubview(cameraButton)
        addSubview(imageView)
        addSubview(shareButton)
        
        NSLayoutConstraint.activate([
            cameraButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            cameraButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            imageView.topAnchor.constraint(equalTo: cameraButton.bottomAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 4.0/3.0),
            
            shareButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            shareButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    // MARK: - Update helpers
    func setImage(_ image: UIImage?) {
        imageView.image = image
    }
    
    func setShareButtonHidden(_ hidden: Bool) {
        shareButton.isHidden = hidden
    }
}
