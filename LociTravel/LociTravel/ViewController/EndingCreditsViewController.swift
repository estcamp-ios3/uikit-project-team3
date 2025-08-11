//
//  EndingCreditsViewController.swift
//  LociTravel
//
//  Created by suji chae on 8/6/25.
//

import UIKit

class EndingCreditsViewController: UIViewController {

    let participantNames = ["조호서", "김동우", "송서윤", "채수지"]
    var nameLabels: [UILabel] = []
    let endLabel = UILabel()
    
    // 추가된 버튼들
    let backToStartButton = UIButton(type: .system)
    let photoButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupLabels()
        animateNames()
    }
    
    private func setupLabels() {
        for name in participantNames {
            let label = UILabel()
            label.text = name
            label.textColor = .white
            label.alpha = 0
            label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
            label.textAlignment = .center
            view.addSubview(label)
            nameLabels.append(label)
        }

        endLabel.text = "감사합니다.  …end"
        endLabel.textColor = .white
        endLabel.alpha = 0
        endLabel.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        endLabel.textAlignment = .center
        view.addSubview(endLabel)
        
        // 버튼 설정
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
        
        // 버튼들을 담을 StackView
        let bottomButtonStack = UIStackView(arrangedSubviews: [backToStartButton, photoButton])
        bottomButtonStack.axis = .horizontal
        bottomButtonStack.spacing = 20
        bottomButtonStack.alignment = .center
        bottomButtonStack.distribution = .equalSpacing
        bottomButtonStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomButtonStack)
        
        // 버튼 스택뷰 제약 조건
        NSLayoutConstraint.activate([
            bottomButtonStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomButtonStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            backToStartButton.widthAnchor.constraint(equalToConstant: 140),
            backToStartButton.heightAnchor.constraint(equalToConstant: 50),
            photoButton.widthAnchor.constraint(equalToConstant: 140),
            photoButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // 버튼 액션 연결
        backToStartButton.addTarget(self, action: #selector(didTapBackToStart), for: .touchUpInside)
        photoButton.addTarget(self, action: #selector(didTapPhotoButton), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let spacing: CGFloat = 50
        let startY = view.bounds.midY - spacing * CGFloat(nameLabels.count) / 2
        
        for (index, label) in nameLabels.enumerated() {
            label.frame = CGRect(x: 0, y: startY + CGFloat(index) * spacing, width: view.bounds.width, height: 30)
        }

        endLabel.frame = CGRect(x: 0, y: view.bounds.midY, width: view.bounds.width, height: 40)
    }
    
    private func animateNames() {
        for (i, label) in nameLabels.enumerated() {
            let delay = Double(i) * 1.2
            UIView.animate(withDuration: 1.0, delay: delay, options: [], animations: {
                label.alpha = 1.0
                label.frame.origin.y -= 20
            }, completion: nil)
        }

        // 전체 이름 페이드 아웃 후 엔딩 텍스트 표시
        let totalDelay = Double(participantNames.count) * 1.2 + 1.5
        DispatchQueue.main.asyncAfter(deadline: .now() + totalDelay) {
            UIView.animate(withDuration: 1.5, animations: {
                self.nameLabels.forEach { $0.alpha = 0 }
            }, completion: { _ in
                UIView.animate(withDuration: 2.0) {
                    self.endLabel.alpha = 1.0
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
        // 기존 EpilogueViewController의 기념사진 촬영 로직을 여기에 구현
        // CameraService, PhotoSaver, toast, showAlert 함수가 필요합니다.
        // 다음은 예시 코드입니다.
        let overlay = UIImage(named: "bg")
        
        // CameraService.shared.present(from: self, overlay: overlay) { [weak self] image in
        //     PhotoSaver.save(image, toAlbum: "LociTravel") { result in
        //         switch result {
        //         case .success:
        //             self?.toast("사진이 저장되었어요 📸")
        //         case .failure(let err):
        //             self?.showAlert(title: "저장 실패", message: err.localizedDescription)
        //         }
        //     }
        // }
    }
}

#Preview {
    EndingCreditsViewController()
}
