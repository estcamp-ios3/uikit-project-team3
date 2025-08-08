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
 
    // ⬇️⬇️ [추가] 전환 중 렌더링 부하를 줄이기 위한 플래그
       private var rasterizedForPop = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("BG loaded:", UIImage(named: "questlistviewbackground") != nil)
        
        quests = QuestModel.shared.getAllQuests()

        setupBackgroundImage()    // 🔧 배경 이미지 설정 메서드 호출
        setupTableView()
        navigationItem.hidesBackButton = true
        setupCustomBackButton()
        setupNavBarTitle() // 🔧 추가: 타이틀 중앙 고정
        
        // ✨ [추가/이동] 네비바 외형 설정은 한 번만(여기서) 해두세요.
            //    매 pop 때마다 appearance를 새로 만드는 비용을 줄여 전환을 부드럽게 합니다.
            let ap = UINavigationBarAppearance()
            ap.configureWithTransparentBackground()
            ap.titleTextAttributes = [
                .foregroundColor: UIColor.label,
                .font: UIFont.systemFont(ofSize: 20, weight: .bold)
            ]
            navigationController?.navigationBar.standardAppearance = ap
            navigationController?.navigationBar.scrollEdgeAppearance = ap
    }
    
    // 🔧 [추가] 이 화면이 나타날 때 네비게이션 바를 다시 보이게 만듭니다.
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
             navigationController?.setNavigationBarHidden(false, animated: false) // ← 핵심
            // 스와이프-뒤로 제스처 켜두기(있으면 자연스러움)
               navigationController?.interactivePopGestureRecognizer?.delegate = nil
               navigationController?.interactivePopGestureRecognizer?.isEnabled = true
            
            // ✨ [추가] 이전에 선택된 셀을 자연스럽게 해제(복귀 시 깔끔)
                if let idx = tableView.indexPathForSelectedRow {
                    tableView.deselectRow(at: idx, animated: true)
                }
        }
    
    // ⬇️⬇️ [추가] '뒤로가기 팝' 직전에 테이블을 래스터라이즈(평면화)해서
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent { // ← 진짜 '뒤로'로 나갈 때만
            rasterizedForPop = true
            tableView.layer.shouldRasterize = true
            tableView.layer.rasterizationScale = UIScreen.main.scale
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if rasterizedForPop {
            rasterizedForPop = false
            tableView.layer.shouldRasterize = false
        }
    }
    
   //  MARK: - 배경 이미지 설정
        private func setupBackgroundImage() {
            // 🔎 배경 에셋 로딩 확인
                let name = "questlistviewbackground"
                print("[QuestList] BG '\(name)' loaded:", UIImage(named: name) != nil)
            
            // 1️⃣ 배경용 UIImageView 생성
            let bgImageView = UIImageView(image: UIImage(named: "questlistviewbackground"))
            bgImageView.contentMode = .scaleAspectFill
            bgImageView.translatesAutoresizingMaskIntoConstraints = false

            view.insertSubview(bgImageView, at: 0) // 🔧 가장 뒤에 깔기

            // 2️⃣ Auto Layout으로 view 전체에 꽉 채우기
            NSLayoutConstraint.activate([
                bgImageView.topAnchor.constraint(equalTo: view.topAnchor),
                bgImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                bgImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                bgImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        }
    
    // MARK: "탐험일지 타이틀"
    private func setupNavBarTitle() {
        let titleLabel = UILabel()
        titleLabel.text = "탐험일지"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .label
        navigationItem.titleView = titleLabel   // ← 항상 가운데 배치
    }
    
    // MARK: - 🔧 커스텀 Back 버튼
       private func setupCustomBackButton() {
           // 에셋에 ic_nav_back(또는 원하는 이미지) 추가. 없으면 SF Symbol 대체
           let image = UIImage(named: "backbutton") ?? UIImage(systemName: "chevron.left")

           let button = UIButton(type: .system)
           button.setImage(image, for: .normal)
           button.tintColor = .white                       // 아이콘 색
           button.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)

           // 버튼을 BarButtonItem으로 포장
           let barItem = UIBarButtonItem(customView: button)
           navigationItem.leftBarButtonItem = barItem

           // 크기 제약(아이콘이 너무 작/크게 보일 때)
           button.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               button.widthAnchor.constraint(equalToConstant: 32),
               button.heightAnchor.constraint(equalToConstant: 32)
           ])

           // (선택) 스와이프-뒤로 제스처 유지
           navigationController?.interactivePopGestureRecognizer?.delegate = nil
           navigationController?.interactivePopGestureRecognizer?.isEnabled = true
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
    
    @objc private func didTapBack() {
           navigationController?.popViewController(animated: true) // ← 뒤로가기 동작
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
        let memoryVC = MemoryViewController(regionName: selectedQuest.spotName) // ✅ 지역 이름 전달
        tableView.deselectRow(at: indexPath, animated: true)
          navigationController?.pushViewController(memoryVC, animated: true)
    }
}
