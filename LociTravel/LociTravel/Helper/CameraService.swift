//
//  CameraService.swift
//  LociTravel
//
//  Created by chohoseo on 8/10/25.
//
import UIKit
import AVFoundation
import Photos

final class CameraService: NSObject {

    static let shared = CameraService()

    private var overlayImage: UIImage?
    private weak var presenter: UIViewController?
    private var completion: ((UIImage) -> Void)?

    // 상태
    private var previewImage: UIImage?                // 합성 결과(미리보기용)
    private weak var liveOverlayView: UIView?         // 촬영 전 UI
    private weak var previewOverlayView: UIView?      // 촬영 후 UI

    // iOS 기본 카메라 컨트롤러
    private lazy var picker: UIImagePickerController = {
        let p = UIImagePickerController()
        p.delegate = self
        p.sourceType = .camera
        p.showsCameraControls = false      // ✅ 기본 컨트롤 끄기 (커스텀 UI 사용)
        p.allowsEditing = false
        p.modalPresentationStyle = .fullScreen
        p.cameraCaptureMode = .photo
        p.cameraDevice = .rear
        return p
    }()

    // MARK: - Public
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    vc.present(self.picker, animated: true) { [weak self] in
                        self?.installLiveUI()
                    }
                }
            }
        }
    }

    // MARK: - Live UI (촬영 전: 오버레이 + 셔터)
    private func installLiveUI() {
        // 이전 미리보기 UI 제거
        previewOverlayView?.removeFromSuperview()
        previewOverlayView = nil

        // 라이브 오버레이 컨테이너
        let container = UIView(frame: picker.view.bounds)
        container.backgroundColor = .clear
        container.isUserInteractionEnabled = true

        // 1) 가이드 오버레이(중앙 정렬)
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

        // 2) 셔터 버튼 (하단 중앙)
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

        // 3) 닫기 버튼 (좌상단)
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
        // 라이브 UI 제거
        liveOverlayView?.removeFromSuperview()
        liveOverlayView = nil

        // 합성 결과 저장 및 미리보기 구성
        previewImage = image

        let container = UIView(frame: picker.view.bounds)
        container.backgroundColor = .black

        // 1) 미리보기 이미지 (AspectFit, 중앙)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = container.bounds.insetBy(dx: 0, dy: safeTopInset() + 80)
        container.addSubview(imageView)

        // 2) 하단 바 컨테이너
        let bar = UIStackView()
        bar.axis = .horizontal
        bar.alignment = .center
        bar.distribution = .fillEqually
        bar.spacing = 20
        bar.frame = CGRect(x: 20,
                           y: container.bounds.height - 90 - safeBottomInset(),
                           width: container.bounds.width - 40,
                           height: 60)

        // 왼쪽: 공유
        let shareBtn = makeBarButton(title: "공유하기", systemImage: "square.and.arrow.up")
        shareBtn.addTarget(self, action: #selector(tapShare), for: .touchUpInside)

        // 가운데: 저장
        let saveBtn = makeBarButton(title: "저장하기", systemImage: "tray.and.arrow.down")
        saveBtn.addTarget(self, action: #selector(tapSave), for: .touchUpInside)

        // 오른쪽: 다시찍기
        let retakeBtn = makeBarButton(title: "다시찍기", systemImage: "gobackward")
        retakeBtn.addTarget(self, action: #selector(tapRetake), for: .touchUpInside)

        bar.addArrangedSubview(shareBtn)
        bar.addArrangedSubview(saveBtn)
        bar.addArrangedSubview(retakeBtn)
        container.addSubview(bar)

        // 닫기 버튼 (좌상단)
        let close = UIButton(type: .system)
        close.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        close.tintColor = .white
        close.frame = CGRect(x: 16, y: 16 + safeTopInset(), width: 32, height: 32)
        close.addTarget(self, action: #selector(closeCamera), for: .touchUpInside)
        container.addSubview(close)

        picker.cameraOverlayView = container
        previewOverlayView = container
    }

    private func makeBarButton(title: String, systemImage: String) -> UIButton {
        let b = UIButton(type: .system)
        b.tintColor = .white
        b.setImage(UIImage(systemName: systemImage), for: .normal)
        b.setTitle(" " + title, for: .normal)
        b.titleLabel?.font = .boldSystemFont(ofSize: 16)
        b.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        b.layer.cornerRadius = 12
        b.contentEdgeInsets = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
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
        guard let img = previewImage, let vc = presenter else { return }
        let av = UIActivityViewController(activityItems: [img], applicationActivities: nil)
        vc.present(av, animated: true)
    }

    @objc private func tapSave() {
        guard let img = previewImage, let vc = presenter else { return }
        // 커스텀 앨범에 저장하고 싶다면 이름을 지정하세요 (예: "LociTravel")
        PhotoSaver.save(img, toAlbum: "LociTravel") { [weak vc] result in
            switch result {
            case .success:
                vc?.toast("사진이 저장되었어요 📸")
            case .failure(let err):
                vc?.showAlert(title: "저장 실패", message: err.localizedDescription)
            }
        }
    }

    @objc private func tapRetake() {
        // 다시 라이브 카메라로
        previewImage = nil
        installLiveUI()
    }

    private func cleanup() {
        overlayImage = nil
        completion = nil
        presenter = nil
        previewImage = nil
        liveOverlayView = nil
        previewOverlayView = nil
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

            // 가로를 사진 너비에 맞추고 세로는 비율로 계산 → 세로 중앙 배치
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

        // 원본 → 오버레이 합성
        guard let original = info[.originalImage] as? UIImage else { return }
        let result = compose(base: original, overlay: overlayImage)

        // 콜백은 즉시 넘겨주고…
        completion?(result)

        // …화면은 미리보기 + 3버튼으로 전환
        installPreviewUI(with: result)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        closeCamera()
    }
}
