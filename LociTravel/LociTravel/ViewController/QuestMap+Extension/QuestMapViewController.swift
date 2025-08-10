import UIKit
import MapKit
import CoreLocation
import AVFoundation
import QuartzCore

final class QuestMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    // MARK: Inputs
    var spotName: String
    let quest: Quest
    let items: [Item]
    let assassin: Assassin?

    // MARK: UI & Services
    let questView = QuestMapView()
    let locationManager = CLLocationManager()

    // MARK: BGM
    var isMusicOn = true
    var bgmPlayer: AVAudioPlayer?

    // MARK: Map / Items
    var itemPosition: CLLocationCoordinate2D
    var itemPositions: [CLLocationCoordinate2D] = []
    var itemAnnotations: [MKPointAnnotation] = []
    var foundItems: Set<Int> = []
    let proximityRadius: CLLocationDistance = 15
    var mapRegionLongitude: Double = 300
    var mapRegionLatitude: Double = 300

    // MARK: Debug (fake user)
    let fakeMyPosition = MKPointAnnotation()
    let step: CLLocationDegrees = 0.00003

    // MARK: Assassin
    var assassinAnnotation = MKPointAnnotation()
    var assassinRouteCoords: [CLLocationCoordinate2D] = []
    var assassinCumulative: [CLLocationDistance] = []
    var assassinTotal: CLLocationDistance = 0
    var assassinProgress: CLLocationDistance = 0
    var assassinTimer: CADisplayLink?
    var assassinLastTS: CFTimeInterval = 0
    // 자객 포착 판정
    var assassinCatchRadius: CLLocationDistance = 20   // 원하는 거리로 조절
    var assassinCaught = false

    // 완료 알럿 중복 방지
    var isPresentingCompletion = false

    // MARK: Init
    init(spotName: String) {
        self.spotName = spotName
        let q = QuestModel.shared.getQuest(spotName: spotName)
        self.quest = q
        self.items = QuestModel.shared.getItems(questName: q.questName)
        self.assassin = QuestModel.shared.getAssassin(questName: q.questName)

        let center = QuestMapViewController.centerForSpot(spotName) ?? CLLocationCoordinate2D(latitude: 35.9535, longitude: 126.9573)
        self.fakeMyPosition.coordinate = center
        if let first = items.first {
            self.itemPosition = CLLocationCoordinate2D(latitude: first.itemLatitude, longitude: first.itemLongitude)
        } else {
            self.itemPosition = center
        }
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: Life cycle
    override func loadView() { view = questView }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        questView.mapView.delegate = self
        locationManager.delegate = self

        questView.titleLabel.text = "퀘스트: \(quest.questName)"
        questView.descriptionLabel.text = quest.questDetail
        questView.mapView.register(SpriteAnnotationView.self, forAnnotationViewWithReuseIdentifier: SpriteAnnotationView.reuseId)

        setupActions()
        setupMap()
        setupItemsIfNeeded()
        setupAssassinIfNeeded()
        setupMoveButtonsIfDebug()
        playBackgroundMusic()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        bgmPlayer?.stop()
        assassinTimer?.invalidate()
    }
}

#Preview {
    QuestMapViewController(spotName: "서동시장")
}
