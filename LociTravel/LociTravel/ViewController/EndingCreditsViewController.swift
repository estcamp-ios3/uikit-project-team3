//
//  EndingCreditsViewController.swift
//  LociTravel
//
//  Created by suji chae on 8/6/25.
//

import UIKit

class EndingCreditsViewController: UIViewController {
    
    let participantNames = ["홍길동", "김철수", "이영희", "박선화"]
    var nameLabels: [UILabel] = []
    let endLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupLabels()
        animateNames()
    }
    
    private func setupLabels() {
        for name in participantNames {
            let label = UILabel()
            label.text = name
            label.textColor = .white
            label.alpha = 0
            label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
            label.textAlignment = .center
            view.addSubview(label)
            nameLabels.append(label)
        }

        endLabel.text = "감사합니다.  …end"
        endLabel.textColor = .white
        endLabel.alpha = 0
        endLabel.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        endLabel.textAlignment = .center
        view.addSubview(endLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let spacing: CGFloat = 50
        let startY = view.bounds.midY - spacing * CGFloat(nameLabels.count) / 2
        
        for (index, label) in nameLabels.enumerated() {
            label.frame = CGRect(x: 0, y: startY + CGFloat(index) * spacing, width: view.bounds.width, height: 30)
        }

        endLabel.frame = CGRect(x: 0, y: view.bounds.midY, width: view.bounds.width, height: 40)
    }
    
    private func animateNames() {
        for (i, label) in nameLabels.enumerated() {
            let delay = Double(i) * 1.2
            UIView.animate(withDuration: 1.0, delay: delay, options: [], animations: {
                label.alpha = 1.0
                label.frame.origin.y -= 20
            }, completion: nil)
        }

        // 전체 이름 페이드 아웃 후 엔딩 텍스트 표시
        let totalDelay = Double(participantNames.count) * 1.2 + 1.5
        DispatchQueue.main.asyncAfter(deadline: .now() + totalDelay) {
            UIView.animate(withDuration: 1.5, animations: {
                self.nameLabels.forEach { $0.alpha = 0 }
            }, completion: { _ in
                UIView.animate(withDuration: 2.0) {
                    self.endLabel.alpha = 1.0
                }
            })
        }
    }
}
