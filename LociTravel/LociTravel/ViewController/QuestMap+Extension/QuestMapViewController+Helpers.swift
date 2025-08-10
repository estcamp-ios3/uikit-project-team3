import MapKit

extension QuestMapViewController {
    func offsetCoord(base: CLLocationCoordinate2D, lat: Double, lon: Double) -> CLLocationCoordinate2D {
        .init(latitude: base.latitude + lat, longitude: base.longitude + lon)
    }
    func defaultRandomOffsets() -> [(lat: Double, lon: Double)] {
        [(0.0003,0.0003),(-0.0004,0.0005),(0.0008,-0.0008),(-0.0003,-0.0006)]
    }
    static func centerForSpot(_ name: String) -> CLLocationCoordinate2D? {
        switch name {
        case "서동시장":   return .init(latitude: 35.953162, longitude: 126.957308)
        case "보석 박물관": return .init(latitude: 35.990587, longitude: 127.102335)
        case "미륵사지":   return .init(latitude: 36.009675, longitude: 127.029928)
        case "서동공원":   return .init(latitude: 36.001224, longitude: 127.058147)
        case "왕궁리 유적": return .init(latitude: 35.972822, longitude: 127.054597)
        default: return nil
        }
    }
}

// Polyline & Coordinate helpers
extension MKPolyline {
    func coordinates() -> [CLLocationCoordinate2D] {
        var coords = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid, count: pointCount)
        getCoordinates(&coords, range: NSRange(location: 0, length: pointCount))
        return coords
    }
}
extension CLLocationCoordinate2D {
    func distance(to other: CLLocationCoordinate2D) -> CLLocationDistance {
        CLLocation(latitude: latitude, longitude: longitude)
            .distance(from: CLLocation(latitude: other.latitude, longitude: other.longitude))
    }
    func interpolated(to other: CLLocationCoordinate2D, t: Double) -> CLLocationCoordinate2D {
        .init(latitude: latitude + (other.latitude - latitude) * t,
              longitude: longitude + (other.longitude - longitude) * t)
    }
}
