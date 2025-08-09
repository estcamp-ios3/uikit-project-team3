import UIKit
import MapKit

final class MapViewController: UIViewController {

    private let customMapView = MapView()

    // 퀘스트 순서
    private let questOrder = ["서동시장", "보석 박물관", "미륵사지", "서동공원", "왕궁리 유적"]

    // 이어하기 플래그
    private var resumeMode = false

    // MARK: - Life Cycle
    override func loadView() { view = customMapView }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtonActions()
        setupTopMenu()

        // 버튼 액션 연결
        customMapView.connectOptionButton(target: self, action: #selector(didTapOptionButton))
        customMapView.connectCameraButton(target: self, action: #selector(didTapCameraButton))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        refreshUIFromProgress()  // ✅ 진행 반영은 여기 '한 곳'에서만
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
        let record  = UIAction(title: "리코드북", image: recordIcon) { [weak self] _ in self?.showRecordBook() }

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
        let cameraVC = CameraViewController()
        if let nav = navigationController {
            nav.pushViewController(cameraVC, animated: true)
        } else {
            cameraVC.modalPresentationStyle = .fullScreen
            present(cameraVC, animated: true)
        }
    }

    @objc private func didTapMarketButton()   { pushScenario(for: "서동시장") }
    @objc private func didTapJewelryButton()  { pushScenario(for: "보석 박물관") }
    @objc private func didTapMireuksaButton() { pushScenario(for: "미륵사지") }
    @objc private func didTapParkButton()     { pushScenario(for: "서동공원") }
    @objc private func didTapWanggungriButton(){ pushScenario(for: "왕궁리 유적") }

    private func pushScenario(for spot: String) {
        let vc = ScenarioViewController(spotName: spot)
        navigationController?.pushViewController(vc, animated: true)
    }

    // 서브 화면
    private func showJournal() {
        navigationController?.pushViewController(QuestListViewController(), animated: true)
    }
    private func showRecordBook() {
        let vc = SpotDetailViewController()
        vc.spotName = UserModel.shared.getQuestProgress().last ?? "서동시장"
        navigationController?.pushViewController(vc, animated: true)
    }
}

#Preview{
    MapViewController()
}
