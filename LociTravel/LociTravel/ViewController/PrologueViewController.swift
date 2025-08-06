//
//  PrologueViewController.swift
//  LociTravel
//
//  Created by dkkim on 8/6/25.
//

import UIKit

class PrologueViewController: UIViewController {
    private let prologueView = PrologueView()
    
    override func loadView() {
        view = prologueView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
}
