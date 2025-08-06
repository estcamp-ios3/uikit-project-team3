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
        setupUI()
    }
    
    private func setupUI() {
        title = "탐험 일지"
        view.backgroundColor = .white
        
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
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        let backButton = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: #selector(didTapBackButton))
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
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
