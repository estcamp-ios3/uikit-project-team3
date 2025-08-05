//
//  StoryView.swift
//  TimeTravel
//
//  Created by chohoseo on 7/30/25.
//

import UIKit
import AVFoundation

class StoryView: UIViewController {
    var bgmPlayer: AVAudioPlayer?
    let musicToggleButton = UIButton()
    var isMusicOn = true
    
    var themeName: String
    var spotName: String
    
    // MARK: - UI 구성요소
    let backgroundImageView = UIImageView()
    let characterImageView = UIImageView()
    
    let dialogueBoxView = UIView()
    let nameLabel = UILabel()
    let dialogueLabel = UILabel()
    let prevButton = UIButton()
    let nextButton = UIButton()
    let startQuestButton = UIButton()
    
    // MARK: - 대사 데이터
    var scenario: Scenario
    var dialogues: [(speaker: String, line: String)]
    var currentDialogueIndex = 0
    
    init(themeName: String, spotName: String){
        self.themeName = themeName
        self.spotName = spotName
        self.scenario = ScenarioModel.shared.getScenarios(themeName: themeName, spotName: spotName)
        self.dialogues = self.scenario.arrScenario
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        try? AVAudioSession.sharedInstance().setActive(true)
        
        setupLayout()
        updateDialogue()
        playBackgroundMusic()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 화면이 사라질 때 자동으로 음악 종료
        bgmPlayer?.stop()
    }
    
    func playBackgroundMusic() {
        guard let url = Bundle.main.url(forResource: scenario.bgm, withExtension: "mp4") else {
            print("❗️배경음악 파일을 찾을 수 없습니다.")
            return
        }
        do {
            bgmPlayer = try AVAudioPlayer(contentsOf: url)
            bgmPlayer?.numberOfLoops = -1
            bgmPlayer?.volume = 0.0
            bgmPlayer?.prepareToPlay()
            bgmPlayer?.play()
            fadeInVolume()
        } catch {
            print("🎵 음악 재생 오류:", error)
        }
    }
    
    func fadeInVolume() {
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { timer in
            guard let player = self.bgmPlayer else {
                timer.invalidate()
                return
            }
            
            if player.volume < 0.3 {
                player.volume += 0.02
            } else {
                timer.invalidate()
                player.volume = 0.3
            }
        }
    }
    
    @objc func toggleMusic() {
        if isMusicOn {
            bgmPlayer?.pause()
            musicToggleButton.setImage(UIImage(systemName: "headphones.slash"), for: .normal)
        } else {
            playBackgroundMusic()
            musicToggleButton.setImage(UIImage(systemName: "headphones"), for: .normal)
        }
        isMusicOn.toggle()
    }
    
    func setupLayout() {
        view.backgroundColor = .black
        
        // 1. 배경 이미지
        backgroundImageView.image = UIImage(named: scenario.scenarioImage) // 예: "background.png"
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImageView)
        
        // 2. 캐릭터 이미지 (오른쪽 하단 고정)
        characterImageView.image = UIImage(named: scenario.characterImage) // 예: "yuna.png"
        characterImageView.contentMode = .scaleAspectFit
        characterImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(characterImageView)
        
        // 3. 대화 상자 배경
        dialogueBoxView.backgroundColor = UIColor.brown.withAlphaComponent(0.95)
        dialogueBoxView.layer.cornerRadius = 8
        dialogueBoxView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dialogueBoxView)
        
        // 4. 이름 라벨
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.textColor = .white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 5. 대사 라벨
        dialogueLabel.font = UIFont.systemFont(ofSize: 16)
        dialogueLabel.textColor = .white
        dialogueLabel.numberOfLines = 0
        dialogueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 6. 버튼
        prevButton.setTitle("←", for: .normal)
        prevButton.titleLabel?.font = .boldSystemFont(ofSize: 24)
        prevButton.addTarget(self, action: #selector(prevDialogue), for: .touchUpInside)
        
        nextButton.setTitle("→", for: .normal)
        nextButton.titleLabel?.font = .boldSystemFont(ofSize: 24)
        nextButton.addTarget(self, action: #selector(nextDialogue), for: .touchUpInside)
        
        // 퀘스트 시작 버튼
        startQuestButton.setTitle("미션 시작", for: .normal)
        startQuestButton.setTitleColor(.white, for: .normal)
        startQuestButton.backgroundColor = .systemOrange
        startQuestButton.layer.cornerRadius = 10
        startQuestButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        startQuestButton.isHidden = true
        startQuestButton.addTarget(self, action: #selector(startQuest), for: .touchUpInside)
        
        musicToggleButton.setImage(UIImage(systemName: "headphones"), for: .normal)
        musicToggleButton.tintColor = .white
        musicToggleButton.addTarget(self, action: #selector(toggleMusic), for: .touchUpInside)
        
        [nameLabel, dialogueLabel, prevButton, nextButton, startQuestButton, musicToggleButton].forEach {
            dialogueBoxView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // MARK: - AutoLayout 설정
        NSLayoutConstraint.activate([
            // 배경
            backgroundImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            //배경음악 토글 버튼
            musicToggleButton.topAnchor.constraint(equalTo: dialogueBoxView.topAnchor, constant: 10),
            musicToggleButton.trailingAnchor.constraint(equalTo: dialogueBoxView.trailingAnchor, constant: -16),
            musicToggleButton.widthAnchor.constraint(equalToConstant: 30),
            musicToggleButton.heightAnchor.constraint(equalToConstant: 30),
            
            // 캐릭터 이미지
            characterImageView.bottomAnchor.constraint(equalTo: dialogueBoxView.topAnchor, constant: 20),
            characterImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            characterImageView.widthAnchor.constraint(equalToConstant: 200),
            characterImageView.heightAnchor.constraint(equalToConstant: 300),
            
            // 대화 상자
            dialogueBoxView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dialogueBoxView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            dialogueBoxView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            dialogueBoxView.heightAnchor.constraint(equalToConstant: 140),
            
            // 이름 라벨
            nameLabel.topAnchor.constraint(equalTo: dialogueBoxView.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: dialogueBoxView.leadingAnchor, constant: 20),
            
            // 대사
            dialogueLabel.centerYAnchor.constraint(equalTo: dialogueBoxView.centerYAnchor, constant: -4),
            dialogueLabel.leadingAnchor.constraint(equalTo: dialogueBoxView.leadingAnchor, constant: 30),
            dialogueLabel.trailingAnchor.constraint(equalTo: dialogueBoxView.trailingAnchor, constant: -30),
            dialogueLabel.bottomAnchor.constraint(equalTo: dialogueBoxView.bottomAnchor, constant: -8),
            
            // 좌우 버튼
            prevButton.bottomAnchor.constraint(equalTo: dialogueBoxView.bottomAnchor, constant: -10),
            prevButton.leadingAnchor.constraint(equalTo: dialogueBoxView.leadingAnchor, constant: 8),
            prevButton.widthAnchor.constraint(equalToConstant: 30),
            
            nextButton.bottomAnchor.constraint(equalTo: dialogueBoxView.bottomAnchor, constant: -10),
            nextButton.trailingAnchor.constraint(equalTo: dialogueBoxView.trailingAnchor, constant: -8),
            nextButton.widthAnchor.constraint(equalToConstant: 30),
            
            // 퀘스트시작 버튼
            startQuestButton.centerXAnchor.constraint(equalTo: dialogueBoxView.centerXAnchor),
            startQuestButton.bottomAnchor.constraint(equalTo: dialogueBoxView.bottomAnchor, constant: -12),
            startQuestButton.heightAnchor.constraint(equalToConstant: 40),
            startQuestButton.widthAnchor.constraint(equalToConstant: 120),
            
            //음악 재생 버튼
            musicToggleButton.topAnchor.constraint(equalTo: dialogueBoxView.topAnchor, constant: 8),
            musicToggleButton.trailingAnchor.constraint(equalTo: dialogueBoxView.trailingAnchor, constant: -8),
            musicToggleButton.widthAnchor.constraint(equalToConstant: 30),
            musicToggleButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    // MARK: - 대사 제어
    func updateDialogue() {
        let dialogue = dialogues[currentDialogueIndex]
        nameLabel.text = dialogue.speaker
        dialogueLabel.text = dialogue.line
        characterImageView.image = UIImage(named: dialogue.speaker)
        prevButton.isHidden = currentDialogueIndex == 0
        
        if currentDialogueIndex == dialogues.count - 1 {
            nextButton.isHidden = true
            startQuestButton.isHidden = false
        } else {
            nextButton.isHidden = false
            startQuestButton.isHidden = true
        }
    }
    
    @objc func prevDialogue() {
        guard currentDialogueIndex > 0 else { return }
        currentDialogueIndex -= 1
        updateDialogue()
    }
    
    @objc func nextDialogue() {
        guard currentDialogueIndex < dialogues.count - 1 else { return }
        currentDialogueIndex += 1
        updateDialogue()
    }
    
    @objc func startQuest() {
        bgmPlayer?.stop()
        
        // 퀘스트 맵 또는 다음 화면으로 이동
        let questVC = QuestMapView(themeName: themeName, spotName: spotName)
        questVC.modalPresentationStyle = .fullScreen
        present(questVC, animated: true)
    }
}

#Preview {
    StoryView(themeName: "잊혀진 유산", spotName: "미륵사지")
}
