//
//  SceneDelegate.swift
//  LociTravel
//
//  Created by suji chae on 8/5/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // 이 메서드는 새로운 UIWindowScene이 생성될 때 호출됩니다.
        // 앱의 UI를 연결하고, 윈도우를 만들고, 뷰 계층을 설정합니다.
        
        // 1. UIWindowScene 인스턴스를 가져옵니다.
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // 2. 새로운 UIWindow를 생성하고, 이 윈도우를 windowScene에 연결합니다.
        // 이 window는 앱의 모든 UI를 담는 컨테이너 역할을 합니다.
        window = UIWindow(windowScene: windowScene)
        
        // 3. 앱의 첫 화면으로 보여줄 HomeViewController를 생성합니다.
        let homeViewController = HomeViewController()
        
        // 4. HomeViewController를 UINavigationController의 rootViewController로 설정합니다.
        // 이렇게 하면 화면 전환(push/pop) 기능을 사용할 수 있게 됩니다.
        let navigationController = UINavigationController(rootViewController: homeViewController)
        
        
        // 5. 생성된 UINavigationController를 window의 rootViewController로 설정합니다.
        // 이제 앱이 시작될 때 이 컨트롤러가 관리하는 화면이 가장 먼저 표시됩니다.
        window?.rootViewController = navigationController
        
        // 6. 윈도우를 화면에 표시하고, 앱의 메인 윈도우로 만듭니다.
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state in case it is terminated later.
    }
}
