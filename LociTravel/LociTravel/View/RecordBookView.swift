//
//  RecordBookView.swift
//  LociTravel
//
//  Created by suji chae on 8/11/25.
//

import UIKit

final class RecordBookView: UIView {

    // MARK: - Properties (UI Components)

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()

    let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "RecordBookviewbackground"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup (오토 레이아웃 직접 작성)

    private func setupView() {
        addSubview(backgroundImageView)
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            // 배경 이미지 뷰 제약 조건
            backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            // 테이블 뷰 제약 조건
            tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
