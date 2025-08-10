// ScenarioView.swift

import UIKit

class ScenarioView: UIView {

    // MARK: - UI
    let backgroundImageView = UIImageView()
    let leftCharacterImageView = UIImageView()   // ← 추가
    let rightCharacterImageView = UIImageView()  // ← 추가

    let dialogueBoxView = UIView()
    let nameLabel = UILabel()
    let dialogueLabel = UILabel()
    let prevButton = UIButton()
    let nextButton = UIButton()
    let startQuestButton = UIButton()
    let musicToggleButton = UIButton()
    let questionButton = UIButton()
    let backButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func setup() {
        backgroundColor = .systemBackground

        // 1) 배경
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundImageView)

        // 2) 좌/우 캐릭터
        for iv in [leftCharacterImageView, rightCharacterImageView] {
            iv.contentMode = .scaleAspectFit
            iv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(iv)
        }

        // 3) 대화 상자
        dialogueBoxView.backgroundColor = UIColor.brown.withAlphaComponent(0.95)
        dialogueBoxView.layer.cornerRadius = 8
        dialogueBoxView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(dialogueBoxView)

        // 4) 라벨
        nameLabel.font = .boldSystemFont(ofSize: 16)
        nameLabel.textColor = .white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        dialogueBoxView.addSubview(nameLabel)

        dialogueLabel.font = .systemFont(ofSize: 16)
        dialogueLabel.textColor = .white
        dialogueLabel.numberOfLines = 0
        dialogueLabel.translatesAutoresizingMaskIntoConstraints = false
        dialogueBoxView.addSubview(dialogueLabel)

        // 5) 버튼
        questionButton.setTitle("?", for: .normal)
        questionButton.titleLabel?.font = .boldSystemFont(ofSize: 24)
        questionButton.translatesAutoresizingMaskIntoConstraints = false
        dialogueBoxView.addSubview(questionButton)

        prevButton.setTitle("←", for: .normal)
        prevButton.titleLabel?.font = .boldSystemFont(ofSize: 24)
        prevButton.translatesAutoresizingMaskIntoConstraints = false
        dialogueBoxView.addSubview(prevButton)

        nextButton.setTitle("→", for: .normal)
        nextButton.titleLabel?.font = .boldSystemFont(ofSize: 24)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        dialogueBoxView.addSubview(nextButton)

        startQuestButton.setTitle("임무 시작", for: .normal)
        startQuestButton.setTitleColor(.white, for: .normal)
        startQuestButton.backgroundColor = .systemOrange
        startQuestButton.layer.cornerRadius = 10
        startQuestButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        startQuestButton.isHidden = true
        startQuestButton.translatesAutoresizingMaskIntoConstraints = false
        dialogueBoxView.addSubview(startQuestButton)

        musicToggleButton.setImage(UIImage(systemName: "headphones"), for: .normal)
        musicToggleButton.tintColor = .white
        musicToggleButton.translatesAutoresizingMaskIntoConstraints = false
        dialogueBoxView.addSubview(musicToggleButton)

        let backButtonImage = UIImage(named: "button_back_icon")?.withRenderingMode(.alwaysTemplate)
        backButton.setImage(backButtonImage, for: .normal)
        backButton.tintColor = .white
        backButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backButton)

        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

            backButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            backButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8),
            backButton.widthAnchor.constraint(equalToConstant: 30),
            backButton.heightAnchor.constraint(equalToConstant: 30),

            // 좌측 캐릭터
            leftCharacterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            leftCharacterImageView.bottomAnchor.constraint(equalTo: dialogueBoxView.topAnchor, constant: 20),
            leftCharacterImageView.widthAnchor.constraint(equalToConstant: 200),
            leftCharacterImageView.heightAnchor.constraint(equalToConstant: 300),

            // 우측 캐릭터
            rightCharacterImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            rightCharacterImageView.bottomAnchor.constraint(equalTo: dialogueBoxView.topAnchor, constant: 20),
            rightCharacterImageView.widthAnchor.constraint(equalToConstant: 200),
            rightCharacterImageView.heightAnchor.constraint(equalToConstant: 300),

            dialogueBoxView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            dialogueBoxView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            dialogueBoxView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8),
            dialogueBoxView.heightAnchor.constraint(equalToConstant: 200),

            musicToggleButton.topAnchor.constraint(equalTo: dialogueBoxView.topAnchor, constant: 8),
            musicToggleButton.trailingAnchor.constraint(equalTo: dialogueBoxView.trailingAnchor, constant: -8),
            musicToggleButton.widthAnchor.constraint(equalToConstant: 30),
            musicToggleButton.heightAnchor.constraint(equalToConstant: 30),

            questionButton.centerYAnchor.constraint(equalTo: musicToggleButton.centerYAnchor),
            questionButton.trailingAnchor.constraint(equalTo: musicToggleButton.leadingAnchor, constant: -8),
            questionButton.widthAnchor.constraint(equalToConstant: 30),
            questionButton.heightAnchor.constraint(equalToConstant: 30),

            nameLabel.topAnchor.constraint(equalTo: dialogueBoxView.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: dialogueBoxView.leadingAnchor, constant: 20),

            dialogueLabel.centerYAnchor.constraint(equalTo: dialogueBoxView.centerYAnchor, constant: -4),
            dialogueLabel.leadingAnchor.constraint(equalTo: dialogueBoxView.leadingAnchor, constant: 30),
            dialogueLabel.trailingAnchor.constraint(equalTo: dialogueBoxView.trailingAnchor, constant: -30),
            dialogueLabel.bottomAnchor.constraint(equalTo: dialogueBoxView.bottomAnchor, constant: -8),

            prevButton.bottomAnchor.constraint(equalTo: dialogueBoxView.bottomAnchor, constant: -10),
            prevButton.leadingAnchor.constraint(equalTo: dialogueBoxView.leadingAnchor, constant: 8),
            prevButton.widthAnchor.constraint(equalToConstant: 30),

            nextButton.bottomAnchor.constraint(equalTo: dialogueBoxView.bottomAnchor, constant: -10),
            nextButton.trailingAnchor.constraint(equalTo: dialogueBoxView.trailingAnchor, constant: -8),
            nextButton.widthAnchor.constraint(equalToConstant: 30),

            startQuestButton.centerXAnchor.constraint(equalTo: dialogueBoxView.centerXAnchor),
            startQuestButton.bottomAnchor.constraint(equalTo: dialogueBoxView.bottomAnchor, constant: -12),
            startQuestButton.heightAnchor.constraint(equalToConstant: 40),
            startQuestButton.widthAnchor.constraint(equalToConstant: 120)
        ])
    }

    // 말하는 사람 강조/비강조
    func emphasize(leftActive: Bool?, rightActive: Bool?) {
        // nil이면 해당 캐릭터 없음
        let activeAlpha: CGFloat = 1.0
        let idleAlpha: CGFloat = 0

        if let leftActive = leftActive {
            leftCharacterImageView.alpha = leftActive ? activeAlpha : idleAlpha
        } else {
            leftCharacterImageView.alpha = 0
        }
        if let rightActive = rightActive {
            rightCharacterImageView.alpha = rightActive ? activeAlpha : idleAlpha
        } else {
            rightCharacterImageView.alpha = 0
        }
    }
}
