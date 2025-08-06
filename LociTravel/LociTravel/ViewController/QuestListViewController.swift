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
    
    private var quests: [Quest] = [
        Quest(id: "quest_1", title: "미륵사지 석탑의 비밀", description: "백제 무왕과 선화공주의 전설이 깃든 곳...", location: CLLocationCoordinate2D(latitude: 35.9427, longitude: 126.9634), isCompleted: false, storyKey: "mireuksa_quest_intro"),
        Quest(id: "quest_2", title: "왕궁리 5층 석탑의 수수께끼", description: "천년의 시간을 품은 탑의 이야기를 들어보자.", location: CLLocationCoordinate2D(latitude: 35.9431, longitude: 127.0270), isCompleted: false, storyKey: "wanggungri_quest_intro"),
        Quest(id: "quest_3", title: "제석사지", description: "미륵사지 근처에 위치한 제석사지터.", location: CLLocationCoordinate2D(latitude: 35.9427, longitude: 126.9734), isCompleted: true, storyKey: "jesaksaji_quest_intro")
    ]
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
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
