import UIKit
import MapKit

extension QuestMapViewController {

    func setupMoveButtonsIfDebug() {
        #if DEBUG
        let up = makeMoveButton("⬆︎", #selector(moveUp))
        let down = makeMoveButton("⬇︎", #selector(moveDown))
        let left = makeMoveButton("⬅︎", #selector(moveLeft))
        let right = makeMoveButton("➡︎", #selector(moveRight))

        let topRow = UIStackView(arrangedSubviews: [UIView(), up, UIView()])
        topRow.axis = .horizontal; topRow.distribution = .equalSpacing

        let midRow = UIStackView(arrangedSubviews: [left, UIView(), right])
        midRow.axis = .horizontal; midRow.alignment = .center; midRow.spacing = 30

        let botRow = UIStackView(arrangedSubviews: [UIView(), down, UIView()])
        botRow.axis = .horizontal; botRow.distribution = .equalSpacing

        let v = UIStackView(arrangedSubviews: [topRow, midRow, botRow])
        v.axis = .vertical; v.alignment = .center; v.spacing = 10
        v.translatesAutoresizingMaskIntoConstraints = false
        questView.addSubview(v)
        NSLayoutConstraint.activate([
            v.leadingAnchor.constraint(equalTo: questView.leadingAnchor, constant: 15),
            v.bottomAnchor.constraint(equalTo: questView.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])

        let btn = makeDebugCompleteButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(btn)
        NSLayoutConstraint.activate([
            btn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            btn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
        #endif
    }

    func makeMoveButton(_ title: String, _ action: Selector) -> UIButton {
        let b = UIButton(type: .system)
        b.setTitle(title, for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 24)
        b.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        b.setTitleColor(.white, for: .normal)
        b.layer.cornerRadius = 8
        b.addTarget(self, action: action, for: .touchUpInside)
        b.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            b.widthAnchor.constraint(equalToConstant: 50),
            b.heightAnchor.constraint(equalToConstant: 50)
        ])
        return b
    }

    @objc func moveUp()    { fakeMyPosition.coordinate.latitude  += step; questView.mapView.setCenter(fakeMyPosition.coordinate, animated: true); checkNearbyItems(); checkAssassinCatch() }
    @objc func moveDown()  { fakeMyPosition.coordinate.latitude  -= step; questView.mapView.setCenter(fakeMyPosition.coordinate, animated: true); checkNearbyItems(); checkAssassinCatch() }
    @objc func moveLeft()  { fakeMyPosition.coordinate.longitude -= step; questView.mapView.setCenter(fakeMyPosition.coordinate, animated: true); checkNearbyItems(); checkAssassinCatch() }
    @objc func moveRight() { fakeMyPosition.coordinate.longitude += step; questView.mapView.setCenter(fakeMyPosition.coordinate, animated: true); checkNearbyItems(); checkAssassinCatch() }

    #if DEBUG
    @objc func debugCompleteQuest() {
        for i in 0..<itemPositions.count where !foundItems.contains(i) { foundItems.insert(i) }
        questView.mapView.removeAnnotations(itemAnnotations)
        itemAnnotations.removeAll()
        if !itemPositions.isEmpty { questView.progressView.progress = 1 }
        presentCompletionAlertSafely()
    }

    private func makeDebugCompleteButton() -> UIButton {
        let b = UIButton(type: .system)
        b.setTitle("완료(디버그)", for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
        b.backgroundColor = UIColor.systemPink.withAlphaComponent(0.9)
        b.setTitleColor(.white, for: .normal)
        b.layer.cornerRadius = 10
        b.contentEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
        b.addTarget(self, action: #selector(debugCompleteQuest), for: .touchUpInside)
        return b
    }
    #endif
}
