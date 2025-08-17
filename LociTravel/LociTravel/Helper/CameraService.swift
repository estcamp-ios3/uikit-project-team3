import UIKit
import AVFoundation

// 카메라 화면에서만 회전 허용
final class CameraPickerController: UIImagePickerController {
    var onLayout: ((CGRect) -> Void)?

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .allButUpsideDown }
    override var shouldAutorotate: Bool { true }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        onLayout?(view.bounds) // 회전/레이아웃 변경마다 현재 bounds 전달
    }
}

// 이미지 비율 조정
private extension CGRect {
    func scaledAroundCenter(by scale: CGFloat) -> CGRect {
        let s = max(0.01, min(scale, 1.0))
        let newW = width * s, newH = height * s
        return CGRect(x: midX - newW/2, y: midY - newH/2, width: newW, height: newH)
    }
}

final class CameraService: NSObject {

    static let shared = CameraService()

    // (선택) 출력 다운스케일로 메모리/시간 절약
    var maxOutputDimension: CGFloat? = nil

    private weak var presenter: UIViewController?
    private var overlayImage: UIImage?
    private var completion: ((UIImage) -> Void)?

    private var picker: CameraPickerController!      // 커스텀 피커
    private var overlayContainer: UIView?            // 합성/레이아웃용 (pickerview 전체)
    private var overlayImageView: UIImageView?       // 미리보기 영역(4:3) 안에 배치
    private var previewRectInPicker: CGRect = .zero  // ✅ 실제 미리보기(4:3) 영역
    // 랜드스케이프 모드일 경우 이미지 비율
    var landscapeOverlayScale: CGFloat = 0.95  // 0.1 ~ 1.0

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
        picker = CameraPickerController()
        picker.delegate = self
        picker.sourceType = .camera
        picker.modalPresentationStyle = .fullScreen
        picker.cameraCaptureMode = .photo
        picker.cameraDevice = .rear
        picker.showsCameraControls = true

        let container = UIView(frame: UIScreen.main.bounds)
        container.backgroundColor = .clear
        container.isUserInteractionEnabled = false
        overlayContainer = container

        if let overlay = overlayImage {
            let iv = UIImageView(image: overlay)
            iv.backgroundColor = .clear
            iv.isUserInteractionEnabled = false
            iv.contentMode = .scaleAspectFit        // ✅ 비율 유지
            container.addSubview(iv)
            overlayImageView = iv
        }

        // 회전/레이아웃 변경될 때마다 프레임 재계산
        picker.onLayout = { [weak self] bounds in
            self?.layoutOverlay(in: bounds)
        }

        vc.present(picker, animated: true) { [weak self] in
            guard let self = self else { return }
            self.layoutOverlay(in: self.picker.view.bounds)
            self.picker.cameraOverlayView = container
            UIViewController.attemptRotationToDeviceOrientation()
        }
    }

    /// 미리보기는 사진 촬영 시 보통 4:3 비율이므로, 그 영역을 계산해서 그 안에만 오버레이를 배치
    private func layoutOverlay(in pickerBounds: CGRect) {
        overlayContainer?.frame = pickerBounds

        // 4:3 미리보기 영역
        let previewAspect = CGSize(width: 4, height: 3)
        let previewRect = AVMakeRect(aspectRatio: previewAspect, insideRect: pickerBounds)
        previewRectInPicker = previewRect

        if let iv = overlayImageView, let img = iv.image {
            iv.contentMode = .scaleAspectFit

            // ✅ 가로(랜드스케이프)일 때만 0.8 스케일로 축소
            let isLandscape = pickerBounds.width > pickerBounds.height
            let baseFrame = previewRect
            let frameForOverlay = isLandscape
                ? baseFrame.scaledAroundCenter(by: landscapeOverlayScale)
                : baseFrame

            iv.frame = frameForOverlay
        }
    }
}

extension CameraService: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        guard let orig = info[.originalImage] as? UIImage else {
            picker.dismiss(animated: true); return
        }

        // 1) 방향 정규화
        let base = orig.normalized()

        // 2) (선택) 다운스케일
        let baseForCompose: UIImage = {
            guard let maxDim = maxOutputDimension else { return base }
            return base.downscaled(maxDimension: maxDim)
        }()

        // 3) 합성 — 미리보기 영역(4:3)을 기준으로 좌표 매핑
        let finalImage: UIImage = {
            guard let iv = overlayImageView,
                  let png = iv.image,
                  let container = overlayContainer
            else { return baseForCompose }

            // 🔸 UIImageView 안에서 실제 이미지가 그려지는 영역(Aspect-Fit 결과)을 컨테이너 좌표로 변환
            let contentRectInIV = iv.contentImageRect()
            let contentRectInContainer = iv.convert(contentRectInIV, to: container)

            return autoreleasepool(invoking: {
                composeDirect(
                    base: baseForCompose,
                    overlayImage: png,
                    overlayFrameInPreview: contentRectInContainer, // 실제 그려지는 영역
                    previewBounds: previewRectInPicker              // ✅ 진짜 미리보기(4:3) 영역
                )
            })
        }()

        // 4) dismiss 후 콜백
        picker.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.completion?(finalImage)
            self.completion = nil
            self.overlayImage = nil
            self.overlayContainer = nil
            self.overlayImageView = nil
            self.picker = nil

            // 필요 시 즉시 세로 복귀(선택)
            // if #available(iOS 16.0, *) {
            //     self.presenter?.setNeedsUpdateOfSupportedInterfaceOrientations()
            // } else {
            //     UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            //     UIViewController.attemptRotationToDeviceOrientation()
            // }
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.completion = nil
            self.overlayImage = nil
            self.overlayContainer = nil
            self.overlayImageView = nil
            self.picker = nil
        }
    }
}

// MARK: - Helpers (합성/정규화/스케일/콘텐츠영역)

private extension UIImage {
    func normalized() -> UIImage {
        guard imageOrientation != .up else { return self }
        let r = UIGraphicsImageRenderer(size: size)
        return r.image { _ in draw(in: CGRect(origin: .zero, size: size)) }
    }

    func downscaled(maxDimension: CGFloat) -> UIImage {
        let w = size.width, h = size.height
        let maxSide = max(w, h)
        guard maxSide > maxDimension, maxSide > 0 else { return self }
        let scale = maxDimension / maxSide
        let target = CGSize(width: w * scale, height: h * scale)

        let fmt = UIGraphicsImageRendererFormat.default()
        fmt.opaque = true
        fmt.scale = 1
        return UIGraphicsImageRenderer(size: target, format: fmt).image { _ in
            draw(in: CGRect(origin: .zero, size: target))
        }
    }
}

private extension UIImageView {
    /// contentMode = .scaleAspectFit 기준으로, 실제 이미지가 그려지는 내부 사각형
    func contentImageRect() -> CGRect {
        guard let img = image, bounds.width > 0, bounds.height > 0 else { return bounds }
        let imageAspect = img.size.width / img.size.height
        let viewAspect  = bounds.width / bounds.height

        var drawSize = CGSize.zero
        if imageAspect > viewAspect {
            // 가로가 더 긴 이미지 → 너비에 맞춤
            drawSize.width = bounds.width
            drawSize.height = bounds.width / imageAspect
        } else {
            // 세로가 더 긴 이미지 → 높이에 맞춤
            drawSize.height = bounds.height
            drawSize.width  = bounds.height * imageAspect
        }

        let originX = (bounds.width  - drawSize.width)  * 0.5
        let originY = (bounds.height - drawSize.height) * 0.5
        return CGRect(x: originX, y: originY, width: drawSize.width, height: drawSize.height)
    }
}

/// 스냅샷 없이, 오버레이 이미지를 직접 원본 좌표로 변환해 합성
private func composeDirect(base: UIImage,
                           overlayImage: UIImage,
                           overlayFrameInPreview: CGRect,   // 컨테이너(=pickerview) 좌표계에서의 실제 그려지는 영역
                           previewBounds: CGRect) -> UIImage {

    // ✅ 미리보기(4:3) 영역 안에서 원본이 보이는 사각형 (base는 보통 4:3이라 == previewBounds)
    let displayed = AVMakeRect(aspectRatio: base.size, insideRect: previewBounds)

    // 프리뷰 좌표 → 원본 픽셀 좌표로 매핑
    let scale = base.size.width / displayed.width
    let targetRect = CGRect(
        x: (overlayFrameInPreview.origin.x - displayed.origin.x) * scale,
        y: (overlayFrameInPreview.origin.y - displayed.origin.y) * scale,
        width: overlayFrameInPreview.width * scale,
        height: overlayFrameInPreview.height * scale
    )

    let fmt = UIGraphicsImageRendererFormat.default()
    fmt.opaque = true
    fmt.scale = 1

    let renderer = UIGraphicsImageRenderer(size: base.size, format: fmt)
    return renderer.image { _ in
        base.draw(in: CGRect(origin: .zero, size: base.size))
        overlayImage.draw(in: targetRect, blendMode: .normal, alpha: 1)
    }
}
