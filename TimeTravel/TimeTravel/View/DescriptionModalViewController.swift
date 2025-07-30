//
//  DescriptionModalViewController.swift
//  TimeTravel
//
//  Created by suji chae on 7/30/25.
//

import UIKit

class DescriptionModalViewController: UIViewController {
    
    private let fullDescription: String // 전체 설명을 받을 속성
    
    // MARK: - UI Components
    
    // closeButton을 lazy var로 변경하여 self 참조 시점을 지연시키고 클로저 기반 액션 사용
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("닫기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        // MARK: - 변경된 부분: 클로저 기반 액션 핸들러 사용
        button.addAction(UIAction { [weak self] _ in
            self?.closeButtonTapped()
        }, for: .touchUpInside)
        
        return button
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .darkGray
        textView.isEditable = false // 편집 불가능
        textView.isSelectable = true // 텍스트 선택 가능
        textView.alwaysBounceVertical = true // 내용이 짧아도 스크롤 효과
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = UIColor(white: 0.95, alpha: 1.0) // UI 구분을 위한 색상
        textView.layer.cornerRadius = 8
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15) // 텍스트 여백
        return textView
    }()
    
    // MARK: - Initialization
    
    init(fullDescription: String) {
        self.fullDescription = fullDescription
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground // 모달의 배경색
        setupUI()
        descriptionTextView.text = fullDescription // 받아온 전체 설명 표시
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.addSubview(descriptionTextView)
        view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            // 닫기 버튼 배치
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            closeButton.heightAnchor.constraint(equalToConstant: 44),
            
            // 설명 텍스트 뷰 배치
            descriptionTextView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 10),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            descriptionTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Actions
    
    //    @objc func closeButtonTapped() {
    //        dismiss(animated: true, completion: nil) // 모달 닫기
    
    private func closeButtonTapped() { // private으로 다시 변경 가능 (선택 사항)
            dismiss(animated: true, completion: nil)
    }
}
