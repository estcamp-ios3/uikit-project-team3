//
//  SpotDetailView.swift
//  LociTravel
//
//  Created by suji chae on 8/5/25.
//

import UIKit

class SpotDetailView: UIView {
    
    let backgroundImageView = UIImageView()
    let storyContainerView = UIView()
    
    private let storyScrollView = UIScrollView()
    private let storyStackView = UIStackView()
    
    let backButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // 뷰 계층 구조 설정
        addSubview(backgroundImageView)
        addSubview(storyContainerView)
        addSubview(backButton)
        
        storyContainerView.addSubview(storyScrollView)
        storyScrollView.addSubview(storyStackView)
        
        // 모든 뷰에 Auto Layout 사용 설정
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        storyContainerView.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        storyScrollView.translatesAutoresizingMaskIntoConstraints = false
        storyStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // 배경 이미지 설정
        backgroundImageView.image = UIImage(named: "mireuksa_temple_photo")
        backgroundImageView.contentMode = .scaleAspectFill
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        // 스토리 컨테이너 뷰 설정
        storyContainerView.backgroundColor = .clear

        NSLayoutConstraint.activate([
            storyContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            storyContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            storyContainerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            storyContainerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5)
        ])
        
        // 고서 느낌의 배경
        let oldPaperTexture = UIImageView(image: UIImage(named: "dialogue_parchment_background"))
        oldPaperTexture.contentMode = .scaleToFill
        oldPaperTexture.translatesAutoresizingMaskIntoConstraints = false
        storyContainerView.insertSubview(oldPaperTexture, at: 0)
        
        NSLayoutConstraint.activate([
            oldPaperTexture.topAnchor.constraint(equalTo: storyContainerView.topAnchor),
            oldPaperTexture.bottomAnchor.constraint(equalTo: storyContainerView.bottomAnchor),
            oldPaperTexture.leadingAnchor.constraint(equalTo: storyContainerView.leadingAnchor),
            oldPaperTexture.trailingAnchor.constraint(equalTo: storyContainerView.trailingAnchor)
        ])
        
        // 스크롤 뷰 설정
        NSLayoutConstraint.activate([
            storyScrollView.topAnchor.constraint(equalTo: storyContainerView.topAnchor, constant: 15),
            storyScrollView.bottomAnchor.constraint(equalTo: storyContainerView.bottomAnchor, constant: -15),
            storyScrollView.leadingAnchor.constraint(equalTo: storyContainerView.leadingAnchor, constant: 15),
            storyScrollView.trailingAnchor.constraint(equalTo: storyContainerView.trailingAnchor, constant: -15)
        ])
        
        // 스택 뷰 설정
        storyStackView.axis = .vertical
        storyStackView.spacing = 15
        storyStackView.alignment = .fill
        storyStackView.distribution = .fill
        
        NSLayoutConstraint.activate([
            storyStackView.topAnchor.constraint(equalTo: storyScrollView.topAnchor),
            storyStackView.bottomAnchor.constraint(equalTo: storyScrollView.bottomAnchor),
            storyStackView.leadingAnchor.constraint(equalTo: storyScrollView.leadingAnchor),
            storyStackView.trailingAnchor.constraint(equalTo: storyScrollView.trailingAnchor),
            storyStackView.widthAnchor.constraint(equalTo: storyScrollView.widthAnchor)
        ])
        
        // 뒤로가기 버튼
        backButton.setImage(UIImage(named: "back_arrow_icon"), for: .normal)
        backButton.tintColor = .white
        backButton.backgroundColor = UIColor(white: 0, alpha: 0.5)
        backButton.layer.cornerRadius = 22
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    // 이 메서드는 외부에서 스토리 파트를 추가할 때 사용합니다.
    func addStoryPart(part: StoryPart) {
        let storyPartView = UIView()
        let dialogueLabel = UILabel()
        dialogueLabel.text = "[\(part.speaker)] \(part.text)"
        dialogueLabel.numberOfLines = 0
        dialogueLabel.textColor = .black
        dialogueLabel.font = UIFont.systemFont(ofSize: 16)
        
        storyPartView.addSubview(dialogueLabel)
        dialogueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dialogueLabel.topAnchor.constraint(equalTo: storyPartView.topAnchor, constant: 10),
            dialogueLabel.bottomAnchor.constraint(equalTo: storyPartView.bottomAnchor, constant: -10),
            dialogueLabel.leadingAnchor.constraint(equalTo: storyPartView.leadingAnchor, constant: 10),
            dialogueLabel.trailingAnchor.constraint(equalTo: storyPartView.trailingAnchor, constant: -10)
        ])
        
        storyPartView.backgroundColor = part.speaker == "로키" ? UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.7) : UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.7)
        storyPartView.layer.cornerRadius = 10
        
        storyStackView.addArrangedSubview(storyPartView)
        
        storyScrollView.layoutIfNeeded()
        let bottomOffset = CGPoint(x: 0, y: storyScrollView.contentSize.height - storyScrollView.bounds.size.height)
        if bottomOffset.y > 0 {
            storyScrollView.setContentOffset(bottomOffset, animated: true)
        }
    }
}
