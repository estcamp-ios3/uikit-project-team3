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
    let dialogues: [(speaker: String, line: String)] = [
        ("선화", "자아~~! 골라골라~!! 여기 질 좋은 비단있어요~!"),
        ("선화", "어휴.. 덥다 더워.. 날씨가 더우니 장사도 잘안되고.."),
        ("아주머니1", "고생 많구나 선화야~ 어서 여기 시~~원한 수박 먹어라"),
        ("선화", "역시 우리 이모~! 이렇게 더운 여름엔 수박이 최고지~!"),
        ("선화", "응? 왜 이렇게 사람들이 웅성대지?"),
        ("아주머니2", "아이고!! 나는 망했네~ 망했어 우리 딸 혼수품으로 줄 금가락지를 잃어버리다니~!!"),
        ("선화", "아주머니 진정하세요. 제가 도와드릴게요. 혹시 기억나는게 있으세요?"),
        ("아주머니2", "사물놀이패 장단에 맞춰 정신없이 엉덩이를 흔들다 보니 금가락지가 도망간 모양이야"),
        ("아주머니2", "장담컨데 분명 그전까진 있었다고. 이 근처 어딘가에 떨어졌을것 같긴한데.. "),
        ("선화", "(이 아줌마.. 정상아니군..) 걱정마세요~! ^^ 제가 도와드릴게요. 이 근방은 제가 빠삭하게 잘아니까 얼른 찾아드릴께요~!"),
        ("선화", "(히히 찾으면 내꺼라구~!!    \\(^,^)/")
    ]
    
    var currentDialogueIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        guard let url = Bundle.main.url(forResource: "market", withExtension: "mp4") else {
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
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
            guard let player = self.bgmPlayer else {
                timer.invalidate()
                return
            }
            
            if player.volume < 0.7 {
                player.volume += 0.03
            } else {
                timer.invalidate()
            }
        }
    }
    
    @objc func toggleMusic() {
        if isMusicOn {
            bgmPlayer?.pause()
            musicToggleButton.setImage(UIImage(systemName: "headphones.slash"), for: .normal)
        } else {
            bgmPlayer?.play()
            musicToggleButton.setImage(UIImage(systemName: "headphones"), for: .normal)
        }
        isMusicOn.toggle()
    }

    func setupLayout() {
        view.backgroundColor = .black
        
        // 1. 배경 이미지
        backgroundImageView.image = UIImage(named: "background") // 예: "background.png"
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImageView)

        // 2. 캐릭터 이미지 (오른쪽 하단 고정)
        characterImageView.image = UIImage(named: "girl") // 예: "yuna.png"
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
    }
    
    @objc func prevDialogue() {
        guard currentDialogueIndex > 0 else { return }
        currentDialogueIndex -= 1
        updateDialogue()
        
        //이전 대사로 돌아가면 버튼 상태 복구
        startQuestButton.isHidden = true
        nextButton.isHidden = false
    }
    
    @objc func nextDialogue() {
        if currentDialogueIndex < dialogues.count - 1 {
            currentDialogueIndex += 1
            updateDialogue()
        } else {
            // 버튼 전환 처리
            //prevButton.isHidden = true
            nextButton.isHidden = true
            startQuestButton.isHidden = false
        }
    }
    
    @objc func startQuest() {
        bgmPlayer?.stop()
        
        // 퀘스트 맵 또는 다음 화면으로 이동
        let questVC = QuestMapView() // 또는 QuestMapViewController()
        questVC.modalPresentationStyle = .fullScreen
        present(questVC, animated: true)
    }
}

#Preview {
    StoryView()
}
