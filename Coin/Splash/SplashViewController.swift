//
//  SplashViewController.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/10/04.
//

import UIKit
import Lottie

class SplashViewController: UIViewController {

    private let animationView: AnimationView = {
        let animationView = AnimationView(name: "Splash")
        return animationView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAnimationView()
    }
    
    private func configureAnimationView() {
        animationView.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
        animationView.center = self.view.center
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .playOnce
        view.addSubview(animationView)
        animationView.play()
    }
    
}
