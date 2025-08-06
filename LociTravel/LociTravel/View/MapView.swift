//
//  MapView.swift
//  LociTravel
//
//  Created by suji chae on 8/5/25.
//

import UIKit
import MapKit

class MapView: UIView {
    let mapView = MKMapView()
    let backButton = UIButton(type: .system)
    
    let optionButton = UIButton(type: .system)
    
    // 옵션 버튼 안에 들어갈 코드
    
    // 3) 슬라이딩 메뉴 패널
        let menuView: UIView = {
            let v = UIView()
            v.backgroundColor = .white
            v.layer.cornerRadius = 12
            v.translatesAutoresizingMaskIntoConstraints = false
            return v
        }()
        var menuTopConstraint: NSLayoutConstraint!

        // 4) 메뉴 안 버튼들
        let mapButton: UIButton = {
            let btn = UIButton(type: .system)
            btn.setTitle("지도", for: .normal)
            btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
            btn.setTitleColor(.darkText, for: .normal)
            return btn
        }()
        let journalButton: UIButton = {
            let btn = UIButton(type: .system)
            btn.setTitle("탐험일지", for: .normal)
            btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
            btn.setTitleColor(.darkText, for: .normal)
            return btn
        }()
        let recordBookButton: UIButton = {
            let btn = UIButton(type: .system)
            btn.setTitle("리코드북", for: .normal)
            btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
            btn.setTitleColor(.darkText, for: .normal)
            return btn
        }()
    
    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(mapView)
        addSubview(backButton)
        addSubview(optionButton)
        addSubview(menuView)
        
        // 메뉴 안 버튼은 menuView에 추가
               let stack = UIStackView(arrangedSubviews: [mapButton, journalButton, recordBookButton])
               stack.axis = .vertical
               stack.distribution = .fillEqually
               stack.translatesAutoresizingMaskIntoConstraints = false
               menuView.addSubview(stack)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        optionButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: topAnchor),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        backButton.setImage(UIImage(systemName: "chevron.left.circle.fill"), for: .normal)
        backButton.tintColor = .systemBlue
        backButton.setPreferredSymbolConfiguration(.init(pointSize: 40), forImageIn: .normal)
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
        
        optionButton.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
        optionButton.tintColor = .systemBlue
        optionButton.setPreferredSymbolConfiguration(.init(pointSize: 40), forImageIn: .normal)
        
        NSLayoutConstraint.activate([
            optionButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            optionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        
        
        // menuView: 가로 패딩 주고, 높이 고정, 초기 숨김(위치)
            menuView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                   menuView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                   menuView.heightAnchor.constraint(equalToConstant: 180),
               ])
               // 초기 Y 제약(화면 위로 숨김)
               menuTopConstraint = menuView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: -180)
               menuTopConstraint.isActive = true

               // stackView 제약: menuView 내부
               NSLayoutConstraint.activate([
                   stack.topAnchor.constraint(equalTo: menuView.topAnchor),
                   stack.bottomAnchor.constraint(equalTo: menuView.bottomAnchor),
                   stack.leadingAnchor.constraint(equalTo: menuView.leadingAnchor),
                   stack.trailingAnchor.constraint(equalTo: menuView.trailingAnchor),
               ])
        
    }
}
