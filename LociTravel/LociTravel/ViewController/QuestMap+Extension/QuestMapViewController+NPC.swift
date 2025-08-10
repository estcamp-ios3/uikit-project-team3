//
//  Untitled.swift
//  LociTravel
//
//  Created by chohoseo on 8/10/25.
//

import UIKit
import MapKit

extension QuestMapViewController {

    func registerNPCAnnotationView() {
        questView.mapView.register(
            SpriteAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: SpriteAnnotationView.reuseId
        )
    }

    /// 현재 spotName에 있는 NPC들을 맵에 추가
    func addNPCsIfNeeded() {
        // 모델에서 가져오기
        let npcs = WorldModel.shared.npcs(in: spotName)
        guard !npcs.isEmpty else {
            print("ℹ️ NPC 없음: \(spotName)")
            return
        }

        // 기존 NPC 어노테이션 제거(중복 방지)
        removeNPCAnnotations()

        // NPC → 어노테이션
        let annos = npcs.map { NPCAnnotation(npc: $0) }
        questView.mapView.addAnnotations(annos)
        npcAnnotations = annos

        // (선택) 맵 화면에 NPC와 플레이어를 함께 보이도록 맞추기
        // fitToNPCsAndPlayer()
    }

    /// 다른 마을로 바뀌었거나, 데이터 갱신 시 호출
    func refreshNPCsForCurrentSpot() {
        removeNPCAnnotations()
        addNPCsIfNeeded()
    }

    func removeNPCAnnotations() {
        if !npcAnnotations.isEmpty {
            questView.mapView.removeAnnotations(npcAnnotations)
            npcAnnotations.removeAll()
        }
        // 혹시 타입 캐스팅으로 제거하고 싶으면:
        // let toRemove = questView.mapView.annotations.compactMap { $0 as? NPCAnnotation }
        // questView.mapView.removeAnnotations(toRemove)
    }

    /// (선택) NPC + 플레이어가 모두 화면에 들어오도록 영역 맞추기
    func fitToNPCsAndPlayer(padding: UIEdgeInsets = .init(top: 60, left: 40, bottom: 140, right: 40)) {
        var annos: [MKAnnotation] = npcAnnotations
        annos.append(fakeMyPosition) // 플레이어(“나”)
        guard !annos.isEmpty else { return }
        questView.mapView.showAnnotations(annos, animated: true)
        // 또는 MKMapRect 계산해서 setVisibleMapRect로도 가능
    }
}
