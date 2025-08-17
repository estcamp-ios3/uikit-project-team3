import CoreLocation

extension QuestMapViewController {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let cur = locations.last else { return }
        
        // 실제 위치 사용하려면:
        fakeMyPosition.coordinate = cur.coordinate

        for (i, pos) in itemPositions.enumerated() where !foundItems.contains(i) {
            if cur.distance(from: CLLocation(latitude: pos.latitude, longitude: pos.longitude)) <= proximityRadius {
                pickup(index: i)
            }
        }
        
        // 자객 포착 체크  ← 추가
        checkAssassinCatch(current: cur.coordinate)
    }
}
