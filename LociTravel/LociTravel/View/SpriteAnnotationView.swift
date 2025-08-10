//
//  SpriteAnnotationView.swift
//  LociTravel
//
//  Created by chohoseo on 8/10/25.
//

import MapKit
import UIKit

final class SpriteAnnotationView: MKAnnotationView {
    static let reuseId = "SpriteAnnotationView"
    static var imageCache = NSCache<NSString, UIImage>()

    override var annotation: MKAnnotation? {
        didSet { configure() }
    }

    private func configure() {
        guard let npcAnn = annotation as? NPCAnnotation else { return }
        let ap = npcAnn.npc.appearance
        let key = "\(ap.imageName)-\(ap.size?.width ?? -1)x\(ap.size?.height ?? -1)" as NSString

        if let cached = SpriteAnnotationView.imageCache.object(forKey: key) {
            image = cached
        } else {
            if let img = UIImage(named: ap.imageName) {
                let finalSize = ap.size ?? defaultSize(for: npcAnn.npc.type)
                let resized = resize(img, to: finalSize)
                SpriteAnnotationView.imageCache.setObject(resized, forKey: key)
                image = resized
            }
        }

        // 앵커: 핀 끝이 좌표를 가리키도록
        if let img = image, (ap.anchorBottom) {
            //centerOffset = CGPoint(x: 0, y: -img.size.height / 2.0)
            centerOffset = .zero
        } else {
            centerOffset = .zero
        }

        canShowCallout = false
        clusteringIdentifier = clusterId(for: npcAnn.npc.type) // 군집화 옵션
        displayPriority = .required
    }

    private func resize(_ img: UIImage, to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        img.draw(in: CGRect(origin: .zero, size: size))
        let result = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return result
    }

    private func defaultSize(for type: NPCType) -> CGSize {
        switch type {
        case .assassin:   return CGSize(width: 30, height: 30)
        case .villager:   return CGSize(width: 44, height: 44)
        case .questGiver: return CGSize(width: 50, height: 50)
        case .merchant:   return CGSize(width: 44, height: 44)
        }
    }

    private func clusterId(for type: NPCType) -> String? {
        // 마을에 NPC가 매우 많다면 군집화 사용 (원하면 타입별로)
        return "npcCluster"
    }
}
