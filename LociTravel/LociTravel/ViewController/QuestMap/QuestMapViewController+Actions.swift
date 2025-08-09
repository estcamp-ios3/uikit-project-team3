import UIKit

extension QuestMapViewController {
    func setupActions() {
        questView.closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        questView.musicToggleButton.addTarget(self, action: #selector(toggleMusic), for: .touchUpInside)
        questView.questionButton.addTarget(self, action: #selector(showDetailView), for: .touchUpInside)
    }

    @objc func showDetailView() {
        bgmPlayer?.stop()
        let vc = SpotDetailViewController()
        vc.spotName = spotName
        present(vc, animated: true)
    }

    @objc func close() {
        navigationController?.popViewController(animated: true)
    }

    @objc func toggleMusic() {
        if isMusicOn {
            bgmPlayer?.pause()
            questView.musicToggleButton.setImage(UIImage(systemName: "headphones.slash"), for: .normal)
        } else {
            bgmPlayer?.play()
            questView.musicToggleButton.setImage(UIImage(systemName: "headphones"), for: .normal)
        }
        isMusicOn.toggle()
    }
}
