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
        
        print("BG loaded:", UIImage(named: "questlistviewbackground") != nil)
        
        quests = QuestModel.shared.getAllQuests()
        
        // 🔧 [추가] 리스트 화면 배경 이미지 지정
//            let background = UIImageView(image: UIImage(named: "questlistviewbackground")) // ← 첨부한 배경 이미지 이름
//            background.contentMode = .scaleAspectFill
//            tableView.backgroundView = background                         // ← 테이블 뒤에 깔기
//            tableView.backgroundColor = .clear                    // ← 검은색 제거
        
        setupBackgroundImage()    // 🔧 배경 이미지 설정 메서드 호출
        setupTableView()
      //  setupUI()
        navigationItem.hidesBackButton = true
        setupCustomBackButton()
        setupNavBarTitle() // 🔧 추가: 타이틀 중앙 고정
        
    }
    
    // 🔧 [추가] 이 화면이 나타날 때 네비게이션 바를 다시 보이게 만듭니다.
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationController?.setNavigationBarHidden(false, animated: animated) // ← 핵심
            
            // 🔧 투명 내비바 + 타이틀 스타일 유지
                let ap = UINavigationBarAppearance()
                ap.configureWithTransparentBackground()
                ap.titleTextAttributes = [
                    .foregroundColor: UIColor.label,
                    .font: UIFont.systemFont(ofSize: 20, weight: .bold)
                ]
                navigationController?.navigationBar.standardAppearance = ap
                navigationController?.navigationBar.scrollEdgeAppearance = ap
            
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
//           button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)

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
    
//    private func setupUI() {
//        title = "탐험 일지"
//        view.backgroundColor = .clear
//        
//        //view.addSubview(tableView)
//        //tableView.translatesAutoresizingMaskIntoConstraints = false
////        NSLayoutConstraint.activate([
////            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
////            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
////            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
////            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
////        ])
////        
////        tableView.dataSource = self
////        tableView.delegate = self
////        tableView.register(QuestCardView.self, forCellReuseIdentifier: QuestCardView.identifier)
////        tableView.backgroundColor = .clear
////        tableView.separatorStyle = .none
//        
//        //        navigationController?.setNavigationBarHidden(false, animated: false)
//        //        let backButton = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: #selector(didTapBackButton))
//        //        navigationItem.leftBarButtonItem = backButton
//        //    }
//    }
    
    
    @objc private func didTapBack() {
           navigationController?.popViewController(animated: true) // ← 뒤로가기 동작
       }
    
//    @objc private func didTapBackButton() {
//        // 내비게이션 스택에 push된 경우 pop, 모달로 present된 경우 dismiss
//        if let nav = navigationController {
//            nav.popViewController(animated: true)
//        } else {
//            dismiss(animated: true, completion: nil)
//        }
//    }

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
