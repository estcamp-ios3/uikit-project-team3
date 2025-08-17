//
//  EndingCreditsViewController.swift
//  LociTravel
//
//  Created by suji chae on 8/6/25.
//

import UIKit

class EndingCreditsViewController: PortraitOnlyViewController {

    let participantNames = ["팀장 조호서", "김동우", "송서윤", "채수지"]
    var nameLabels: [UILabel] = []
    
    // 추가된 라벨들
    let thanksTitleLabel = UILabel()
    let specialThanksLabel = UILabel()
    let endMessageLabel = UILabel()
    let finalEndLabel = UILabel()

    // 추가된 버튼들
    let backToStartButton = UIButton(type: .system)
    let photoButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupLabels()
        setupButtons()
        animateCredits()
    }
    
    private func setupLabels() {
        // 팀원 이름 라벨
        for name in participantNames {
            let label = UILabel()
            label.text = name
            label.textColor = .white
            label.alpha = 0
            label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(label)
            nameLabels.append(label)
        }
        
        // 추가된 감사 메시지 라벨들
        thanksTitleLabel.text = "개발에 도움을 주신 분들"
        thanksTitleLabel.textColor = .white
        thanksTitleLabel.alpha = 0
        thanksTitleLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        thanksTitleLabel.textAlignment = .center
        thanksTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(thanksTitleLabel)
        
        specialThanksLabel.text = "그리고 당신"
        specialThanksLabel.textColor = .white
        specialThanksLabel.alpha = 0
        specialThanksLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        specialThanksLabel.textAlignment = .center
        specialThanksLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(specialThanksLabel)
        
        endMessageLabel.text = "모두 감사드립니다!"
        endMessageLabel.textColor = .white
        endMessageLabel.alpha = 0
        endMessageLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        endMessageLabel.textAlignment = .center
        endMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(endMessageLabel)

        finalEndLabel.text = "...end"
        finalEndLabel.textColor = .white
        finalEndLabel.alpha = 0
        finalEndLabel.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        finalEndLabel.textAlignment = .center
        finalEndLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(finalEndLabel)
        
        setupLabelConstraints()
    }
    
    private func setupLabelConstraints() {
        let spacing: CGFloat = 50
        let startY = view.bounds.midY - spacing * CGFloat(nameLabels.count) / 2
        
        for (index, label) in nameLabels.enumerated() {
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                label.topAnchor.constraint(equalTo: view.topAnchor, constant: startY + CGFloat(index) * spacing)
            ])
        }
        
        NSLayoutConstraint.activate([
            thanksTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            thanksTitleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            specialThanksLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            specialThanksLabel.topAnchor.constraint(equalTo: thanksTitleLabel.bottomAnchor, constant: 15),

            endMessageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            endMessageLabel.topAnchor.constraint(equalTo: specialThanksLabel.bottomAnchor, constant: 15),
            
            finalEndLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            finalEndLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupButtons() {
        backToStartButton.setTitle("시작 화면", for: .normal)
        backToStartButton.setTitleColor(.white, for: .normal)
        backToStartButton.backgroundColor = .systemRed.withAlphaComponent(0.8)
        backToStartButton.layer.cornerRadius = 25
        backToStartButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        backToStartButton.translatesAutoresizingMaskIntoConstraints = false
        backToStartButton.isHidden = true
        
        photoButton.setTitle(" 기념 촬영", for: .normal)
        photoButton.setTitleColor(.white, for: .normal)
        photoButton.backgroundColor = .systemGreen.withAlphaComponent(0.8)
        photoButton.layer.cornerRadius = 25
        photoButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        photoButton.translatesAutoresizingMaskIntoConstraints = false
        photoButton.isHidden = true
        
        let cameraImage = UIImage(systemName: "camera.fill")
        photoButton.setImage(cameraImage, for: .normal)
        photoButton.tintColor = .white
        photoButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        photoButton.semanticContentAttribute = .forceLeftToRight
        
        let bottomButtonStack = UIStackView(arrangedSubviews: [backToStartButton, photoButton])
        bottomButtonStack.axis = .horizontal
        bottomButtonStack.spacing = 20
        bottomButtonStack.alignment = .center
        bottomButtonStack.distribution = .equalSpacing
        bottomButtonStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomButtonStack)
        
        NSLayoutConstraint.activate([
            bottomButtonStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomButtonStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            backToStartButton.widthAnchor.constraint(equalToConstant: 140),
            backToStartButton.heightAnchor.constraint(equalToConstant: 50),
            photoButton.widthAnchor.constraint(equalToConstant: 140),
            photoButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        backToStartButton.addTarget(self, action: #selector(didTapBackToStart), for: .touchUpInside)
        photoButton.addTarget(self, action: #selector(didTapPhotoButton), for: .touchUpInside)
    }

    private func animateCredits() {
        let nameAnimationDuration: TimeInterval = 1.0
        let nameFadeOutDuration: TimeInterval = 1.5
        let nameInterval: TimeInterval = 1.2
        let thanksMessageInterval: TimeInterval = 1.0
        let endMessageDuration: TimeInterval = 2.0
        let buttonDisplayDelay: TimeInterval = 2.0

        var currentDelay: TimeInterval = 0

        // 1. 이름 라벨 애니메이션
        for (i, label) in nameLabels.enumerated() {
            let labelDelay = currentDelay + Double(i) * nameInterval
            UIView.animate(withDuration: nameAnimationDuration, delay: labelDelay, options: [], animations: {
                label.alpha = 1.0
            }, completion: nil)
        }

        // 이름 라벨 전체 페이드 아웃
        currentDelay += Double(nameLabels.count) * nameInterval + nameFadeOutDuration
        DispatchQueue.main.asyncAfter(deadline: .now() + currentDelay) {
            UIView.animate(withDuration: nameFadeOutDuration, animations: {
                self.nameLabels.forEach { $0.alpha = 0 }
            })
        }
        
        // 2. "개발에 도움을 주신 분들" 애니메이션
        currentDelay += nameFadeOutDuration
        DispatchQueue.main.asyncAfter(deadline: .now() + currentDelay) {
            UIView.animate(withDuration: 1.0) {
                self.thanksTitleLabel.alpha = 1.0
            }
        }
        
        // 3. "Special Thanks" 애니메이션
        currentDelay += thanksMessageInterval
        DispatchQueue.main.asyncAfter(deadline: .now() + currentDelay) {
            UIView.animate(withDuration: 1.0) {
                self.specialThanksLabel.alpha = 1.0
            }
        }
        
        // 4. "모두 감사드립니다!" 애니메이션
        currentDelay += thanksMessageInterval
        DispatchQueue.main.asyncAfter(deadline: .now() + currentDelay) {
            UIView.animate(withDuration: 1.0) {
                self.endMessageLabel.alpha = 1.0
            }
        }
        
        // 5. "개발에 도움을 주신 분들" 섹션 페이드 아웃 후 "...end" 애니메이션
        currentDelay += thanksMessageInterval + 1.5
        DispatchQueue.main.asyncAfter(deadline: .now() + currentDelay) {
            UIView.animate(withDuration: 1.5, animations: {
                self.thanksTitleLabel.alpha = 0
                self.specialThanksLabel.alpha = 0
                self.endMessageLabel.alpha = 0
            }, completion: { _ in
                UIView.animate(withDuration: endMessageDuration) {
                    self.finalEndLabel.alpha = 1.0
                } completion: { _ in
                    // ⭐️ 애니메이션 완료 후 버튼 표시
                    self.showEndButtons()
                }
            })
        }
    }
    
    // 버튼을 나타나게 하는 메서드
    private func showEndButtons() {
        UIView.animate(withDuration: 0.5) {
            self.backToStartButton.isHidden = false
            self.photoButton.isHidden = false
        }
    }
    
    // 버튼 액션 메서드
    @objc private func didTapBackToStart() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func didTapPhotoButton() {
        PermissionManager.ensureCameraAndAddOnly { [weak self] cam, photos in
                guard let self else { return }

                // 카메라 권한 필수
                guard cam == .granted else {
                    self.showGoToSettings("카메라")
                    return
                }

                // 사진 추가 권한이 없으면 안내 (촬영은 가능)
                if photos == .denied {
                    self.showNotice("사진 보관함 권한이 없어 저장에 실패할 수 있어요.")
                }

                // 권한 확보 후 카메라 표시
                CameraService.shared.present(from: self, overlay: UIImage(named: "bg")) { [weak self] image in
                    guard let self else { return }

                    // 반드시 dismiss 완료 후에 콜백이 온다고 가정 (아래 CameraService 참고)
                    PhotoSaver.save(image, toAlbum: "LociTravel") { [weak self] result in
                        switch result {
                        case .success:
                            self?.toast("사진이 저장되었어요 📸")
                        case .failure(let err):
                            self?.showAlert(title: "저장 실패", message: err.localizedDescription)
                        }
                    }
                }
            }
    }
}

#Preview {
    EndingCreditsViewController()
}
