//
//  QuestCardView.swift
//  LociTravel
//
//  Created by suji chae on 8/5/25.
//

import UIKit
import SnapKit

final class QuestCardView: UIView {
    
    // MARK: - UI Components
    let cardBackgroundImageView = UIImageView()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let statusLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        // 카드 배경 (고서 말린 종이 일러스트)
        addSubview(cardBackgroundImageView)
        cardBackgroundImageView.image = UIImage(named: "quest_card_background")
        cardBackgroundImageView.contentMode = .scaleAspectFill
        cardBackgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 제목
        addSubview(titleLabel)
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        // 설명
        addSubview(descriptionLabel)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        // 상태
        addSubview(statusLabel)
        statusLabel.font = .boldSystemFont(ofSize: 14)
        statusLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    // 외부에서 데이터 설정용 함수
    func configure(title: String, description: String, status: String) {
        titleLabel.text = title
        descriptionLabel.text = description
        statusLabel.text = status
    }
}
