//
//  PermissionManager.swift
//  LociTravel
//
//  Created by chohoseo on 8/16/25.
//

import AVFoundation
import Photos

enum PermissionResult { case granted, denied }

struct PermissionManager {

    /// 카메라 -> (승인 시) 사진추가(addOnly) 순으로 요청
    static func ensureCameraAndAddOnly(completion: @escaping (_ camera: PermissionResult, _ photosAdd: PermissionResult) -> Void) {

        // 1) 카메라
        AVCaptureDevice.requestAccess(for: .video) { camGranted in
            guard camGranted else {
                DispatchQueue.main.async { completion(.denied, .denied) }
                return
            }

            // 2) 사진 보관함 "추가 전용" 권한 (iOS14+), 이하 버전은 일반 권한
            if #available(iOS 14, *) {
                let current = PHPhotoLibrary.authorizationStatus(for: .addOnly)
                switch current {
                case .authorized, .limited:
                    DispatchQueue.main.async { completion(.granted, .granted) }
                case .notDetermined:
                    PHPhotoLibrary.requestAuthorization(for: .addOnly) { newStatus in
                        let ok = (newStatus == .authorized || newStatus == .limited)
                        DispatchQueue.main.async { completion(.granted, ok ? .granted : .denied) }
                    }
                default:
                    DispatchQueue.main.async { completion(.granted, .denied) }
                }
            } else {
                let current = PHPhotoLibrary.authorizationStatus()
                switch current {
                case .authorized:
                    DispatchQueue.main.async { completion(.granted, .granted) }
                case .notDetermined:
                    PHPhotoLibrary.requestAuthorization { newStatus in
                        let ok = (newStatus == .authorized)
                        DispatchQueue.main.async { completion(.granted, ok ? .granted : .denied) }
                    }
                default:
                    DispatchQueue.main.async { completion(.granted, .denied) }
                }
            }
        }
    }
}
