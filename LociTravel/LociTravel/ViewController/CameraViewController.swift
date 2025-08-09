import UIKit
import AVFoundation

final class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Properties
    private let cameraView = CameraView()
    private var composedImage: UIImage?

    // 오버레이 이미지 이름(에셋)
    private let overlayImageName = "Camera/bg"

    // MARK: - Lifecycle
    override func loadView() {
        view = cameraView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
    }

    // MARK: - Wiring
    private func setupActions() {
        cameraView.cameraButton.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
        cameraView.shareButton.addTarget(self, action: #selector(shareImage), for: .touchUpInside)
    }

    // MARK: - Camera
    @objc private func openCamera() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            guard let self = self else { return }
            DispatchQueue.main.async {
                guard granted else {
                    self.showAlert(title: "카메라 권한 필요", message: "설정에서 카메라 접근을 허용해주세요.")
                    return
                }
                guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                    self.showAlert(title: "카메라 사용 불가", message: "이 기기에서는 카메라를 사용할 수 없습니다.")
                    return
                }

                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.delegate = self
                picker.showsCameraControls = true

                // === 오버레이 설정 ===
                if let overlayImage = UIImage(named: self.overlayImageName) {
                    // 화면 기준으로 하단 절반쯤에 오버레이를 깔고, 비율 유지
                    let imageWidth: CGFloat = 1126
                    let imageHeight: CGFloat = 607
                    let overlayOriginY: CGFloat = UIScreen.main.bounds.height / 2
                    let overlayHeight: CGFloat = UIScreen.main.bounds.width * imageHeight / imageWidth

                    let overlayView = UIImageView(image: overlayImage)
                    overlayView.frame = CGRect(
                        x: 0,
                        y: overlayOriginY,
                        width: UIScreen.main.bounds.width,
                        height: overlayHeight
                    )
                    overlayView.contentMode = .scaleToFill
                    picker.cameraOverlayView = overlayView
                }

                self.present(picker, animated: true)
            }
        }
    }

    // MARK: - Picker Delegate
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let original = info[.originalImage] as? UIImage else { return }

        let result = composeImageWithOverlay(baseImage: original, overlayImage: UIImage(named: overlayImageName))
        cameraView.setImage(result)
        composedImage = result
        cameraView.setShareButtonHidden(false)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    // MARK: - Compose
    /// 촬영된 원본 위에 동일한 비율/위치로 오버레이 이미지를 합성
    private func composeImageWithOverlay(baseImage: UIImage, overlayImage: UIImage?) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: baseImage.size)
        return renderer.image { _ in
            // 1) 원본
            baseImage.draw(in: CGRect(origin: .zero, size: baseImage.size))

            // 2) 오버레이 위치 계산 (카메라 오버레이와 동일한 비율/위치)
            let imageWidth: CGFloat = 1126
            let imageHeight: CGFloat = 607
            let overlayOriginY: CGFloat = baseImage.size.height / 2
            let overlayHeight: CGFloat = baseImage.size.width * imageHeight / imageWidth

            if let overlay = overlayImage {
                let rect = CGRect(x: 0, y: overlayOriginY, width: baseImage.size.width, height: overlayHeight)
                overlay.draw(in: rect, blendMode: .normal, alpha: 1.0)
            }
        }
    }

    // MARK: - Share
    @objc private func shareImage() {
        guard let image = composedImage else { return }
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityVC, animated: true)
    }

    // MARK: - Alert
    private func showAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "확인", style: .default))
        present(ac, animated: true)
    }
}
