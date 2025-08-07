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
    
    //0806 로드버튼 추가, 퀘스트리스트버튼 비활성화
    let loadButton = UIButton(type: .system)
    //let questListButton = UIButton(type: .system)

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
        
        //0806 로드버튼 추가, 퀘스트리스트버튼 비활성화
        addSubview(loadButton)
      //  addSubview(questListButton)

        // 모든 뷰에 Auto Layout 사용 설정 (필수!)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        lokiImageView.translatesAutoresizingMaskIntoConstraints = false
        startButton.translatesAutoresizingMaskIntoConstraints = false
        
        //0806 로드버튼 추가, 퀘스트리스트버튼 비활성화
        loadButton.translatesAutoresizingMaskIntoConstraints = false
       // questListButton.translatesAutoresizingMaskIntoConstraints = false

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
        titleLabel.font = UIFont.systemFont(ofSize: 50, weight: .bold)
        titleLabel.textColor = .white
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 70)
        ])

        // 로키 이미지 설정
        lokiImageView.image = UIImage(named: "")//loki_portal_illustration
        lokiImageView.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            lokiImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            lokiImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            lokiImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            lokiImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6)
        ])

        // 시작 버튼 설정
        startButton.setTitle("시작 하기", for: .normal)
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        startButton.backgroundColor = .systemBrown
        startButton.setTitleColor(.white, for: .normal)
        startButton.layer.cornerRadius = 25
        NSLayoutConstraint.activate([
            startButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            // 0806 로드버튼으로 수정
            startButton.bottomAnchor.constraint(equalTo: loadButton.topAnchor, constant: -20),
            startButton.widthAnchor.constraint(equalToConstant: 250),
            startButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        
        // 0806 로드 버튼 설정
        loadButton.setTitle("이어서 하기(개발중)", for: .normal)
        loadButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        loadButton.backgroundColor = .systemBrown
        loadButton.setTitleColor(.white, for: .normal) // 활성화 시 글자색
        loadButton.setTitleColor(.lightGray, for: .disabled)  // 비활성화 시 글자색
        loadButton.layer.cornerRadius = 25
        
        // 항상 비활성화
        loadButton.isEnabled = false      // ← 이 라인이 터치와 동작을 완전히 막아줍니다.
        loadButton.alpha = 0.5            // ← 투명도를 조절해 ‘눌리지 않음’을 강조
        
        
        
        NSLayoutConstraint.activate([
            loadButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -40),
            loadButton.widthAnchor.constraint(equalToConstant: 250),
            loadButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // 0806 비활성화
        // 탐험 일지 버튼 설정
//        questListButton.setTitle("탐험 일지", for: .normal)
//        questListButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
//        questListButton.backgroundColor = .systemGreen
//        questListButton.setTitleColor(.white, for: .normal)
//        questListButton.layer.cornerRadius = 25
//        NSLayoutConstraint.activate([
//            questListButton.centerXAnchor.constraint(equalTo: centerXAnchor),
//            questListButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -50),
//            questListButton.widthAnchor.constraint(equalToConstant: 250),
//            questListButton.heightAnchor.constraint(equalToConstant: 50)
//        ])
    }
}
