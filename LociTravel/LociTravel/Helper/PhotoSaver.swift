import UIKit
import Photos

enum PhotoSaverError: Error {
    case notAuthorized
    case unknown
}

final class PhotoSaver {

    static func save(_ image: UIImage,
                     toAlbum albumName: String? = nil,
                     completion: @escaping (Result<Void, Error>) -> Void) {

        let proceed: () -> Void = {
            if #available(iOS 14, *) {
                let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
                if status == .authorized || status == .limited {
                    saveInternal(image, toAlbum: albumName, completion: completion)
                } else if status == .notDetermined {
                    PHPhotoLibrary.requestAuthorization(for: .addOnly) { newStatus in
                        DispatchQueue.main.async {
                            guard newStatus == .authorized || newStatus == .limited else {
                                completion(.failure(PhotoSaverError.notAuthorized)); return
                            }
                            saveInternal(image, toAlbum: albumName, completion: completion)
                        }
                    }
                } else {
                    completion(.failure(PhotoSaverError.notAuthorized))
                }
            } else {
                let status = PHPhotoLibrary.authorizationStatus()
                if status == .authorized {
                    saveInternal(image, toAlbum: albumName, completion: completion)
                } else if status == .notDetermined {
                    PHPhotoLibrary.requestAuthorization { newStatus in
                        DispatchQueue.main.async {
                            guard newStatus == .authorized else {
                                completion(.failure(PhotoSaverError.notAuthorized)); return
                            }
                            saveInternal(image, toAlbum: albumName, completion: completion)
                        }
                    }
                } else {
                    completion(.failure(PhotoSaverError.notAuthorized))
                }
            }
        }

        proceed()
    }

    // MARK: - Internal

    private static func saveInternal(_ image: UIImage,
                                     toAlbum albumName: String?,
                                     completion: @escaping (Result<Void, Error>) -> Void) {

        // 변경점: "읽기 전용"으로 미리 앨범이 있는지 조회만 함 (트랜잭션 없음)
        let existingAlbum: PHAssetCollection? = albumName.flatMap { fetchAlbum(named: $0) }

        PHPhotoLibrary.shared().performChanges({
            // 1) 에셋 생성
            let assetReq = PHAssetChangeRequest.creationRequestForAsset(from: image)
            let placeholder = assetReq.placeholderForCreatedAsset

            // 2) 앨범 처리
            guard let albumName = albumName, let ph = placeholder else { return } // 앨범 지정 안 하면 카메라 롤에만 저장

            if let album = existingAlbum,
               let changeReq = PHAssetCollectionChangeRequest(for: album) {
                // 2-A) 기존 앨범에 추가
                changeReq.addAssets([ph] as NSArray)
            } else {
                // 2-B) 같은 트랜잭션에서 앨범 생성 + 즉시 추가 (중첩 performChanges 호출 금지!)
                let createAlbumReq = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
                createAlbumReq.addAssets([ph] as NSArray)
            }
        }, completionHandler: { success, error in
            DispatchQueue.main.async {
                if success { completion(.success(())) }
                else { completion(.failure(error ?? PhotoSaverError.unknown)) }
            }
        })
    }

    // 읽기 전용 앨범 조회 (performChanges 호출 금지)
    private static func fetchAlbum(named name: String) -> PHAssetCollection? {
        let opts = PHFetchOptions()
        opts.predicate = NSPredicate(format: "localizedTitle = %@", name)
        let fetch = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: opts)
        return fetch.firstObject
    }
}
