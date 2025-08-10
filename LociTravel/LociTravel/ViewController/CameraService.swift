//
//  CameraService.swift
//  LociTravel
//
//  Created by chohoseo on 8/10/25.
//

import UIKit
import AVFoundation

final class CameraService: NSObject {

    static let shared = CameraService()

    private var overlayImage: UIImage?
    private weak var presenter: UIViewController?
    private var completion: ((UIImage) -> Void)?

    // iOS 기본 카메라 컨트롤러
    private lazy var picker: UIImagePickerController = {
        let p = UIImagePickerController()
        p.delegate = self
        p.sourceType = .camera
        p.showsCameraControls = true
        p.allowsEditing = false
        p.modalPresentationStyle = .fullScreen
        p.cameraCaptureMode = .photo
        p.cameraDevice = .rear
        return p
    }()

    /// 카메라를 표시하고 촬영 결과(오버레이 합성 포함)를 콜백으로 전달
    /// - Parameters:
    ///   - vc: 현재 표시 중인 뷰컨트롤러
    ///   - overlay: 카메라 미리보기와 촬영 결과 위에 얹을 투명 PNG (nil 가능)
    ///   - completion: 합성 완료된 UIImage 반환
    func present(from vc: UIViewController,
                 overlay: UIImage?,
                 completion: @escaping (UIImage) -> Void) {
        self.overlayImage = overlay
        self.presenter = vc
        self.completion = completion

        // 권한 체크
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            guard let self = self else { return }
            DispatchQueue.main.async {
                guard granted else {
                    self.showAlert(on: vc, title: "카메라 권한 필요", message: "설정에서 카메라 접근을 허용해주세요.")
                    return
                }
                guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                    self.showAlert(on: vc, title: "카메라 사용 불가", message: "이 기기에서는 카메라를 사용할 수 없습니다.")
                    return
                }

                // 하얀 화면 이슈 회피용으로 아주 짧은 지연
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    vc.present(self.picker, animated: true) { [weak self] in
                        guard let self = self else { return }
                        self.installOverlayIfNeeded()
                    }
                }
            }
        }
    }

    // MARK: - Overlay (미리보기 위)
    private func installOverlayIfNeeded() {
        guard let overlay = overlayImage else {
            picker.cameraOverlayView = nil
            return
        }
        let overlayView = UIImageView(image: overlay)
        overlayView.backgroundColor = .clear
        overlayView.isUserInteractionEnabled = false

        let bounds = picker.view.bounds
        // ↓ 필요에 맞게 배치 규칙만 바꾸면 전 화면에서 일관되게 동작
        // 예: 화면 하단 절반(예시), 원본 코드와 동일 비율 계산
        let imageW: CGFloat = 1126
        let imageH: CGFloat = 607
        let originY = bounds.height * 0.5
        let height  = bounds.width * (imageH / imageW)

        overlayView.frame = CGRect(x: 0, y: originY, width: bounds.width, height: height)
        overlayView.contentMode = .scaleToFill

        picker.cameraOverlayView = overlayView
    }

    // MARK: - Compose (촬영 결과에도 동일 위치로 합성)
    private func compose(base: UIImage, overlay: UIImage?) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: base.size)
        return renderer.image { _ in
            base.draw(in: CGRect(origin: .zero, size: base.size))

            guard let overlay = overlay else { return }
            let imageW: CGFloat = 1126
            let imageH: CGFloat = 607
            let originY = base.size.height * 0.5
            let height  = base.size.width * (imageH / imageW)
            let rect = CGRect(x: 0, y: originY, width: base.size.width, height: height)
            overlay.draw(in: rect, blendMode: .normal, alpha: 1.0)
        }
    }

    private func showAlert(on vc: UIViewController, title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "확인", style: .default))
        vc.present(ac, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension CameraService: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        picker.dismiss(animated: true)

        guard let original = info[.originalImage] as? UIImage else { return }
        let result = compose(base: original, overlay: overlayImage)
        completion?(result)

        // 상태 초기화 (메모리 릭 방지)
        overlayImage = nil
        presenter = nil
        completion = nil
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
        overlayImage = nil
        presenter = nil
        completion = nil
    }
}
