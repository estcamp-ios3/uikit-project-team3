//
//  QuestListViewController.swift
//  LociTravel
//
//  Created by suji chae on 8/5/25.
//

import UIKit
import CoreLocation

class QuestListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let tableView = UITableView()
    
    private var quests: [Quest]!
    //private var quests: [Quest] = []
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quests = QuestModel.shared.getAllQuests()
        setupBackgroundImage()    // 🔧 배경 이미지 설정 메서드 호출
        setupTableView()
        setupUI()
    }
    
    
    
    // MARK: - 배경 이미지 설정
        private func setupBackgroundImage() {
            // 1️⃣ 배경용 UIImageView 생성
            let bgImageView = UIImageView(image: UIImage(named: "testbackgroundimg"))
            bgImageView.contentMode = .scaleAspectFill
            bgImageView.translatesAutoresizingMaskIntoConstraints = false

            view.addSubview(bgImageView)
            view.sendSubviewToBack(bgImageView)

            // 2️⃣ Auto Layout으로 view 전체에 꽉 채우기
            NSLayoutConstraint.activate([
                bgImageView.topAnchor.constraint(equalTo: view.topAnchor),
                bgImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                bgImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                bgImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        }
    
    // MARK: - 테이블 뷰 세팅
        private func setupTableView() {
            view.addSubview(tableView)
            tableView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
            
            tableView.dataSource = self
            tableView.delegate   = self
            tableView.backgroundColor = .clear
            tableView.separatorStyle  = .none
            
            // 커스텀 셀 등록
            tableView.register(QuestCardView.self, forCellReuseIdentifier: QuestCardView.identifier)
        }
    
    private func setupUI() {
        title = "탐험 일지"
        view.backgroundColor = .clear
        
        //view.addSubview(tableView)
        //tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(QuestCardView.self, forCellReuseIdentifier: QuestCardView.identifier)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
        //        navigationController?.setNavigationBarHidden(false, animated: false)
        //        let backButton = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: #selector(didTapBackButton))
        //        navigationItem.leftBarButtonItem = backButton
        //    }
    }
    
    @objc private func didTapBackButton() {
        // 내비게이션 스택에 push된 경우 pop, 모달로 present된 경우 dismiss
        if let nav = navigationController {
            nav.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: QuestCardView.identifier, for: indexPath) as? QuestCardView else {
            return UITableViewCell()
        }
        let quest = quests[indexPath.row]
        cell.configure(with: quest)
        
//        // ✨ 주석: 카드가 탭되면 이 클로저가 실행됩니다.
//               cell.onTap = { [weak self] in
//                   guard let self = self else { return }
//                   // 1) 메모리뷰 컨트롤러 생성
//                   let memoryVC = MemoryViewController()
//                   // 2) storyKey(또는 원하는 데이터)를 넘겨줍니다
//                   memoryVC.storyKey = quest.storyKey
//                   // 3) 네비게이션 푸시
//                   self.navigationController?.pushViewController(memoryVC, animated: true)
//               }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedQuest = quests[indexPath.row]
        let spotDetailVC = SpotDetailViewController()
        navigationController?.pushViewController(spotDetailVC, animated: true)
    }
}
