//
//  HomeView.swift
//  LociTravel
//
//  Created by suji chae on 8/5/25.
//

import UIKit

class HomeView: UIView {
    let backgroundImageView = UIImageView()
    let titleLabel = UILabel()
    let lokiImageView = UIImageView()
    let startButton = UIButton(type: .system)
    let questListButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .white

        // 뷰 계층 구조 설정
        addSubview(backgroundImageView)
        addSubview(titleLabel)
        addSubview(lokiImageView)
        addSubview(startButton)
        addSubview(questListButton)

        // 모든 뷰에 Auto Layout 사용 설정 (필수!)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        lokiImageView.translatesAutoresizingMaskIntoConstraints = false
        startButton.translatesAutoresizingMaskIntoConstraints = false
        questListButton.translatesAutoresizingMaskIntoConstraints = false

        // 배경 이미지 설정
        backgroundImageView.image = UIImage(named: "home_background_illustration")
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        // 타이틀 레이블 설정
        titleLabel.text = "장소의 기억"
        titleLabel.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        titleLabel.textColor = .white
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 50)
        ])

        // 로키 이미지 설정
        lokiImageView.image = UIImage(named: "loki_portal_illustration")
        lokiImageView.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            lokiImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            lokiImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            lokiImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            lokiImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6)
        ])

        // 시작 버튼 설정
        startButton.setTitle("지도 보기", for: .normal)
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        startButton.backgroundColor = .systemBlue
        startButton.setTitleColor(.white, for: .normal)
        startButton.layer.cornerRadius = 25
        NSLayoutConstraint.activate([
            startButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            startButton.bottomAnchor.constraint(equalTo: questListButton.topAnchor, constant: -20),
            startButton.widthAnchor.constraint(equalToConstant: 250),
            startButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // 탐험 일지 버튼 설정
        questListButton.setTitle("탐험 일지", for: .normal)
        questListButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        questListButton.backgroundColor = .systemGreen
        questListButton.setTitleColor(.white, for: .normal)
        questListButton.layer.cornerRadius = 25
        NSLayoutConstraint.activate([
            questListButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            questListButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -50),
            questListButton.widthAnchor.constraint(equalToConstant: 250),
            questListButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
