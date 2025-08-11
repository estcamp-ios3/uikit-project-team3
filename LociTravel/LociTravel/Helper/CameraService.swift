import UIKit
import AVFoundation
import Photos

final class CameraService: NSObject {

    static let shared = CameraService()

    private var overlayImage: UIImage?
    private weak var presenter: UIViewController?
    private var completion: ((UIImage) -> Void)?

    // 상태
    private var previewImage: UIImage?
    private weak var liveOverlayView: UIView?
    private weak var previewOverlayView: UIView?

    // 현재 표시 중인 피커
    private var picker: UIImagePickerController!

    // MARK: - Public API
    func present(from vc: UIViewController,
                 overlay: UIImage?,
                 completion: @escaping (UIImage) -> Void) {
        self.overlayImage = overlay
        self.presenter = vc
        self.completion = completion
        self.previewImage = nil

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
                self.startNewPicker(animated: true)
            }
        }
    }

    // MARK: - Picker lifecycle
    private func startNewPicker(animated: Bool) {
        picker = makePicker()
        // 권한 팝업 직후 하얀 화면 이슈 회피용 소폭 지연
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.presenter?.present(self.picker, animated: animated) { [weak self] in
                self?.installLiveUI()
            }
        }
    }

    private func makePicker() -> UIImagePickerController {
        let p = UIImagePickerController()
        p.delegate = self
        p.sourceType = .camera
        p.showsCameraControls = false   // 커스텀 UI 사용
        p.allowsEditing = false
        p.modalPresentationStyle = .fullScreen
        p.cameraCaptureMode = .photo
        p.cameraDevice = .rear
        return p
    }

    // MARK: - Live UI (촬영 전: 오버레이 + 셔터)
    private func installLiveUI() {
        previewOverlayView?.removeFromSuperview()
        previewOverlayView = nil

        let container = UIView(frame: picker.view.bounds)
        container.backgroundColor = .clear
        container.isUserInteractionEnabled = true

        // 1) 중앙 정렬 가이드 오버레이
        if let overlay = overlayImage {
            let overlayView = UIImageView(image: overlay)
            overlayView.backgroundColor = .clear
            overlayView.isUserInteractionEnabled = false
            overlayView.contentMode = .scaleToFill

            let bounds = picker.view.bounds
            let imageW: CGFloat = 1126
            let imageH: CGFloat = 607
            let targetWidth  = bounds.width
            let targetHeight = targetWidth * (imageH / imageW)
            let originY = (bounds.height - targetHeight) / 2.0
            overlayView.frame = CGRect(x: 0, y: originY, width: targetWidth, height: targetHeight)

            container.addSubview(overlayView)
        }

        // 2) 셔터 버튼
        let shutter = UIButton(type: .system)
        shutter.setImage(UIImage(systemName: "circle.inset.filled"), for: .normal)
        shutter.tintColor = .white
        shutter.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        shutter.layer.cornerRadius = 34
        shutter.frame = CGRect(x: (container.bounds.width - 68)/2,
                               y: container.bounds.height - 110,
                               width: 68, height: 68)
        shutter.addTarget(self, action: #selector(takePicture), for: .touchUpInside)
        container.addSubview(shutter)

        // 3) 닫기 버튼
        let close = UIButton(type: .system)
        close.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        close.tintColor = .white
        close.frame = CGRect(x: 16, y: 16 + safeTopInset(), width: 32, height: 32)
        close.addTarget(self, action: #selector(closeCamera), for: .touchUpInside)
        container.addSubview(close)

        picker.cameraOverlayView = container
        liveOverlayView = container
    }

    // MARK: - Preview UI (촬영 후: 이미지 + 공유/저장/다시찍기)
    private func installPreviewUI(with image: UIImage) {
        liveOverlayView?.removeFromSuperview()
        liveOverlayView = nil

        previewImage = image

        let container = UIView(frame: picker.view.bounds)
        container.backgroundColor = .black

        // 1) 미리보기 이미지
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = container.bounds.insetBy(dx: 0, dy: safeTopInset() + 80)
        container.addSubview(imageView)

        // 2) 하단 3버튼 바
        let bar = UIStackView()
        bar.axis = .horizontal
        bar.alignment = .center
        bar.distribution = .fillEqually
        bar.spacing = 20
        bar.frame = CGRect(x: 20,
                           y: container.bounds.height - 90 - safeBottomInset(),
                           width: container.bounds.width - 40,
                           height: 60)

        let shareBtn  = makeBarButton(title: "공유하기",  systemImage: "square.and.arrow.up", action: #selector(tapShare))
        let saveBtn   = makeBarButton(title: "저장하기",  systemImage: "tray.and.arrow.down", action: #selector(tapSave))
        let retakeBtn = makeBarButton(title: "다시찍기", systemImage: "gobackward",          action: #selector(tapRetake))

        bar.addArrangedSubview(shareBtn)
        bar.addArrangedSubview(saveBtn)
        bar.addArrangedSubview(retakeBtn)
        container.addSubview(bar)

        // 닫기
        let close = UIButton(type: .system)
        close.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        close.tintColor = .white
        close.frame = CGRect(x: 16, y: 16 + safeTopInset(), width: 32, height: 32)
        close.addTarget(self, action: #selector(closeCamera), for: .touchUpInside)
        container.addSubview(close)

        picker.cameraOverlayView = container
        previewOverlayView = container
    }

    private func makeBarButton(title: String, systemImage: String, action: Selector) -> UIButton {
        let b = UIButton(type: .system)
        b.tintColor = .white
        b.setImage(UIImage(systemName: systemImage), for: .normal)
        b.setTitle(" " + title, for: .normal)
        b.titleLabel?.font = .boldSystemFont(ofSize: 16)
        b.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        b.layer.cornerRadius = 12
        b.contentEdgeInsets = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
        b.addTarget(self, action: action, for: .touchUpInside)
        return b
    }

    // MARK: - Actions
    @objc private func takePicture() {
        picker.takePicture()
    }

    @objc private func closeCamera() {
        picker.dismiss(animated: true)
        cleanup()
    }

    @objc private func tapShare() {
        guard let img = previewImage else { return }
        let av = UIActivityViewController(activityItems: [img], applicationActivities: nil)
        // iPad popover anchor
        av.popoverPresentationController?.sourceView = picker.view
        av.popoverPresentationController?.sourceRect = CGRect(x: picker.view.bounds.midX,
                                                              y: picker.view.bounds.maxY - 80,
                                                              width: 1, height: 1)
        // ✅ picker 위에 표시 (프리즈 방지)
        picker.present(av, animated: true)
    }

    @objc private func tapSave() {
        guard let img = previewImage else { return }
        PhotoSaver.save(img, toAlbum: "LociTravel") { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                // 토스트는 presenter.view에 붙이는게 자연스러움
                self.presenter?.toast("사진이 저장되었어요 📸")
            case .failure(let err):
                let ac = UIAlertController(title: "저장 실패",
                                           message: err.localizedDescription,
                                           preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "확인", style: .default))
                // ✅ picker 위에 표시
                self.picker.present(ac, animated: true)
            }
        }
    }

    @objc private func tapRetake() {
        // 기존 피커 완전 종료 → 새 피커로 재시작 (review 상태 꼬임 방지)
        previewImage = nil
        picker.dismiss(animated: false) { [weak self] in
            self?.startNewPicker(animated: false)
        }
    }

    // MARK: - Utils
    private func cleanup() {
        overlayImage = nil
        completion = nil
        presenter = nil
        previewImage = nil
        liveOverlayView = nil
        previewOverlayView = nil
        picker = nil
    }

    private func safeTopInset() -> CGFloat {
        presenter?.view.safeAreaInsets.top ?? 0
    }
    private func safeBottomInset() -> CGFloat {
        presenter?.view.safeAreaInsets.bottom ?? 0
    }

    // MARK: - Overlay 합성 (중앙 정렬)
    private func compose(base: UIImage, overlay: UIImage?) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: base.size)
        return renderer.image { _ in
            base.draw(in: CGRect(origin: .zero, size: base.size))
            guard let overlay = overlay else { return }

            // 오버레이 원본 비율
            let imageW: CGFloat = 1126
            let imageH: CGFloat = 607

            // 사진 너비에 맞춰 세로 중앙 배치
            let targetWidth  = base.size.width
            let targetHeight = targetWidth * (imageH / imageW)
            let originY = (base.size.height - targetHeight) / 2.0
            let rect = CGRect(x: 0, y: originY, width: targetWidth, height: targetHeight)

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

        guard let original = info[.originalImage] as? UIImage else { return }
        let result = compose(base: original, overlay: overlayImage)

        // 외부 콜백 먼저 전달
        completion?(result)

        // 미리보기 + 3버튼 UI로 전환
        installPreviewUI(with: result)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        closeCamera()
    }
}
