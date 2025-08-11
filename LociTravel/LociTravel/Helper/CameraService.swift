import UIKit
import AVFoundation

final class CameraService: NSObject {

    static let shared = CameraService()

    private weak var presenter: UIViewController?
    private var overlayImage: UIImage?
    private var completion: ((UIImage) -> Void)?

    private var picker: UIImagePickerController!

    // MARK: - Public
    func present(from vc: UIViewController,
                 overlay: UIImage? = nil,
                 completion: @escaping (UIImage) -> Void) {
        presenter = vc
        overlayImage = overlay
        self.completion = completion

        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            guard let self = self else { return }
            DispatchQueue.main.async {
                guard granted else {
                    vc.showAlert(title: "카메라 권한 필요", message: "설정에서 카메라 접근을 허용해주세요.")
                    return
                }
                guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                    vc.showAlert(title: "카메라 사용 불가", message: "이 기기에서는 카메라를 사용할 수 없습니다.")
                    return
                }
                self.startPicker(from: vc)
            }
        }
    }

    // MARK: - Internal
    private func startPicker(from vc: UIViewController) {
        picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        picker.modalPresentationStyle = .fullScreen
        picker.cameraCaptureMode = .photo
        picker.cameraDevice = .rear

        // ✅ 기본 컨트롤 사용 (Retake / Use Photo)
        picker.showsCameraControls = true

        // (선택) 중앙 정렬 가이드 오버레이 — 터치 비활성(중요!)
        if let overlay = overlayImage {
            let overlayView = UIImageView(image: overlay)
            overlayView.backgroundColor = .clear
            overlayView.isUserInteractionEnabled = false
            overlayView.contentMode = .scaleToFill

            // present 후 좌표계를 기준으로 프레임 계산
            vc.present(picker, animated: true) { [weak self] in
                guard let self = self else { return }
                let bounds = self.picker.view.bounds

                // 오버레이 원본비(예: 1126x607)를 화면 너비에 맞춰 중앙 배치
                let w: CGFloat = 1126, h: CGFloat = 607
                let targetW = bounds.width
                let targetH = targetW * (h / w)
                let originY = (bounds.height - targetH) / 2.0
                overlayView.frame = CGRect(x: 0, y: originY, width: targetW, height: targetH)

                self.picker.cameraOverlayView = overlayView
            }
        } else {
            vc.present(picker, animated: true)
        }
    }
}

extension CameraService: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        // 사용자 “Use Photo” 누른 시점
        guard let image = info[.originalImage] as? UIImage else {
            picker.dismiss(animated: true)
            return
        }

        // 먼저 피커 닫기 → 그 다음에 콜백 실행(공유/저장 등은 presenter에서)
        picker.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.completion?(image)
            // 상태 정리
            self.completion = nil
            self.overlayImage = nil
            self.picker = nil
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.completion = nil
            self.overlayImage = nil
            self.picker = nil
        }
    }
}
