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
    // 장소 버튼
    let seodongParkButton = UIButton(type: .system)
    let wanggungriButton = UIButton(type: .system)
    let jewelryButton = UIButton(type: .system)
    let mireuksaButton = UIButton(type: .system)
    let seodongMarketButton = UIButton(type: .system)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
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
        
        
        NSLayoutConstraint.activate([
            mapImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            mapImageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            mapImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapImageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        
        // Back Button 이미지 설정 부분
        let backButtonImage = UIImage(named: "button_back_icon")?.withRenderingMode(.alwaysOriginal)
        backButton.setImage(backButtonImage, for: .normal)
        
        
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
        
    }
    
}




#Preview {
    MapView()
}
