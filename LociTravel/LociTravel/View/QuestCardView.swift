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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .clear
        
        let backgroundImageView = UIImageView(image: UIImage(named: "quest_card_background"))
        backgroundImageView.contentMode = .scaleToFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(backgroundImageView)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            backgroundImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            backgroundImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, completeStatusLabel])
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30)
        ])

        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        descriptionLabel.font = UIFont.systemFont(ofSize: 15)
        completeStatusLabel.font = UIFont.systemFont(ofSize: 13, weight: .light)
        
        titleLabel.textColor = .black
        descriptionLabel.textColor = .darkGray
        completeStatusLabel.textColor = .systemGreen
    }
    
    func configure(with quest: Quest) {
        titleLabel.text = quest.questName
        descriptionLabel.text = quest.questDetail
        completeStatusLabel.text = quest.isCompleted ? "완료" : "진행 중"
        completeStatusLabel.textColor = quest.isCompleted ? .systemGreen : .systemOrange
    }
}
