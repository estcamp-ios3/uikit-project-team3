//
//  ScenarioViewController.swift
//  TimeTravel
//
//  Created by chohoseo on 7/30/25.

import UIKit
import AVFoundation

class ScenarioViewController: UIViewController {
    var bgmPlayer: AVAudioPlayer?
    var isMusicOn = true
    var spotName: String

    // MARK: - 대사 데이터
    var story: Story
    var dialogues: [(speaker: String, line: String)]
    var currentDialogueIndex = 0

    //0809 추가
    // ✅ [추가] 컨트롤러가 '임무시작 버튼을 숨길지' 여부를 보관
    private let showStartButton: Bool
    
    
    // MARK: - View
    private let scenarioView = ScenarioView()

    //0809 수정
    init(spotName: String, showStartButton: Bool = true){
        self.spotName = spotName
        self.story = StoryModel.shared.getStories(spotName: spotName)
        self.dialogues = self.story.arrScenario
        self.showStartButton = showStartButton
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = scenarioView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtonActions()
        updateDialogue()
        applyEntryMode() //0809 추가
         updateDialogue() //0809 추가 ← 그 다음 현재 대사에 맞춰 토글
        playBackgroundMusic()
        
 

        try? AVAudioSession.sharedInstance().setCategory(.playback)
        try? AVAudioSession.sharedInstance().setActive(true)
    }
    
    //0809 추가
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 🔵 이 화면에서는 시스템 네비바 숨김(왼쪽 상단 Back 제거)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 0809 추가🔵 '뒤로가기(pop)'로 리스트로 돌아갈 때만 네비바 복구
            if isMovingFromParent {
                navigationController?.setNavigationBarHidden(false, animated: false)
            }
        bgmPlayer?.stop()
    }


    
    // 0809 추가 ✅ 컨트롤러 클래스 내부에 있는 함수만 유지
    private func applyEntryMode() {
        // 버튼은 ScenarioView 안에 있으므로 scenarioView를 통해 접근
        scenarioView.startQuestButton.isEnabled = showStartButton
        // 숨김은 페이지(대사) 진행에 따라 updateDialogue에서 처리하도록 두고,
        // 여기서는 '활성/비활성'만 고정해두면 깔끔합니다.
    }
    
    
    
    
    private func setupButtonActions() {
        scenarioView.prevButton.addTarget(self, action: #selector(prevDialogue), for: .touchUpInside)
        scenarioView.nextButton.addTarget(self, action: #selector(nextDialogue), for: .touchUpInside)
        scenarioView.startQuestButton.addTarget(self, action: #selector(startQuest), for: .touchUpInside)
        scenarioView.musicToggleButton.addTarget(self, action: #selector(toggleMusic), for: .touchUpInside)
        scenarioView.questionButton.addTarget(self, action: #selector(showDetailView), for: .touchUpInside)
        scenarioView.backButton.addTarget(self, action: #selector(backToMain), for: .touchUpInside)
    }
    
    @objc func backToMain() {
        navigationController?.popViewController(animated: true)
    }

    func playBackgroundMusic() {
        guard let url = Bundle.main.url(forResource: story.bgm, withExtension: "mp4") else {
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

            if player.volume < 0.08 {
                player.volume += 0.02
            } else {
                timer.invalidate()
                player.volume = 0.08
            }
        }
    }

    @objc func toggleMusic() {
        if isMusicOn {
            bgmPlayer?.pause()
            scenarioView.musicToggleButton.setImage(UIImage(systemName: "headphones.slash"), for: .normal)
        } else {
            playBackgroundMusic()
            scenarioView.musicToggleButton.setImage(UIImage(systemName: "headphones"), for: .normal)
        }
        isMusicOn.toggle()
    }

    func updateDialogue() {
        let dialogue = dialogues[currentDialogueIndex]
        scenarioView.nameLabel.text = dialogue.speaker
        scenarioView.dialogueLabel.text = dialogue.line
        scenarioView.characterImageView.image = UIImage(named: dialogue.speaker)
        scenarioView.backgroundImageView.image = UIImage(named: story.scenarioImage)
        
        scenarioView.prevButton.isHidden = currentDialogueIndex == 0

        if currentDialogueIndex == dialogues.count - 1 {
            scenarioView.nextButton.isHidden = true
            
            //0809 추가 수정
            scenarioView.startQuestButton.isHidden = !showStartButton
            scenarioView.startQuestButton.isEnabled = showStartButton
        } else {
            scenarioView.nextButton.isHidden = false
            scenarioView.startQuestButton.isHidden = true
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
        let questVC = QuestMapViewController(spotName: spotName)
        navigationController?.pushViewController(questVC, animated: true)
    }
    
    @objc func showDetailView() {
        bgmPlayer?.stop()
        let detailVC = SpotDetailViewController()
        detailVC.spotName = spotName
        navigationController?.pushViewController(detailVC, animated: true)
        //detailVC.modalPresentationStyle = .fullScreen
        //present(detailVC, animated: true)
    }
}

#Preview{
    ScenarioViewController(spotName: "서동공원")
}
