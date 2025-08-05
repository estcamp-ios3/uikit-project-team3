//
//  HomeView.swift
//  LociTravel
//
//  Created by suji chae on 8/5/25.
//

import UIKit
import SnapKit

final class HomeView: UIView {
    
    // MARK: - UI Components
    let backgroundImageView = UIImageView()
    let portalImageView = UIImageView()
    let titleLabel = UILabel()
    let navigationStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        // 배경 이미지 (익산 미륵사지 일러스트)
        addSubview(backgroundImageView)
        backgroundImageView.image = UIImage(named: "home_background_illustration")
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 앱 제목
        addSubview(titleLabel)
        titleLabel.text = "장소의 기억"
        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 32)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(40)
            make.centerX.equalToSuperview()
        }
        
        // 중앙 포털 및 로키 이미지
        addSubview(portalImageView)
        portalImageView.image = UIImage(named: "loki_portal_illustration")
        portalImageView.contentMode = .scaleAspectFit
        portalImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(snp.width).multipliedBy(0.8)
            make.height.equalTo(portalImageView.snp.width)
        }
        
        // 하단 내비게이션 버튼 스택
        let mapButton = createNavButton(iconName: "map")
        let questButton = createNavButton(iconName: "flag.checkered")
        let recordsButton = createNavButton(iconName: "book")
        
        navigationStackView.addArrangedSubview(mapButton)
        navigationStackView.addArrangedSubview(questButton)
        navigationStackView.addArrangedSubview(recordsButton)
        navigationStackView.axis = .horizontal
        navigationStackView.distribution = .fillEqually
        navigationStackView.spacing = 20
        
        addSubview(navigationStackView)
        navigationStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.width.equalToSuperview().multipliedBy(0.8)
        }
    }
    
    private func createNavButton(iconName: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: iconName), for: .normal)
        button.tintColor = .white
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        button.layer.cornerRadius = 20
        button.backgroundColor = .systemBrown.withAlphaComponent(0.7)
        return button
    }
}
