import AVFoundation

extension QuestMapViewController {
    func playBackgroundMusic() {
        guard let url = Bundle.main.url(forResource: quest.bgm, withExtension: "mp3") else {
            print("❗️BGM 파일 없음"); return
        }
        do {
            bgmPlayer = try AVAudioPlayer(contentsOf: url)
            bgmPlayer?.numberOfLoops = -1
            bgmPlayer?.volume = 0
            bgmPlayer?.prepareToPlay()
            bgmPlayer?.play()
            fadeInVolume()
        } catch { print("🎧 BGM 오류:", error) }
    }

    func fadeInVolume() {
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { t in
            guard let p = self.bgmPlayer else { t.invalidate(); return }
            if p.volume < 0.08 { p.volume += 0.02 } else { p.volume = 0.08; t.invalidate() }
        }
    }
}
