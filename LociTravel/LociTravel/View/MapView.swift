//
//  MapView.swift
//  LociTravel
//
//  Created by suji chae on 8/5/25.
//

import UIKit
import MapKit
import SnapKit

final class MapView: UIView {
    
    // MARK: - UI Components
    let mapView = MKMapView()
    let mapOverlayImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        // 지도 설정
        addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 고지도 스타일 오버레이
        addSubview(mapOverlayImageView)
        mapOverlayImageView.image = UIImage(named: "gojido_overlay")
        mapOverlayImageView.contentMode = .scaleAspectFill
        mapOverlayImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
