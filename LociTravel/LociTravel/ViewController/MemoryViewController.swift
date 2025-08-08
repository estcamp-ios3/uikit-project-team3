//
//  MemoryViewController.swift
//  LociTravel
//
//  Created by dkkim on 8/6/25.
//

import UIKit

final class MemoryViewController: UIViewController {

    // ✅ 전달받는 매개변수(지역 이름)
    private let regionName: String

    // UI
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    private let titleLabel = UILabel()
    private let bodyLabel = UILabel()

    // MARK: - Init
    init(regionName: String) {
        self.regionName = regionName
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.95)

        setupNav()
        setupLayout()
        loadStory()   // ✅ StoryModel에서 지역 이름으로 스토리 로드
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 리스트/맵과 충돌 방지: 여기서는 네비바 보이기(무애니메이션)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    // MARK: - UI
    private func setupNav() {
        navigationItem.title = "스토리"
        navigationItem.hidesBackButton = true
        // 좌상단 닫기/뒤로 버튼
        let close = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                    style: .plain,
                                    target: self,
                                    action: #selector(didTapClose))
        navigationItem.leftBarButtonItem = close
    }

    private func setupLayout() {
        // 스크롤 + 스택(수직)
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        contentStack.axis = .vertical
        contentStack.spacing = 12

        scrollView.addSubview(contentStack)
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -16),
            contentStack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])

        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.numberOfLines = 0

        bodyLabel.font = .systemFont(ofSize: 16)
        bodyLabel.numberOfLines = 0

        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(bodyLabel)
    }

    // MARK: - Data
    private func loadStory() {
        // ✅ StoryModel에서 지역명 기반으로 로드
        let story = StoryModel.shared.getStory(for: regionName, preferPostMission: false)
        titleLabel.text = "\(story.spotName) — \(story.questName)"

           // 대사 배열을 본문 텍스트로 합치기
           bodyLabel.text = story.arrScenario
               .map { "\($0.speaker): \($0.line)" }
               .joined(separator: "\n\n")
    }

    // MARK: - Actions
    @objc private func didTapClose() {
        navigationController?.popViewController(animated: true) // ✅ 리스트로 복귀
    }
}
