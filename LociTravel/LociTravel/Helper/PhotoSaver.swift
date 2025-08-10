//
//  PhotoSaver.swift
//  LociTravel
//
//  Created by chohoseo on 8/10/25.
//

import UIKit
import Photos

enum PhotoSaverError: Error {
    case notAuthorized
    case cannotCreateAlbum
    case unknown
}

final class PhotoSaver {

    /// 이미지 저장. albumName이 nil이면 일반 카메라 롤에만 저장.
    static func save(_ image: UIImage,
                     toAlbum albumName: String? = nil,
                     completion: @escaping (Result<Void, Error>) -> Void) {

        // iOS 14+는 addOnly 권장, 하위 호환 위해 readWrite도 허용
        let requestAuth: () -> Void = {
            if #available(iOS 14, *) {
                PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
                    DispatchQueue.main.async {
                        guard status == .authorized || status == .limited else {
                            completion(.failure(PhotoSaverError.notAuthorized))
                            return
                        }
                        self.saveInternal(image, toAlbum: albumName, completion: completion)
                    }
                }
            } else {
                PHPhotoLibrary.requestAuthorization { status in
                    DispatchQueue.main.async {
                        guard status == .authorized else {
                            completion(.failure(PhotoSaverError.notAuthorized))
                            return
                        }
                        self.saveInternal(image, toAlbum: albumName, completion: completion)
                    }
                }
            }
        }

        // 이미 권한이 있으면 바로 저장
        if #available(iOS 14, *) {
            let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
            if status == .authorized || status == .limited {
                saveInternal(image, toAlbum: albumName, completion: completion)
            } else if status == .notDetermined {
                requestAuth()
            } else {
                completion(.failure(PhotoSaverError.notAuthorized))
            }
        } else {
            let status = PHPhotoLibrary.authorizationStatus()
            if status == .authorized {
                saveInternal(image, toAlbum: albumName, completion: completion)
            } else if status == .notDetermined {
                requestAuth()
            } else {
                completion(.failure(PhotoSaverError.notAuthorized))
            }
        }
    }

    // MARK: - Internal

    private static func saveInternal(_ image: UIImage,
                                     toAlbum albumName: String?,
                                     completion: @escaping (Result<Void, Error>) -> Void) {

        var placeholder: PHObjectPlaceholder?

        PHPhotoLibrary.shared().performChanges({
            let req = PHAssetChangeRequest.creationRequestForAsset(from: image)
            placeholder = req.placeholderForCreatedAsset

            guard let albumName = albumName else { return } // 앨범 지정 안 함

            // 앨범 가져오거나 없으면 생성
            let collection = fetchOrCreateAlbum(named: albumName)
            if let collection = collection,
               let ph = placeholder,
               let changeReq = PHAssetCollectionChangeRequest(for: collection) {
                changeReq.addAssets([ph] as NSArray)
            }
        }, completionHandler: { success, error in
            DispatchQueue.main.async {
                if success { completion(.success(())) }
                else { completion(.failure(error ?? PhotoSaverError.unknown)) }
            }
        })
    }

    private static func fetchOrCreateAlbum(named name: String) -> PHAssetCollection? {
        // 1) 기존 앨범 조회
        let fetch = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: {
            let opt = PHFetchOptions()
            opt.predicate = NSPredicate(format: "localizedTitle = %@", name)
            return opt
        }())
        
        if let first = fetch.firstObject { return first }

        // 2) 없으면 생성
        var placeholder: PHObjectPlaceholder?
        do {
            try PHPhotoLibrary.shared().performChangesAndWait {
                placeholder = PHAssetCollectionChangeRequest
                    .creationRequestForAssetCollection(withTitle: name)
                    .placeholderForCreatedAssetCollection
            }
        } catch {
            print("앨범 생성 실패:", error.localizedDescription)
            return nil
        }

        if let ph = placeholder {
            let result = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [ph.localIdentifier], options: nil)
            return result.firstObject
        }
        return nil
    }

}
