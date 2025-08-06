//
//  MemoryViewController.swift
//  LociTravel
//
//  Created by dkkim on 8/6/25.
//

import UIKit

/// 퀘스트의 상세 ‘이야기’를 보여주는 화면
class MemoryViewController: UIViewController {
    // ① QuestList에서 전달받은 storyKey
    var storyKey: String?
    
    // ② 내용을 보여줄 UITextView (스크롤 가능)
    private let textView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isEditable = false                // 읽기 전용
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.textColor = .darkGray
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupNavigationBar()
        setupTextView()
       // loadContent()   // ✨ 초보자 주석: storyKey에 맞는 텍스트를 불러와서 textView에 세팅
    }
    
    // MARK: - 네비게이션 바 설정
    private func setupNavigationBar() {
        title = "탐험 이야기"        // 기본 타이틀
        navigationItem.largeTitleDisplayMode = .never
    }
    
    // MARK: - UITextView 배치
    private func setupTextView() {
        view.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - 콘텐츠 불러오기
//    private func loadContent() {
//        guard let key = storyKey else {
//            textView.text = "불러올 이야기가 없습니다."
//            return
//        }
//        
//        // ✨ 초보자 주석:
//        // LocalModel 같은 곳에 미리 storyKey별 텍스트를 저장해 두었다고 가정하고 불러옵니다.
//        // 이 부분은 실제 데이터 구조에 맞춰 바꿔주세요.
//        let allStories = UserModel.shared.storyTexts  // [String: String] 딕셔너리
//        if let story = allStories[key] {
//            textView.text = story
//        } else {
//            textView.text = "아직 준비된 내용이 없어요."
//        }
//    }
}
