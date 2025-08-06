//
//  PrologueViewController.swift
//  LociTravel
//
//  Created by dkkim on 8/6/25.
//

import UIKit

class PrologueViewController: UIViewController {
    private let prologueView = PrologueView()
    
    override func loadView() {
        view = prologueView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        skipButtonActions()
        
    }
    
    // viewdidappear 추가
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        prologueView.startCreditsAnimation()   // ← 여기로 이동
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func skipButtonActions() {
        prologueView.skipButton.addTarget(self, action: #selector(didTapSkipButton), for: .touchUpInside)
    }
    
    //넘어가기 버튼 함수
    @objc private func didTapSkipButton() {
        
        let mapVC = MapViewController()
        navigationController?.pushViewController(mapVC, animated: true)
    }
}
