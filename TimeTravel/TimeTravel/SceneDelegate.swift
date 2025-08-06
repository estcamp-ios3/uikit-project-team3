//
//  SceneDelegate.swift
//  TimeTravel
//
//  Created by chohoseo on 7/30/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate, UITabBarControllerDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        
        let tabbarController = UITabBarController()
        
        
        // 4) HomeView 를 네비게이션 컨트롤러로 래핑
               // let HomeView = HomeView() //homeview 로 수정
                let homeNav = UINavigationController(rootViewController: HomeViewController())
                homeNav.tabBarItem = UITabBarItem(title: "홈",
                                                  image: UIImage(systemName: "house"),
                                                  tag: 0)

                // 5) 기존 MapView, SpotView 역시 네비게이션 컨트롤러로 래핑
        let mapNav = UINavigationController(rootViewController: MapView(localName: "익산", themeName: "잊혀진 유적"))
                mapNav.tabBarItem = UITabBarItem(title: "지도",
                                                 image: UIImage(systemName: "map"),
                                                 tag: 1)

                let spotNav = UINavigationController(rootViewController: SpotView())
                spotNav.tabBarItem = UITabBarItem(title: "Spot",
                                                  image: UIImage(systemName: "signpost.right.and.left.circle"),
                                                  tag: 2)

                // 6) 탭 배열에 순서대로 넣기 (홈 탭이 첫 번째)
                tabbarController.viewControllers = [homeNav, mapNav, spotNav]
        
        // 🔧 4) 탭바 재선택 시 delegate 콜백 받도록 설정
               tabbarController.delegate = self

                // 7) UIWindow 에 탭바 컨트롤러를 루트로 지정
                window?.rootViewController = tabbarController
                window?.makeKeyAndVisible()
            }

    func sceneDidDisconnect(_ scene: UIScene) {
      
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }

    func sceneWillResignActive(_ scene: UIScene) {
       
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }


}

// 🔧 5) UITabBarControllerDelegate 프로토콜 채택 & 재선택 콜백 구현
extension SceneDelegate {
  func tabBarController(_ tabBarController: UITabBarController,
                        didSelect viewController: UIViewController) {
    // 네비게이션 컨트롤러면 루트로 pop
    if let nav = viewController as? UINavigationController {
      nav.popToRootViewController(animated: false)
    }
  }
}
