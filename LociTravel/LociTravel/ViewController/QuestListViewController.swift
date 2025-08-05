//
//  QuestListViewController.swift
//  LociTravel
//
//  Created by suji chae on 8/5/25.
//

import UIKit

class QuestListViewController: UIViewController {

    private let questListView = QuestListView()
    
    // MARK: - 퀘스트 데이터 (예시)
    private let quests = [
        ("미륵사지 탐험", "미륵사지의 숨겨진 역사를 찾아보세요.", "진행 중"),
        ("왕궁리 유적 탐사", "왕궁리 유적에 숨겨진 백제의 보물을 찾으세요.", "미완료"),
        ("쌍릉의 비밀", "무왕과 선화공주의 전설이 깃든 쌍릉을 방문하세요.", "완료")
    ]
    
    override func loadView() {
        view = questListView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
    }
    
    private func setupNavigationBar() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .black
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        questListView.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.width.height.equalTo(44)
        }
    }

    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }

    private func setupTableView() {
        questListView.tableView.dataSource = self
        questListView.tableView.delegate = self
        questListView.tableView.register(QuestCardCell.self, forCellReuseIdentifier: "QuestCardCell")
    }
}

extension QuestListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quests.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestCardCell", for: indexPath) as! QuestCardCell
        let quest = quests[indexPath.row]
        cell.questCardView.configure(title: quest.0, description: quest.1, status: quest.2)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // 퀘스트 상세 화면으로 이동
    }
}

// 퀘스트 카드 뷰를 담을 테이블 뷰 셀
class QuestCardCell: UITableViewCell {
    let questCardView = QuestCardView()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.addSubview(questCardView)
        questCardView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20))
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
