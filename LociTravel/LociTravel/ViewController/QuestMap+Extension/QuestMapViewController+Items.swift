import UIKit
import MapKit
import CoreLocation

extension QuestMapViewController {

    func setupItemsIfNeeded() {
        guard !items.isEmpty else {
            questView.progressView.isHidden = true
            return
        }
        questView.progressView.isHidden = false
        questView.progressView.progress = 0
        foundItems.removeAll()

        itemPositions.removeAll()
        itemAnnotations.removeAll()

        // "나", userLocation, 자객 제외하고 제거
        let toRemove = questView.mapView.annotations.filter {
            let t = $0.title ?? nil
            return ($0 !== questView.mapView.userLocation) && (t != "나") && (t != "assassin")
        }
        questView.mapView.removeAnnotations(toRemove)

        if let first = items.first, first.isRandom {
            itemPositions = defaultRandomOffsets().map { offsetCoord(base: itemPosition, lat: $0.lat, lon: $0.lon) }
        } else {
            itemPositions = items.map { .init(latitude: $0.itemLatitude, longitude: $0.itemLongitude) }
        }

        for (i, pos) in itemPositions.enumerated() {
            let ann = MKPointAnnotation()
            ann.coordinate = pos
            let name = (i < items.count ? items[i].itemName : (items.first?.itemName ?? "아이템"))
            ann.title = "보물 \(name) \(i)"
            questView.mapView.addAnnotation(ann)
            itemAnnotations.append(ann)
        }
    }

    func pickup(index i: Int) {
        guard !foundItems.contains(i) else { return }
        foundItems.insert(i)
        if i < itemAnnotations.count {
            questView.mapView.removeAnnotation(itemAnnotations[i])
        }
        questView.progressView.progress = Float(foundItems.count) / Float(max(itemPositions.count, 1))

        if foundItems.count == itemPositions.count {
            presentCompletionAlertSafely()
        } else if presentedViewController == nil {
            let label = (i < items.count ? items[i].itemName : (items.first?.itemName ?? "아이템"))
            let alert = UIAlertController(title: "임무 수행!", message: "\(label) \(i + 1)을(를) 완료!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
        }
    }

    func checkNearbyItems() {
        let cur = CLLocation(latitude: fakeMyPosition.coordinate.latitude, longitude: fakeMyPosition.coordinate.longitude)
        for (i, pos) in itemPositions.enumerated() where !foundItems.contains(i) {
            if cur.distance(from: CLLocation(latitude: pos.latitude, longitude: pos.longitude)) <= proximityRadius {
                pickup(index: i)
            }
        }
    }

    func presentCompletionAlertSafely() {
        guard !isPresentingCompletion else { return }
        isPresentingCompletion = true
        if let presented = presentedViewController {
            presented.dismiss(animated: true) { [weak self] in
                self?.showCompletionAlert()
                self?.isPresentingCompletion = false
            }
        } else {
            showCompletionAlert()
            isPresentingCompletion = false
        }
    }

    func showCompletionAlert() {
        let alert = UIAlertController(title: "퀘스트 완료!", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            guard let self = self else { return }
            UserModel.shared.addQuestProgress(self.spotName)
            _ = QuestModel.shared.updateQuest(spotName: self.spotName)

            let isLast = (self.spotName == "왕궁리 유적")
            DispatchQueue.main.async {
                if isLast {
                    let ep = EpilogueViewController()
                    if let nav = self.navigationController { nav.pushViewController(ep, animated: true) }
                    else { self.present(ep, animated: true) }
                } else if let nav = self.navigationController {
                    if let mapVC = nav.viewControllers.first(where: { $0 is MapViewController }) {
                        nav.popToViewController(mapVC, animated: true)
                    } else {
                        nav.popToRootViewController(animated: true)
                    }
                } else {
                    self.dismiss(animated: true)
                }
            }
        })
        present(alert, animated: true)
    }
}
