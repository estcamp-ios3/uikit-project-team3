//
//  SpotDetailView.swift
//  LociTravel
//
//  Created by suji chae on 8/5/25.
//

import UIKit
import SnapKit

final class SpotDetailView: UIView {

    // MARK: - UI Components
    let scrollView = UIScrollView()
    let spotImageView = UIImageView()
    let storyContainerView = UIView()
    let backButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .systemBackground
        
        // 뒤로가기 버튼
        addSubview(backButton)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .black
        backButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.width.height.equalTo(44)
        }
        
        // 스팟 이미지
        addSubview(spotImageView)
        spotImageView.image = UIImage(named: "mireuksa_temple_photo")
        spotImageView.contentMode = .scaleAspectFill
        spotImageView.clipsToBounds = true
        spotImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(snp.width).multipliedBy(0.7)
        }

        // 스크롤 뷰 (고서 형태)
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(spotImageView.snp.bottom).offset(-50)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        // 대화형 스토리 컨테이너 뷰 (실제 대화 내용은 이 뷰에 추가)
        scrollView.addSubview(storyContainerView)
        storyContainerView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
        }
    }
}
