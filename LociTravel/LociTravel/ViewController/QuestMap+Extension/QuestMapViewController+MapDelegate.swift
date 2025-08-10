import UIKit
import MapKit

extension QuestMapViewController {

    // Overlays
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let pl = overlay as? MKPolyline {
            let r = MKPolylineRenderer(polyline: pl)
            r.strokeColor = .systemBlue
            r.lineWidth = 8
            r.lineJoin = .round
            r.lineCap = .round
            return r
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    // 어노테이션 추가
    func addNPCsIfNeeded() {
        let npcs = WorldModel.shared.npcs(in: spotName)
        let annos = npcs.map { NPCAnnotation(npc: $0) }
        questView.mapView.addAnnotations(annos)
    }
    
    // Annotations
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        if annotation is MKUserLocation { return nil }

        if annotation.title ?? nil == "나" {
            let id = "meImage"
            let v = (mapView.dequeueReusableAnnotationView(withIdentifier: id) as? MKAnnotationView)
            ?? MKAnnotationView(annotation: annotation, reuseIdentifier: id)
            v.annotation = annotation
            v.canShowCallout = false
            if let img = UIImage(named: "mouse") {
                let size = CGSize(width: 60, height: 60)
                UIGraphicsBeginImageContextWithOptions(size, false, 0)
                img.draw(in: CGRect(origin: .zero, size: size))
                v.image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                v.centerOffset = CGPoint(x: 0, y: 0)
            }
            return v
        }
        
        // 공통 NPC
        if annotation is NPCAnnotation {
            let v = mapView.dequeueReusableAnnotationView(withIdentifier: SpriteAnnotationView.reuseId, for: annotation) as! SpriteAnnotationView
            return v
        }
        
        if annotation.title ?? nil == "assassin" {
            let id = "assassinImage"
            let v = (mapView.dequeueReusableAnnotationView(withIdentifier: id) as? MKAnnotationView)
            ?? MKAnnotationView(annotation: annotation, reuseIdentifier: id)
            v.annotation = annotation
            v.canShowCallout = false
            let name = assassin?.imageName ?? "icon_assassin_0"
            if let img = UIImage(named: name) {
                let size = CGSize(width: 30, height: 30)
                UIGraphicsBeginImageContextWithOptions(size, false, 0)
                img.draw(in: CGRect(origin: .zero, size: size))
                v.image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                v.centerOffset = CGPoint(x: 0, y: 0)
            }
            return v
        }

        if let title = annotation.title ?? nil, title.starts(with: "보물") {
            let id = "itemImage"
            let v = (mapView.dequeueReusableAnnotationView(withIdentifier: id) as? MKAnnotationView)
            ?? MKAnnotationView(annotation: annotation, reuseIdentifier: id)
            v.annotation = annotation
            v.canShowCallout = false

            let comps = title.split(separator: " ")
            let idx = (comps.last.flatMap { Int($0) }) ?? 0
            let imgName = (idx < items.count ? items[idx].itemImage : (items.first?.itemImage ?? "sweetpotato"))
            if let img = UIImage(named: imgName) {
                let size = CGSize(width: 60, height: 60)
                UIGraphicsBeginImageContextWithOptions(size, false, 0)
                img.draw(in: CGRect(origin: .zero, size: size))
                v.image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                v.centerOffset = CGPoint(x: 0, y: 0)
            }
            return v
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let ann = view.annotation as? NPCAnnotation else { return }
        switch ann.npc.action {
        case .dialogue(let storyKey):
            presentStory(for: storyKey)
        case .startQuest(let questName):
            startQuest(named: questName)
        case .openShop(let shopId):
            presentShop(id: shopId)
        case .none:
            break
        }
        mapView.deselectAnnotation(ann, animated: true)
    }
    
    func presentStory(for key: String) {
        guard let storyViewController = storyboard?.instantiateViewController(withIdentifier: "ScenarioViewController") as? ScenarioViewController else { return }
        //storyViewController.storyKey = key
        navigationController?.pushViewController(storyViewController, animated: true)
    }
    
    func startQuest(named name: String) {
        
    }
    
    func presentShop(id: String) {
        
    }
}
