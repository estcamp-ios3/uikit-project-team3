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
            y: self.view.frame.height * 0.5,
//            y: self.view.frame.height - textSize.height - 100,
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
    
    func showGoToSettings(_ what: String) {
            let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
                ?? (Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "앱")
            let alert = UIAlertController(
                title: "\(what) 권한 필요",
                message: "설정 > \(appName)에서 \(what) 권한을 허용해주세요.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "취소", style: .cancel))
            alert.addAction(UIAlertAction(title: "설정으로 이동", style: .default, handler: { _ in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }))
            present(alert, animated: true)
        }

        func showNotice(_ msg: String) {
            let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
            present(alert, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { [weak self] in
                self?.dismiss(animated: true)
            }
        }
}
