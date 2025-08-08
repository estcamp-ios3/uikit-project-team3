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
   
    // 🔧 [수정] 셀 배경 이미지뷰를 프로퍼티로 승격 (나중에 이미지 교체 가능)
    private let bgImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill   // 필요시 .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let statusDotView = UIView()
    private let completeStatusLabel = UILabel()
    private lazy var statusStack: UIStackView = {
        let s = UIStackView(arrangedSubviews: [statusDotView, completeStatusLabel])
        s.axis = .horizontal
        s.alignment = .center
        s.spacing = 6
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()
    
    // 🔧 점 크기 제약(폰트 크기에 맞춰 업데이트)
        private var dotW: NSLayoutConstraint!
        private var dotH: NSLayoutConstraint!
   
    
    
    // 🔧 ① 카드가 탭됐다는 신호를 외부로 전달할 클로저 프로퍼티 추가
    //        여기 안에 할당된 작업(onTap?())이 카드 터치 시 실행됩니다.
    // var onTap: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        
        
        // 배경화면
        //   가장자리 왜곡이 싫으면 capInsets로 늘려쓰세요.
        let defaultBG = UIImage(named: "questlistviewcell")?.resizableImage(
            withCapInsets: UIEdgeInsets(top: 40, left: 60, bottom: 40, right: 60),
            resizingMode: .stretch
        )
        bgImageView.image = defaultBG
        
        contentView.addSubview(bgImageView)
        NSLayoutConstraint.activate([
            bgImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            bgImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            bgImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            bgImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
        
        
        // ⭐ 파피루스 내부 패딩(모든 라벨이 안쪽에 머물도록)
        let insetTop: CGFloat = 14
        let insetLeft: CGFloat = 24
        let insetRight: CGFloat = 18
        let insetBottom: CGFloat = 12
        
        // 텍스트 스택 (제목 + 설명)
        let textStack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        textStack.axis = .vertical
        textStack.spacing = 3                      // 🔧 1) 전체 간격 축소
        textStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textStack)
        NSLayoutConstraint.activate([
            textStack.topAnchor.constraint(equalTo: bgImageView.topAnchor, constant: insetTop),
            textStack.leadingAnchor.constraint(equalTo: bgImageView.leadingAnchor, constant: insetLeft),
            textStack.trailingAnchor.constraint(equalTo: bgImageView.trailingAnchor, constant: -insetRight),
            textStack.bottomAnchor.constraint(lessThanOrEqualTo: bgImageView.bottomAnchor, constant: -insetBottom)
        ])
        
        // 상태 스택(● + "진행 중/완료")
        completeStatusLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        completeStatusLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        statusDotView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statusDotView.widthAnchor.constraint(equalToConstant: 12), // ● 크기 12
            statusDotView.heightAnchor.constraint(equalToConstant: 12)
        ])
        statusDotView.layer.cornerRadius = 6
        statusDotView.clipsToBounds = true
        statusDotView.backgroundColor = .systemOrange
       
        statusStack.alignment = .center
          contentView.addSubview(statusStack)
          statusStack.translatesAutoresizingMaskIntoConstraints = false
          NSLayoutConstraint.activate([
              statusStack.trailingAnchor.constraint(equalTo: bgImageView.trailingAnchor, constant: -insetRight),
              // 🔧 제목과 같은 높이로 정렬 (이제 두 라벨 모두 계층 안에 있어서 OK)
              completeStatusLabel.firstBaselineAnchor.constraint(equalTo: titleLabel.firstBaselineAnchor)
          ])
        
        // 라벨 스타일
            titleLabel.font = .systemFont(ofSize: 25, weight: .bold)
            titleLabel.textColor = .black

            descriptionLabel.font = .systemFont(ofSize: 15)
            descriptionLabel.textColor = .systemBlue
            descriptionLabel.numberOfLines = 2
        }
        

    
    
    
    /// Quest 모델을 받아 화면 업데이트
    func configure(with quest: Quest) {
        titleLabel.text = quest.questName
        descriptionLabel.text = quest.questDetail
        
        if quest.isCompleted {
            completeStatusLabel.text = "완료"
            completeStatusLabel.textColor = .systemGreen
            statusDotView.backgroundColor = .systemGreen
        } else {
            completeStatusLabel.text = "진행 중"
            completeStatusLabel.textColor = .systemOrange
            statusDotView.backgroundColor = .systemOrange
        }
    }
    
    //        completeStatusLabel.text = quest.isCompleted ? "완료" : "진행 중"
    //        completeStatusLabel.textColor = quest.isCompleted ? .systemGreen : .systemOrange
    //.  }
}


