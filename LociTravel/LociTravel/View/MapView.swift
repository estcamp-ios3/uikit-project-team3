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
        
        addSubview(optionButton)
    
        
        
        
        mapImageView.image = UIImage(named: "oldmap")
        mapImageView.contentMode = .scaleAspectFill
        mapImageView.clipsToBounds = true
        
        
        mapImageView.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        seodongParkButton.translatesAutoresizingMaskIntoConstraints = false
        wanggungriButton.translatesAutoresizingMaskIntoConstraints = false
        jewelryButton.translatesAutoresizingMaskIntoConstraints = false
        mireuksaButton.translatesAutoresizingMaskIntoConstraints = false
        seodongMarketButton.translatesAutoresizingMaskIntoConstraints = false
        
        optionButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        NSLayoutConstraint.activate([
            mapImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            mapImageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            mapImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapImageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        // 옵션 버튼 이미지 설정
        optionButton.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
        optionButton.tintColor = .systemBlue
        optionButton.setPreferredSymbolConfiguration(.init(pointSize: 40), forImageIn: .normal)
        
        //오토 레이아웃 제약
        NSLayoutConstraint.activate([
            // optionButton: safeArea 오른쪽 상단
            optionButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            optionButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8),
            optionButton.widthAnchor.constraint(equalToConstant: 36),
            optionButton.heightAnchor.constraint(equalToConstant: 36),
        ])
        
        // Back Button 이미지 설정 부분
//        let backButtonImage = UIImage(named: "button_back_icon")?.withRenderingMode(.alwaysOriginal)
//        backButton.setImage(backButtonImage, for: .normal)
        
         // 이미지를 나중에 brown색으로 해보기
        let backButtonImage = UIImage(named: "button_back_icon")?.withRenderingMode(.alwaysTemplate)
        backButton.setImage(backButtonImage, for: .normal)
        backButton.tintColor = UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1.0)

        
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: -5),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            
            backButton.widthAnchor.constraint(equalToConstant: 100),
            backButton.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        
        // seodongparkButton 이미지 설정 부분
        let pinImage = UIImage(named: "seodongpark")?.withRenderingMode(.alwaysOriginal)
        seodongParkButton.setImage(pinImage, for: .normal)
        
        let buttonSize: CGFloat = 100
        let buttonX = (UIScreen.main.bounds.width - buttonSize) / 2
        let buttonY = (UIScreen.main.bounds.height - buttonSize) / 2 + 25
        
        NSLayoutConstraint.activate([
            seodongParkButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: buttonX),
            seodongParkButton.topAnchor.constraint(equalTo: topAnchor, constant: buttonY),
            seodongParkButton.widthAnchor.constraint(equalToConstant: buttonSize),
            seodongParkButton.heightAnchor.constraint(equalToConstant: buttonSize)
        ])
        
        // wanggungriButton 이미지 설정 부분
        let pinImage2 = UIImage(named: "wanggungri")?.withRenderingMode(.alwaysOriginal)
        wanggungriButton.setImage(pinImage2, for: .normal)
        
        let buttonSize2: CGFloat = 100
        let buttonX2 = (UIScreen.main.bounds.width - buttonSize2) / 2 + 50
        let buttonY2 = (UIScreen.main.bounds.height - buttonSize2) / 2 + 200
        
        NSLayoutConstraint.activate([
            wanggungriButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: buttonX2),
            wanggungriButton.topAnchor.constraint(equalTo: topAnchor, constant: buttonY2),
            wanggungriButton.widthAnchor.constraint(equalToConstant: buttonSize2),
            wanggungriButton.heightAnchor.constraint(equalToConstant: buttonSize2)
        ])
        
        // jewelryButton 이미지 설정 부분
        let pinImage3 = UIImage(named: "jewelry")?.withRenderingMode(.alwaysOriginal)
        jewelryButton.setImage(pinImage3, for: .normal)
        
        let buttonSize3: CGFloat = 100
        let buttonX3 = (UIScreen.main.bounds.width - buttonSize3) / 2 + 140
        let buttonY3 = (UIScreen.main.bounds.height - buttonSize3) / 2 + 70
        
        NSLayoutConstraint.activate([
            jewelryButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: buttonX3),
            jewelryButton.topAnchor.constraint(equalTo: topAnchor, constant: buttonY3),
            jewelryButton.widthAnchor.constraint(equalToConstant: buttonSize3),
            jewelryButton.heightAnchor.constraint(equalToConstant: buttonSize3)
        ])
        
        // mireuksaButton 이미지 설정 부분
        let pinImage4 = UIImage(named: "mireuksa")?.withRenderingMode(.alwaysOriginal)
        mireuksaButton.setImage(pinImage4, for: .normal)
        
        let buttonSize4: CGFloat = 100
        let buttonX4 = (UIScreen.main.bounds.width - buttonSize4) / 2 - 80
        let buttonY4 = (UIScreen.main.bounds.height - buttonSize4) / 2 - 130
        
        NSLayoutConstraint.activate([
            mireuksaButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: buttonX4),
            mireuksaButton.topAnchor.constraint(equalTo: topAnchor, constant: buttonY4),
            mireuksaButton.widthAnchor.constraint(equalToConstant: buttonSize4),
            mireuksaButton.heightAnchor.constraint(equalToConstant: buttonSize4)
        ])
        
        // marketButton 이미지 설정 부분
        let pinImage5 = UIImage(named: "seodongmarket")?.withRenderingMode(.alwaysOriginal)
        seodongMarketButton.setImage(pinImage5, for: .normal)
        
        let buttonSize5: CGFloat = 100
        let buttonX5 = (UIScreen.main.bounds.width - buttonSize5) / 2 - 130
        let buttonY5 = (UIScreen.main.bounds.height - buttonSize5) / 2 - 10
        
        NSLayoutConstraint.activate([
            seodongMarketButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: buttonX5),
            seodongMarketButton.topAnchor.constraint(equalTo: topAnchor, constant: buttonY5),
            seodongMarketButton.widthAnchor.constraint(equalToConstant: buttonSize5),
            seodongMarketButton.heightAnchor.constraint(equalToConstant: buttonSize5)
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
                shapeLayer.strokeColor = UIColor.brown.cgColor // 화살표 색상
                shapeLayer.lineWidth = 3 // 화살표 두께
                shapeLayer.lineDashPattern = [6, 6] // [선 길이, 간격]
                shapeLayer.fillColor = UIColor.clear.cgColor
                shapeLayer.path = path.cgPath
                
                // 화살표 방향을 위한 삼각형 모양을 추가합니다.
                let arrowPath = UIBezierPath()
                let angle = atan2(endPoint.y - startPoint.y, endPoint.x - startPoint.x)
                let arrowSize: CGFloat = 30
                
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
                arrowLayer.fillColor = UIColor.brown.cgColor
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
