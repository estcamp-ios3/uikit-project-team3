//
//  Untitled.swift
//  LociTravel
//
//  Created by suji chae on 8/5/25.
//

import UIKit
import SnapKit

final class QuestListView: UIView {
    
    // MARK: - UI Components
    let titleLabel = UILabel()
    let tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        // 뷰의 배경을 고서 질감으로 설정
        backgroundColor = UIColor(patternImage: UIImage(named: "old_paper_texture")!)

        // 제목
        addSubview(titleLabel)
        titleLabel.text = "로키의 탐험일지"
        titleLabel.textColor = .black
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalToSuperview()
        }
        
        // 퀘스트 목록 테이블 뷰
        addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
