//
//  HomeView.swift
//  LociTravel
//
//  Created by suji chae on 8/5/25.
//

import UIKit

class HomeView: UIView {
    let backgroundImageView = UIImageView()
    let titleImageView = UIImageView()
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
        addSubview(titleImageView)
        addSubview(titleLabel)
        addSubview(lokiImageView)
        addSubview(startButton)
        
        //0806 로드버튼 추가, 퀘스트리스트버튼 비활성화
        addSubview(loadButton)
      //  addSubview(questListButton)

        // 모든 뷰에 Auto Layout 사용 설정 (필수!)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        titleImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        lokiImageView.translatesAutoresizingMaskIntoConstraints = false
        startButton.translatesAutoresizingMaskIntoConstraints = false
        
        //0806 로드버튼 추가, 퀘스트리스트버튼 비활성화
        loadButton.translatesAutoresizingMaskIntoConstraints = false
       // questListButton.translatesAutoresizingMaskIntoConstraints = false

        // 배경 이미지 설정
        backgroundImageView.image = UIImage(named: "bluehomeviewbackground")
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        //타이틀 이미지 설정
        titleImageView.image = UIImage(named: "homeviewtitleclear")
        titleImageView.backgroundColor = .clear
        titleImageView.isOpaque = false
        titleImageView.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
        titleImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 24),
            titleImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9), // 화면 너비의 60%
            titleImageView.heightAnchor.constraint(equalToConstant: 150)                  // 높이는 취향껏
        ])
        
        // 타이틀 레이블 설정
        titleLabel.text = "장소의 기억"
        //titleLabel.font = UIFont.systemFont(ofSize: 50, weight: .bold)
        titleLabel.font = UIFont(name: "BMEULJIRO", size: 60)
        titleLabel.textColor = .black
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
      //  startButton.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        startButton.titleLabel?.font = UIFont(name: "BMEULJIRO", size: 30)
        startButton.setTitleColor(.brown, for: .normal)
        startButton.setTitleColor(UIColor.brown.withAlphaComponent(0.7), for: .highlighted)
        startButton.backgroundColor = .systemBlue
       // startButton.setTitleColor(.white, for: .normal)
        startButton.layer.cornerRadius = 25
        
        // 배경 이미지를 9-패치처럼 늘려쓰기 (모서리 보존용 inset 값은 이미지에 맞게 조정)
        let normalBG = UIImage(named: "homeviewStartButtonClear")?.resizableImage(
            withCapInsets: UIEdgeInsets(top: 14, left: 24, bottom: 14, right: 24),
            resizingMode: .stretch
        )
        let pressedBG = UIImage(named: "homeviewStartButtonClear")?.resizableImage(
            withCapInsets: UIEdgeInsets(top: 14, left: 24, bottom: 14, right: 24),
            resizingMode: .stretch
        )

        startButton.setBackgroundImage(normalBG, for: .normal)
        startButton.setBackgroundImage(pressedBG, for: .highlighted)

        // 기존 색/코너는 필요 없음
        startButton.backgroundColor = .clear
        startButton.layer.cornerRadius = 0

  
        
        
        NSLayoutConstraint.activate([
            startButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            // 0806 로드버튼으로 수정
            startButton.bottomAnchor.constraint(equalTo: loadButton.topAnchor, constant: -20),
            startButton.widthAnchor.constraint(equalToConstant: 250),
            startButton.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        
        // 0806 로드 버튼 설정
        loadButton.setTitle("이어서 하기(개발중)", for: .normal)
        loadButton.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        startButton.setTitleColor(.brown, for: .normal)
        startButton.setTitleColor(UIColor.brown.withAlphaComponent(0.7), for: .highlighted)
        loadButton.backgroundColor = .systemBrown
        loadButton.setTitleColor(.white, for: .normal) // 활성화 시 글자색
        loadButton.setTitleColor(.lightGray, for: .disabled)  // 비활성화 시 글자색
        loadButton.layer.cornerRadius = 25
        
        // 항상 비활성화
        loadButton.isEnabled = false      // ← 이 라인이 터치와 동작을 완전히 막아줍니다.
        loadButton.alpha = 0.9           // ← 투명도를 조절해 ‘눌리지 않음’을 강조
    

        loadButton.setBackgroundImage(normalBG, for: .normal)
        loadButton.setBackgroundImage(pressedBG, for: .highlighted)

        // 기존 색/코너는 필요 없음
        loadButton.backgroundColor = .clear
        loadButton.layer.cornerRadius = 0
        
        
        NSLayoutConstraint.activate([
            loadButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -40),
            loadButton.widthAnchor.constraint(equalToConstant: 250),
            loadButton.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        
        

    }
}

#Preview {
    HomeView()
}
