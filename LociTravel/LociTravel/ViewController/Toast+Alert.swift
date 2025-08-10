//
//  Toast.swift
//  LociTravel
//
//  Created by chohoseo on 8/10/25.
//

import UIKit

extension UIViewController {
    func toast(_ message: String, duration: TimeInterval = 2.0) {
        let toastLabel = UILabel()
        toastLabel.text = message
        toastLabel.textColor = .white
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 14)
        toastLabel.layer.cornerRadius = 8
        toastLabel.clipsToBounds = true
        toastLabel.numberOfLines = 0
        
        // 크기와 위치
        let textSize = toastLabel.sizeThatFits(CGSize(width: self.view.frame.width - 40, height: CGFloat.greatestFiniteMagnitude))
        toastLabel.frame = CGRect(
            x: 20,
            y: self.view.frame.height - textSize.height - 100,
            width: self.view.frame.width - 40,
            height: textSize.height + 16
        )
        
        toastLabel.alpha = 0
        self.view.addSubview(toastLabel)
        
        // 애니메이션 (fade in → fade out)
        UIView.animate(withDuration: 0.3, animations: {
            toastLabel.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: duration, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0
            }) { _ in
                toastLabel.removeFromSuperview()
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "확인", style: .default))
        present(ac, animated: true)
    }
}
