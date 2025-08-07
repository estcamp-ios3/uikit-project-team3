//
//  QuestCardView.swift
//  LociTravel
//
//  Created by suji chae on 8/5/25.
//

import UIKit

class QuestCardView: UITableViewCell {
    static let identifier = "QuestCardView"
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let completeStatusLabel = UILabel()
    
    // 🔧 ① 카드가 탭됐다는 신호를 외부로 전달할 클로저 프로퍼티 추가
    //        여기 안에 할당된 작업(onTap?())이 카드 터치 시 실행됩니다.
    var onTap: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        //setupTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        
        
        
        //        // 1️⃣ 배경 이미지뷰 추가: 에셋에 추가한 이미지 이름으로 변경
        //        let backgroundImageView = UIImageView(image: UIImage(named: "questviewbackground"))
        //        backgroundImageView.contentMode = .scaleToFill
        //        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        //        contentView.addSubview(backgroundImageView)
        //        //   backButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: -5)
        //        NSLayoutConstraint.activate([
        //            backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
        //            backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
        //            backgroundImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
        //            backgroundImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        //        ])
        //        
        //        // 2️⃣ 텍스트 스택뷰 추가
        //        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, completeStatusLabel])
        //        stackView.axis = .vertical
        //        stackView.spacing = 10
        //        stackView.translatesAutoresizingMaskIntoConstraints = false
        //        contentView.addSubview(stackView)
        //        
        //        NSLayoutConstraint.activate([
        //            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
        //            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
        //            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 60),
        //            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 20)
        //        ])
        //
        //        
        //        // 3️⃣ 라벨 스타일 설정
        //        titleLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        //        descriptionLabel.font = UIFont.systemFont(ofSize: 15)
        //        completeStatusLabel.font = UIFont.systemFont(ofSize: 13, weight: .light)
        //        
        //        titleLabel.textColor = .black
        //        descriptionLabel.textColor = .blue
        //        completeStatusLabel.textColor = .systemGreen
        //    }
        
        
        
        
        // MARK: - 탭 제스처
        //        private func setupTapGesture() {
        //            contentView.isUserInteractionEnabled = true
        //            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        //            contentView.addGestureRecognizer(tap)
        //        }
        //        @objc private func handleTap() {
        //            // 카드가 탭되면 여기에 설정된 onTap 클로저를 실행
        //            onTap?()   // ✨ QuestListViewController에서 이 자리에 화면 전환 코드를 넣어줄 거예요.
        //        }
        
        
        /// Quest 모델을 받아 화면 업데이트
        func configure(with quest: Quest) {
            titleLabel.text = quest.questName
            descriptionLabel.text = quest.questDetail
            completeStatusLabel.text = quest.isCompleted ? "완료" : "진행 중"
            completeStatusLabel.textColor = quest.isCompleted ? .systemGreen : .systemOrange
        }
    }
}

#Preview {
    QuestListViewController()
}
