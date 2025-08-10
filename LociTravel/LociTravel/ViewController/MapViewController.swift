import UIKit
import MapKit

final class MapViewController: UIViewController {

    private let customMapView = MapView()

    // 퀘스트 순서
    private let questOrder = ["서동시장", "보석 박물관", "미륵사지", "서동공원", "왕궁리 유적"]

    // 이어하기 플래그
    private var resumeMode = false
    
    //0809추가 ✅ 완료 뱃지 식별 태그(중복 추가 방지용)
       private let COMPLETION_BADGE_TAG = 9001
    //0809추가 ✅ 버튼 <-> 퀘스트명 매핑
       //0809추가    ⬇️ 여기 “버튼 참조”는 실제 MapView의 아울렛 이름으로 교체하세요.
       private lazy var questButtons: [(name: String, button: UIButton)] = [
           (name: "서동시장",   button: customMapView.seodongMarketButton),
           (name: "보석 박물관", button: customMapView.jewelryButton),
           (name: "미륵사지",   button: customMapView.mireuksaButton),
           (name: "서동공원",   button: customMapView.seodongParkButton),
           (name: "왕궁리 유적", button: customMapView.wanggungriButton)
       ]
    
    

    // MARK: - Life Cycle
    override func loadView() { view = customMapView }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtonActions()
        setupTopMenu()
        
        //0809추가 🔔 진행도 변경 시 버튼 상태 다시 그리기
                NotificationCenter.default.addObserver(self,
                    selector: #selector(onProgressChanged),
                    name: .progressDidChange, object: nil)

        // 버튼 액션 연결
        customMapView.connectOptionButton(target: self, action: #selector(didTapOptionButton))
        customMapView.connectCameraButton(target: self, action: #selector(didTapCameraButton))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        refreshUIFromProgress()  // ✅ 진행 반영은 여기 '한 곳'에서만
        updateQuestButtonsUI() // 0809추가✅ 화면 복귀 시 항상 최신 반영
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if resumeMode {
            resumeMode = false
            if let next = nextUnclearedQuest() {
                pushScenario(for: next)
            }
        }
    }

    // MARK: - UI 구성
    private func setupTopMenu() {
        let journalIcon = UIImage(named: "questlisticon")
        let recordIcon  = UIImage(named: "recordbookicon")

        let journal = UIAction(title: "탐험일지", image: journalIcon) { [weak self] _ in self?.showJournal() }
        let record  = UIAction(title: "레코드북", image: recordIcon) { [weak self] _ in self?.showRecordBook() }

        let menu = UIMenu(title: "", options: .displayInline, children: [journal, record])
        customMapView.setOptionMenu(menu)
    }

    private func setupButtonActions() {
        customMapView.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        customMapView.seodongParkButton.addTarget(self, action: #selector(didTapParkButton), for: .touchUpInside)
        customMapView.wanggungriButton.addTarget(self, action: #selector(didTapWanggungriButton), for: .touchUpInside)
        customMapView.jewelryButton.addTarget(self, action: #selector(didTapJewelryButton), for: .touchUpInside)
        customMapView.mireuksaButton.addTarget(self, action: #selector(didTapMireuksaButton), for: .touchUpInside)
        customMapView.seodongMarketButton.addTarget(self, action: #selector(didTapMarketButton), for: .touchUpInside)
    }

    // MARK: - 진행 상태 기반 UI 갱신 (단일 소스)
    private func refreshUIFromProgress() {
        let completed = Set(UserModel.shared.getQuestProgress())

        // 카메라 버튼 표시: 모든 퀘스트 완료 시
        let allCleared = questOrder.allSatisfy { completed.contains($0) }
        customMapView.setCameraButtonVisible(allCleared)

        // 각 퀘스트 버튼 활성 규칙:
        // - 완료된 퀘스트: 활성
        // - 미완료 && 직전 완료: 활성 (즉 “다음 퀘스트” 1개만 열리게)
        // - 그 외: 비활성
        var states: [String: Bool] = [:]
        for (idx, name) in questOrder.enumerated() {
            let done = completed.contains(name)
            let prevDone = (idx == 0) ? true : completed.contains(questOrder[idx-1])
            states[name] = done || (!done && prevDone)
        }
        customMapView.applyQuestButtonStates(states)
    }

    // 진행 보조
    private func nextUnclearedQuest() -> String? {
        let completed = Set(UserModel.shared.getQuestProgress())
        return questOrder.first { !completed.contains($0) }
    }

    // MARK: - Actions
    @objc private func didTapOptionButton() { /* 필요 시 추가 */ }

    @objc private func didTapBackButton() {
        navigationController?.popToRootViewController(animated: true)
    }

    @objc private func didTapCameraButton() {
        let overlay = UIImage(named: "bg")  // 투명 PNG 권장(없으면 nil)
        CameraService.shared.present(from: self, overlay: overlay) { [weak self] image in
            // 저장 (커스텀 앨범에 넣고 싶으면 이름 지정)
            PhotoSaver.save(image, toAlbum: "LociTravel") { result in
                switch result {
                case .success:
                    self?.toast("사진이 저장되었어요 📸")
                case .failure(let err):
                    self?.showAlert(title: "저장 실패", message: err.localizedDescription)
                }
            }
        }
    }

    @objc private func didTapMarketButton()   { pushScenario(for: "서동시장") }
    @objc private func didTapJewelryButton()  { pushScenario(for: "보석 박물관") }
    @objc private func didTapMireuksaButton() { pushScenario(for: "미륵사지") }
    @objc private func didTapParkButton()     { pushScenario(for: "서동공원") }
    @objc private func didTapWanggungriButton(){ pushScenario(for: "왕궁리 유적") }
    
    //0809 추가 MARK: - 완료 뱃지 + 비활성화 반영
        @objc private func updateQuestButtonsUI() {
            let completed = Set(UserModel.shared.getQuestProgress()) // ⬅️ 완료된 퀘스트명 배열을 반환한다고 가정

            questButtons.forEach { entry in
                let isDone = completed.contains(entry.name)
                applyCompletionUI(to: entry.button, completed: isDone)
            }
        }
    //0809 추가
    @objc private func onProgressChanged() {
        // ⛏ FIX(초보자용): 진행도 바뀌면
        // 1) 순차진행 규칙(어떤 버튼을 열지/닫을지) 먼저 반영하고
        // 2) 완료 뱃지/비활성화를 덧씌웁니다.
        refreshUIFromProgress()
        updateQuestButtonsUI()
    }

        private func applyCompletionUI(to button: UIButton, completed: Bool) {
            if completed {
                // 1) 터치 차단
                button.isEnabled = false
                // 2) 비주얼 약하게
                button.alpha = 0.5
                // 3) “완료됨” 뱃지 추가(중복 방지)
                addCompletionBadge(above: button)
            } else {
                // 되돌리기
//                button.isEnabled = true
//                button.alpha = 1.0
                removeCompletionBadge(above: button)
            }
        }

        // MARK: - “완료됨” 뱃지
        private func addCompletionBadge(above button: UIView) {
            // 이미 있으면 패스
            if let _ = button.superview?.viewWithTag(COMPLETION_BADGE_TAG + button.hashValue) { return }

            let label = UILabel() // ⬅️ 아래에 정의한 패딩 라벨 사용(없으면 UILabel로 대체 가능)
            label.text = "완료!"
            label.font = .systemFont(ofSize: 15, weight: .semibold)
            label.textColor = .white
            label.backgroundColor = UIColor.systemCyan
            label.layer.cornerRadius = 8
            label.layer.masksToBounds = true
            label.translatesAutoresizingMaskIntoConstraints = false
            label.tag = COMPLETION_BADGE_TAG + button.hashValue

            // 🔧 부모: 버튼의 슈퍼뷰에 붙이면 지도 위 배치가 자연스러움
            guard let container = button.superview else { return }
            container.addSubview(label)

            // ⛏ 오토레이아웃: 버튼 위 4pt, 가운데 정렬
            NSLayoutConstraint.activate([
                label.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -4),
                label.centerXAnchor.constraint(equalTo: button.centerXAnchor)
            ])
        }

        private func removeCompletionBadge(above button: UIView) {
            let tag = COMPLETION_BADGE_TAG + button.hashValue
            button.superview?.viewWithTag(tag)?.removeFromSuperview()
        }

    private func pushScenario(for spot: String) {
        let vc = ScenarioViewController(spotName: spot)
        navigationController?.pushViewController(vc, animated: true)
    }

    // 서브 화면
    private func showJournal() {
        navigationController?.pushViewController(QuestListViewController(), animated: true)
    }
//    private func showRecordBook() {
//        let vc = SpotDetailViewController()
//        vc.spotName = UserModel.shared.getQuestProgress().last ?? "서동시장"
//        navigationController?.pushViewController(vc, animated: true)
//    }
    @objc private func showRecordBook() {
        let recordVC = RecordBookViewController()
        
        navigationController?.pushViewController(recordVC, animated: true)

    }
}

#Preview{
    MapView()
}
