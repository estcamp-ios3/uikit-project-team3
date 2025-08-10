import UIKit
import MapKit
import CoreLocation

extension QuestMapViewController {
    func setupMap() {
        questView.mapView.showsUserLocation = false

        let center = fakeMyPosition.coordinate
        let region = MKCoordinateRegion(center: center,
                                        latitudinalMeters: mapRegionLatitude,
                                        longitudinalMeters: mapRegionLongitude)
        questView.mapView.setRegion(region, animated: false)

        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        fakeMyPosition.title = "나"
        questView.mapView.addAnnotation(fakeMyPosition)
    }
}
