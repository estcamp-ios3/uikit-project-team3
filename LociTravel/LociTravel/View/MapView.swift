//
//  MapView.swift
//  LociTravel
//
//  Created by suji chae on 8/5/25.
//

import UIKit

final class MapView: UIView {

    // MARK: - Top UI
    let mapImageView = UIImageView()
    let backButton   = UIButton(type: .system)

    // 오른쪽 상단 버튼들(카메라 ← 설정)
    let optionButton = UIButton(type: .system)
    let cameraButton = UIButton(type: .system)
    private let topRightBar = UIStackView()

    // MARK: - Place Buttons
    let seodongParkButton    = UIButton(type: .system)
    let wanggungriButton     = UIButton(type: .system)
    let jewelryButton        = UIButton(type: .system)
    let mireuksaButton       = UIButton(type: .system)
    let seodongMarketButton  = UIButton(type: .system)

    // MARK: - Labels
    let seodongMarketLabel = UILabel()
    let jewelryLabel       = UILabel()
    let mirueksaLabel      = UILabel()
    let seodongParkLabel   = UILabel()
    let wanggungriLabel    = UILabel()

    //로키 이미지
    let lokiImageView = UIImageView()
    
    // 진행도(텍스트)
    let progressLabel = UILabel()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        setupUI()
        DispatchQueue.main.async { [weak self] in self?.drawDashedArrows() }
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Public API (Controller가 호출)
    func setOptionMenu(_ menu: UIMenu) {
        optionButton.menu = menu
        optionButton.showsMenuAsPrimaryAction = true
    }
    
    func applyQuestButtonStates(_ states: [String: Bool]) {
        // 스팟 이름 → 버튼 매핑
        let buttonForName: [String: UIButton] = [
            "서동시장": seodongMarketButton,
            "보석 박물관": jewelryButton,
            "미륵사지": mireuksaButton,
            "서동공원": seodongParkButton,
            "왕궁리 유적": wanggungriButton
        ]
        for (name, enabled) in states {
            guard let button = buttonForName[name] else { continue }
            button.isEnabled = enabled
            button.alpha = enabled ? 1.0 : 0.3
        }
    }
    
    func setCameraButtonVisible(_ visible: Bool) {
        cameraButton.isHidden = !visible
        cameraButton.alpha = visible ? 1 : 0
        cameraButton.isEnabled = visible
    }

    func connectCameraButton(target: Any, action: Selector) {
        cameraButton.addTarget(target, action: action, for: .touchUpInside)
    }

    func connectOptionButton(target: Any, action: Selector) {
        optionButton.addTarget(target, action: action, for: .touchUpInside)
    }

    // MARK: - UI
    private func setupUI() {
        // Map
        mapImageView.image = UIImage(named: "oldmap3")
        mapImageView.contentMode = .scaleAspectFit
        mapImageView.clipsToBounds = true

        // Back
        let backButtonImage = UIImage(named: "button_back_icon")?.withRenderingMode(.alwaysTemplate)
        backButton.setImage(backButtonImage, for: .normal)
        backButton.tintColor = .white

        // Top Right Bar (카메라 ← 설정)
        topRightBar.axis = .horizontal
        topRightBar.alignment = .center
        topRightBar.spacing = 12

        // Option
        optionButton.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
        optionButton.tintColor = .white
        optionButton.setPreferredSymbolConfiguration(.init(pointSize: 24), forImageIn: .normal)

        // Camera
        cameraButton.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        cameraButton.tintColor = .white
        cameraButton.setPreferredSymbolConfiguration(.init(pointSize: 24), forImageIn: .normal)
        cameraButton.isHidden = true

        // Assemble top bar
        topRightBar.addArrangedSubview(cameraButton)
        topRightBar.addArrangedSubview(optionButton)

        // Labels common style
        [seodongMarketLabel, jewelryLabel, mirueksaLabel, seodongParkLabel, wanggungriLabel].forEach {
            $0.textColor = .black
            $0.textAlignment = .center
            $0.font = .systemFont(ofSize: 20, weight: .bold)
        }
        seodongMarketLabel.text = "서동시장"
        jewelryLabel.text       = "보석 박물관"
        mirueksaLabel.text      = "미륵사지"
        seodongParkLabel.text   = "서동공원"
        wanggungriLabel.text    = "왕궁리 유적"

        // Buttons images
        seodongMarketButton.setImage(UIImage(named: "seodongmarketButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        jewelryButton.setImage(UIImage(named: "jewelryButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        mireuksaButton.setImage(UIImage(named: "mireuksaButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        seodongParkButton.setImage(UIImage(named: "seodongparkButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        wanggungriButton.setImage(UIImage(named: "wanggungriButton")?.withRenderingMode(.alwaysOriginal), for: .normal)

        // Progress
        progressLabel.textColor = .white
        progressLabel.font = .systemFont(ofSize: 22, weight: .bold)
        progressLabel.textAlignment = .center
        
        // 로키 이미지 설정
        lokiImageView.image = UIImage(named: "mapview_loki")
        lokiImageView.contentMode = .scaleAspectFit

        // Add subviews
        [mapImageView, backButton,
         seodongParkButton, wanggungriButton, jewelryButton, mireuksaButton, seodongMarketButton,
         seodongMarketLabel, jewelryLabel, mirueksaLabel, seodongParkLabel, wanggungriLabel,
         topRightBar, progressLabel, lokiImageView].forEach { addSubview($0); $0.translatesAutoresizingMaskIntoConstraints = false }

        // Constraints
        NSLayoutConstraint.activate([
            mapImageView.topAnchor.constraint(equalTo: topAnchor),
            mapImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 10),
            mapImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapImageView.trailingAnchor.constraint(equalTo: trailingAnchor),

            // Back
            backButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            backButton.widthAnchor.constraint(equalToConstant: 50),
            backButton.heightAnchor.constraint(equalToConstant: 50),

            // Top Right Bar
            topRightBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            topRightBar.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),

            // Progress
            progressLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            progressLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            progressLabel.heightAnchor.constraint(equalToConstant: 30),
            
            // loki
            lokiImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            lokiImageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 65),
                lokiImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),  // 기존 0.8 -> 0.45
                lokiImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.45) // 기존 0.6 -> 0.35
        ])

        // Ensure buttons don't stretch
        [cameraButton, optionButton].forEach {
            $0.setContentHuggingPriority(.required, for: .horizontal)
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        }

        // Absolute placement (kept as in your design)
        let screenW = UIScreen.main.bounds.width
        let screenH = UIScreen.main.bounds.height

        // 서동시장
        place(pin: seodongMarketButton, label: seodongMarketLabel,
              size: 80,
              x: (screenW - 80)/2 + 130,
              y: (screenH - 80)/2 - 180)

        // 보석박물관
        place(pin: jewelryButton, label: jewelryLabel,
              size: 70,
              x: (screenW - 70)/2 - 80,
              y: (screenH - 70)/2 - 130)

        // 미륵사지
        place(pin: mireuksaButton, label: mirueksaLabel,
              size: 80,
              x: (screenW - 80)/2,
              y: (screenH - 80)/2)

        // 서동공원
        place(pin: seodongParkButton, label: seodongParkLabel,
              size: 80,
              x: (screenW - 80)/2 + 140,
              y: (screenH - 80)/2 + 80)

        // 왕궁리 유적
        place(pin: wanggungriButton, label: wanggungriLabel,
              size: 80,
              x: (screenW - 80)/2 - 100,
              y: (screenH - 80)/2 + 200)
    }

    private func place(pin: UIButton, label: UILabel, size: CGFloat, x: CGFloat, y: CGFloat) {
        NSLayoutConstraint.activate([
            pin.leadingAnchor.constraint(equalTo: leadingAnchor, constant: x),
            pin.topAnchor.constraint(equalTo: topAnchor, constant: y),
            pin.widthAnchor.constraint(equalToConstant: size),
            pin.heightAnchor.constraint(equalToConstant: size),

            label.topAnchor.constraint(equalTo: pin.bottomAnchor, constant: -10),
            label.centerXAnchor.constraint(equalTo: pin.centerXAnchor)
        ])
    }

    // MARK: - Dotted Path
    private func drawDashedArrows() {
        let pathOrder = [
            seodongMarketButton,
            jewelryButton,
            mireuksaButton,
            seodongParkButton,
            wanggungriButton
        ]

        for i in 0 ..< (pathOrder.count - 1) {
            let start = pathOrder[i].center
            let end   = pathOrder[i + 1].center

            let path = UIBezierPath()
            path.move(to: start)
            path.addLine(to: end)

            let line = CAShapeLayer()
            line.strokeColor = UIColor.darkGray.cgColor
            line.lineWidth = 3
            line.lineDashPattern = [6, 4]
            line.fillColor = UIColor.clear.cgColor
            line.path = path.cgPath
            layer.addSublayer(line)

            // arrow head
            let angle = atan2(end.y - start.y, end.x - start.x)
            let arrowSize: CGFloat = 15
            let p1 = CGPoint(x: end.x - arrowSize * cos(angle - .pi / 6),
                             y: end.y - arrowSize * sin(angle - .pi / 6))
            let p2 = CGPoint(x: end.x - arrowSize * cos(angle + .pi / 6),
                             y: end.y - arrowSize * sin(angle + .pi / 6))

            let arrow = UIBezierPath()
            arrow.move(to: end)
            arrow.addLine(to: p1)
            arrow.addLine(to: p2)
            arrow.close()

            let head = CAShapeLayer()
            head.fillColor = UIColor.darkGray.cgColor
            head.path = arrow.cgPath
            layer.addSublayer(head)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // 기존 라인 제거 후 다시 그림(버튼 위치 변동 대응)
        layer.sublayers?.filter { $0 is CAShapeLayer }.forEach { $0.removeFromSuperlayer() }
        drawDashedArrows()
    }
}
