//
//  PortraitOnlyViewController.swift
//  LociTravel
//
//  Created by chohoseo on 8/17/25.
//

import UIKit

class PortraitOnlyViewController: UIViewController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
    override var shouldAutorotate: Bool { false } // 회전 시도는 해도, 마스크가 세로만 허용
}

class RootNavController: UINavigationController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        topViewController?.supportedInterfaceOrientations ?? .portrait
    }
    override var shouldAutorotate: Bool {
        topViewController?.shouldAutorotate ?? false
    }
}
