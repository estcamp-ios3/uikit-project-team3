//
//  MapView.swift
//  LociTravel
//
//  Created by suji chae on 8/5/25.
//

import UIKit


class MapView: UIView {
    
    let mapImageView = UIImageView()
    let backButton = UIButton(type: .system)
    
    let optionButton = UIButton(type: .system)
    
    //옵션 버튼 안에 들어갈 코드
    
    // 3) 슬라이딩 메뉴 패널
    let menuView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 12
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    
    // 장소 버튼
    let seodongParkButton = UIButton(type: .system)
    let wanggungriButton = UIButton(type: .system)
    let jewelryButton = UIButton(type: .system)
    let mireuksaButton = UIButton(type: .system)
    let seodongMarketButton = UIButton(type: .system)
    // 레이블
    let seodongMarketLabel = UILabel()
    let jewelryLabel = UILabel()
    let mirueksaLabel = UILabel()
    let seodongParkLabel = UILabel()
    let wanggungriLabel = UILabel()
    
    
    let progressLabel = UILabel() // 퀘스트 진행 상황을 표시할 라벨
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        drawDashedArrows()
        self.backgroundColor = .black
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func setupUI() {
        addSubview(mapImageView)
        addSubview(backButton)
        addSubview(seodongParkButton)
        addSubview(wanggungriButton)
        addSubview(jewelryButton)
        addSubview(mireuksaButton)
        addSubview(seodongMarketButton)
        addSubview(seodongMarketLabel)
        addSubview(jewelryLabel)
        addSubview(mirueksaLabel)
        addSubview(seodongParkLabel)
        addSubview(wanggungriLabel)
        
        addSubview(optionButton)
        
        addSubview(progressLabel)
        
        
        mapImageView.image = UIImage(named: "oldmap3")
        mapImageView.contentMode = .scaleAspectFit
        mapImageView.clipsToBounds = true
        
        
        mapImageView.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        seodongParkButton.translatesAutoresizingMaskIntoConstraints = false
        wanggungriButton.translatesAutoresizingMaskIntoConstraints = false
        jewelryButton.translatesAutoresizingMaskIntoConstraints = false
        mireuksaButton.translatesAutoresizingMaskIntoConstraints = false
        seodongMarketButton.translatesAutoresizingMaskIntoConstraints = false
        
        seodongMarketLabel.translatesAutoresizingMaskIntoConstraints = false
        jewelryLabel.translatesAutoresizingMaskIntoConstraints = false
        mirueksaLabel.translatesAutoresizingMaskIntoConstraints = false
        seodongParkLabel.translatesAutoresizingMaskIntoConstraints = false
        wanggungriLabel.translatesAutoresizingMaskIntoConstraints = false
        
        optionButton.translatesAutoresizingMaskIntoConstraints = false
        
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mapImageView.topAnchor.constraint(equalTo: topAnchor),
            mapImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 10),
            mapImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapImageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        // 옵션 버튼 이미지 설정
        optionButton.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
        optionButton.tintColor = .white
        optionButton.setPreferredSymbolConfiguration(.init(pointSize: 30), forImageIn: .normal)
        
        //오토 레이아웃 제약
        NSLayoutConstraint.activate([
            // optionButton: safeArea 오른쪽 상단
            optionButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            optionButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
            optionButton.widthAnchor.constraint(equalToConstant: 30),
            optionButton.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        // Back Button 이미지 설정 부분
        let backButtonImage = UIImage(named: "button_back_icon")?.withRenderingMode(.alwaysTemplate)
        backButton.setImage(backButtonImage, for: .normal)
        //backButton.tintColor = UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1.0)
        backButton.tintColor = .white
        
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            
            backButton.widthAnchor.constraint(equalToConstant: 50),
            backButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // seodongMarketButton 이미지 설정 부분
        let pinImage5 = UIImage(named: "seodongmarketButton")?.withRenderingMode(.alwaysOriginal)
        seodongMarketButton.setImage(pinImage5, for: .normal)
        
        let buttonSize5: CGFloat = 80
        let buttonX5 = (UIScreen.main.bounds.width - buttonSize5) / 2 + 130
        let buttonY5 = (UIScreen.main.bounds.height - buttonSize5) / 2 - 180
        
        seodongMarketLabel.text = "서동시장"
        seodongMarketLabel.textColor = .black
        seodongMarketLabel.textAlignment = .center
        seodongMarketLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        
        NSLayoutConstraint.activate([
            seodongMarketButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: buttonX5),
            seodongMarketButton.topAnchor.constraint(equalTo: topAnchor, constant: buttonY5),
            seodongMarketButton.widthAnchor.constraint(equalToConstant: buttonSize5),
            seodongMarketButton.heightAnchor.constraint(equalToConstant: buttonSize5),
            
            seodongMarketLabel.topAnchor.constraint(equalTo: seodongMarketButton.bottomAnchor, constant: -10),
            seodongMarketLabel.centerXAnchor.constraint(equalTo: seodongMarketButton.centerXAnchor)
        ])
        
        // jewelryButton 이미지 설정 부분
        let pinImage3 = UIImage(named: "jewelryButton")?.withRenderingMode(.alwaysOriginal)
        jewelryButton.setImage(pinImage3, for: .normal)
        
        let buttonSize3: CGFloat = 70
        let buttonX3 = (UIScreen.main.bounds.width - buttonSize3) / 2 - 80
        let buttonY3 = (UIScreen.main.bounds.height - buttonSize3) / 2 - 130
        
        jewelryLabel.text = "보석박물관"
        jewelryLabel.textColor = .black
        jewelryLabel.textAlignment = .center
        jewelryLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        NSLayoutConstraint.activate([
            jewelryButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: buttonX3),
            jewelryButton.topAnchor.constraint(equalTo: topAnchor, constant: buttonY3),
            jewelryButton.widthAnchor.constraint(equalToConstant: buttonSize3),
            jewelryButton.heightAnchor.constraint(equalToConstant: buttonSize3),
            
            jewelryLabel.topAnchor.constraint(equalTo: jewelryButton.bottomAnchor, constant: -10),
            jewelryLabel.centerXAnchor.constraint(equalTo: jewelryButton.centerXAnchor)
        ])
        
        // mireuksaButton 이미지 설정 부분
        let pinImage4 = UIImage(named: "mireuksaButton")?.withRenderingMode(.alwaysOriginal)
        mireuksaButton.setImage(pinImage4, for: .normal)
        
        let buttonSize4: CGFloat = 80
        let buttonX4 = (UIScreen.main.bounds.width - buttonSize4) / 2
        let buttonY4 = (UIScreen.main.bounds.height - buttonSize4) / 2
        
        mirueksaLabel.text = "미륵사지"
        mirueksaLabel.textColor = .black
        mirueksaLabel.textAlignment = .center
        mirueksaLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        NSLayoutConstraint.activate([
            mireuksaButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: buttonX4),
            mireuksaButton.topAnchor.constraint(equalTo: topAnchor, constant: buttonY4),
            mireuksaButton.widthAnchor.constraint(equalToConstant: buttonSize4),
            mireuksaButton.heightAnchor.constraint(equalToConstant: buttonSize4),
            
            mirueksaLabel.topAnchor.constraint(equalTo: mireuksaButton.bottomAnchor, constant: -10),
            mirueksaLabel.centerXAnchor.constraint(equalTo: mireuksaButton.centerXAnchor)
        ])
        
        // seodongparkButton 이미지 설정 부분
        let pinImage = UIImage(named: "seodongparkButton")?.withRenderingMode(.alwaysOriginal)
        seodongParkButton.setImage(pinImage, for: .normal)
        
        let buttonSize: CGFloat = 80
        let buttonX = (UIScreen.main.bounds.width - buttonSize) / 2 + 140
        let buttonY = (UIScreen.main.bounds.height - buttonSize) / 2 + 80
        
        seodongParkLabel.text = "서동공원"
        seodongParkLabel.textColor = .black
        seodongParkLabel.textAlignment = .center
        seodongParkLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        NSLayoutConstraint.activate([
            seodongParkButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: buttonX),
            seodongParkButton.topAnchor.constraint(equalTo: topAnchor, constant: buttonY),
            seodongParkButton.widthAnchor.constraint(equalToConstant: buttonSize),
            seodongParkButton.heightAnchor.constraint(equalToConstant: buttonSize),
            
            seodongParkLabel.topAnchor.constraint(equalTo: seodongParkButton.bottomAnchor, constant: -10),
            seodongParkLabel.centerXAnchor.constraint(equalTo: seodongParkButton.centerXAnchor)
        ])
        
        // wanggungriButton 이미지 설정 부분
        let pinImage2 = UIImage(named: "wanggungriButton")?.withRenderingMode(.alwaysOriginal)
        wanggungriButton.setImage(pinImage2, for: .normal)
        
        let buttonSize2: CGFloat = 80
        let buttonX2 = (UIScreen.main.bounds.width - buttonSize2) / 2 - 100
        let buttonY2 = (UIScreen.main.bounds.height - buttonSize2) / 2 + 200
        
        wanggungriLabel.text = "왕궁리유적"
        wanggungriLabel.textColor = .black
        wanggungriLabel.textAlignment = .center
        wanggungriLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        NSLayoutConstraint.activate([
            wanggungriButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: buttonX2),
            wanggungriButton.topAnchor.constraint(equalTo: topAnchor, constant: buttonY2),
            wanggungriButton.widthAnchor.constraint(equalToConstant: buttonSize2),
            wanggungriButton.heightAnchor.constraint(equalToConstant: buttonSize2),
            
            wanggungriLabel.topAnchor.constraint(equalTo: wanggungriButton.bottomAnchor, constant: -10),
            wanggungriLabel.centerXAnchor.constraint(equalTo: wanggungriButton.centerXAnchor)
        ])
        
        
        progressLabel.textColor = .white
        progressLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        progressLabel.textAlignment = .center
        
        // MARK: - progressLabel 오토 레이아웃
        NSLayoutConstraint.activate([
            progressLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            progressLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            progressLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        
        
        DispatchQueue.main.async {
            self.drawDashedArrows()
        }
        
    }
    
    
    
    private func drawDashedArrows() {
        
        // 화살표 순서: seodongMarket -> jewelry -> mireuksa -> seodongPark -> wanggungri
        let pathOrder = [
            seodongMarketButton,
            jewelryButton,
            mireuksaButton,
            seodongParkButton,
            wanggungriButton
        ]
        
        for i in 0..<pathOrder.count - 1 {
            let startButton = pathOrder[i]
            let endButton = pathOrder[i+1]
            
            // 각 버튼의 중앙 좌표를 가져옵니다.
            let startPoint = startButton.center
            let endPoint = endButton.center
            
            let path = UIBezierPath()
            path.move(to: startPoint)
            path.addLine(to: endPoint)
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.strokeColor = UIColor.darkGray.cgColor // 화살표 색상
            shapeLayer.lineWidth = 3 // 화살표 두께
            shapeLayer.lineDashPattern = [6, 4] // [선 길이, 간격]
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.path = path.cgPath
            
            // 화살표 방향을 위한 삼각형 모양을 추가합니다.
            let arrowPath = UIBezierPath()
            let angle = atan2(endPoint.y - startPoint.y, endPoint.x - startPoint.x)
            let arrowSize: CGFloat = 15
            
            // 화살표 끝 부분의 좌표
            let arrowPoint1 = CGPoint(
                x: endPoint.x - arrowSize * cos(angle - .pi / 6),
                y: endPoint.y - arrowSize * sin(angle - .pi / 6)
            )
            let arrowPoint2 = CGPoint(
                x: endPoint.x - arrowSize * cos(angle + .pi / 6),
                y: endPoint.y - arrowSize * sin(angle + .pi / 6)
            )
            
            arrowPath.move(to: endPoint)
            arrowPath.addLine(to: arrowPoint1)
            arrowPath.addLine(to: arrowPoint2)
            arrowPath.close()
            
            let arrowLayer = CAShapeLayer()
            arrowLayer.fillColor = UIColor.darkGray.cgColor
            arrowLayer.path = arrowPath.cgPath
            
            // 점선과 화살표를 뷰에 추가합니다.
            self.layer.addSublayer(shapeLayer)
            self.layer.addSublayer(arrowLayer)
        }
    }
    
    
    // 이 메서드는 뷰의 크기가 변경될 때마다 화살표를 다시 그려줍니다.
    override func layoutSubviews() {
        super.layoutSubviews()
        // 기존에 그려진 모든 화살표 레이어를 제거합니다.
        self.layer.sublayers?.filter { $0 is CAShapeLayer }.forEach { $0.removeFromSuperlayer() }
        drawDashedArrows()
    }
    
    
}




#Preview {
    MapView()
}
