import UIKit
import MapKit
import CoreLocation
import QuartzCore

extension QuestMapViewController {

    // MARK: - Entry
    func setupAssassinIfNeeded() {
        guard let assassin else { return }

        // 항상 1개만 남기기
        let olds = questView.mapView.annotations.filter { $0.title ?? "" == "assassin" }
        questView.mapView.removeAnnotations(olds)

        assassinAnnotation.title = "assassin"
        assassinAnnotation.coordinate = assassin.start
        questView.mapView.addAnnotation(assassinAnnotation)

        // 보행 우선 → 실패 시 자동차로 재시도(보행 스텝 꿰매기)
        requestRoute(from: assassin.start, to: assassin.end, transport: .walking) { [weak self] walk in
            guard let self = self else { return }

            if let r = walk, r.transportType.contains(.walking) {
                self.useAssassinRoute(r)
            } else {
                self.requestRoute(from: assassin.start, to: assassin.end, transport: .automobile) { [weak self] car in
                    guard let self = self, let car = car else {
                        print("❗️자객 경로 탐색 실패: 보행/자동차 모두 실패")
                        return
                    }
                    // 자동차 경로에서 보행/기타 스텝만 모아 대체 폴리라인 구성
                    let walkingPieces = car.steps
                        .filter { $0.transportType == .walking }
                        .map { $0.polyline }

                    if walkingPieces.isEmpty {
                        // 어쩔 수 없이 자동차 전체 사용
                        self.useAssassinPolyline(car.polyline)
                    } else {
                        var coords: [CLLocationCoordinate2D] = []
                        for pl in walkingPieces { coords.append(contentsOf: pl.coordinates()) }
                        let stitched = MKPolyline(coordinates: coords, count: coords.count)
                        self.useAssassinPolyline(stitched)
                    }
                }
            }
        }
    }

    // MARK: - Route request helper
    private func requestRoute(from: CLLocationCoordinate2D,
                              to: CLLocationCoordinate2D,
                              transport: MKDirectionsTransportType,
                              completion: @escaping (MKRoute?) -> Void) {
        let req = MKDirections.Request()
        req.source = MKMapItem(placemark: MKPlacemark(coordinate: from))
        req.destination = MKMapItem(placemark: MKPlacemark(coordinate: to))
        req.transportType = transport
        req.requestsAlternateRoutes = true

        MKDirections(request: req).calculate { res, _ in
            completion(res?.routes.first)
        }
    }

    // MARK: - Apply route/polyline
    private func useAssassinRoute(_ route: MKRoute) {
        questView.mapView.addOverlay(route.polyline)
        questView.mapView.setVisibleMapRect(route.polyline.boundingMapRect,
                                            edgePadding: UIEdgeInsets(top: 60, left: 40, bottom: 140, right: 40),
                                            animated: true)
        assassinRouteCoords = route.polyline.coordinates()
        if assassinRouteCoords.count > 1,
           let start = assassin?.start,
           assassinRouteCoords[0].distance(to: start) < 0.3 {
            assassinRouteCoords.removeFirst()
        }
        buildAssassinCumulativeAndStart()
    }

    private func useAssassinPolyline(_ polyline: MKPolyline) {
        questView.mapView.addOverlay(polyline)
        questView.mapView.setVisibleMapRect(polyline.boundingMapRect,
                                            edgePadding: UIEdgeInsets(top: 60, left: 40, bottom: 140, right: 40),
                                            animated: true)
        assassinRouteCoords = polyline.coordinates()
        if assassinRouteCoords.count > 1,
           let start = assassin?.start,
           assassinRouteCoords[0].distance(to: start) < 0.3 {
            assassinRouteCoords.removeFirst()
        }
        buildAssassinCumulativeAndStart()
    }

    private func buildAssassinCumulativeAndStart() {
        assassinCumulative = [0]
        var cum: CLLocationDistance = 0
        for i in 1..<assassinRouteCoords.count {
            cum += assassinRouteCoords[i-1].distance(to: assassinRouteCoords[i])
            assassinCumulative.append(cum)
        }
        assassinTotal = cum
        assassinProgress = 0

        assassinTimer?.invalidate()
        assassinLastTS = CACurrentMediaTime()
        let link = CADisplayLink(target: self, selector: #selector(self.tickAssassin))
        link.add(to: .main, forMode: .common)
        assassinTimer = link
    }

    // MARK: - Tick (constant speed)
    @objc func tickAssassin(_ link: CADisplayLink) {
        guard assassinTotal > 0, assassinRouteCoords.count >= 2 else {
            stopAssassin()
            return
        }
        let now = link.timestamp
        let dt = now - assassinLastTS
        assassinLastTS = now

        // 속도: 모델값 사용 (없으면 1.5m/s)
        let speed = assassin?.speedMPS ?? 1.5
        assassinProgress += speed * dt

        // 도착
        if assassinProgress >= assassinTotal {
            assassinAnnotation.coordinate = assassinRouteCoords.last!
            stopAssassin()
            // 도착 지점에서 플레이어와 포착 판정 (가까우면 완료)
            checkAssassinCatch()
            return
        }

        // 진행 구간 찾기
        var idx = 1
        while idx < assassinCumulative.count && assassinCumulative[idx] < assassinProgress { idx += 1 }
        let endIdx = min(idx, assassinCumulative.count - 1)
        let startIdx = max(endIdx - 1, 0)

        let s = assassinRouteCoords[startIdx]
        let e = assassinRouteCoords[endIdx]
        let segLen = s.distance(to: e)
        let prev = assassinCumulative[startIdx]
        let along = assassinProgress - prev
        let t = segLen > 0 ? (along / segLen) : 1

        assassinAnnotation.coordinate = s.interpolated(to: e, t: t)

        // 이동 중에도 포착 판정
        checkAssassinCatch()
    }

    func stopAssassin() {
        assassinTimer?.invalidate()
        assassinTimer = nil
    }

    // MARK: - Catch (player meets assassin)
    func checkAssassinCatch(current: CLLocationCoordinate2D? = nil) {
        guard assassin != nil else { return }
        // 본체에 아래 두 프로퍼티가 있는지 확인:
        // var assassinCatchRadius: CLLocationDistance = 20
        // var assassinCaught = false
        if assassinCaught { return }

        let my = current ?? fakeMyPosition.coordinate
        let target = assassinAnnotation.coordinate
        let d = CLLocation(latitude: my.latitude, longitude: my.longitude)
            .distance(from: CLLocation(latitude: target.latitude, longitude: target.longitude))
        if d <= assassinCatchRadius {
            assassinCaught = true
            stopAssassin()
            // 원하면 지도에서 자객 제거
            // questView.mapView.removeAnnotation(assassinAnnotation)
            presentCompletionAlertSafely()
        }
    }
}
