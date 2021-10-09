//
//  SplashViewController.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/10/04.
//

import UIKit
import Lottie
import Network

final class SplashViewController: UIViewController {

    private let moniter: NetWorkChecking
    
    init(moniter: NetWorkChecking) {
        self.moniter = moniter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private let animationView: AnimationView = {
        let animationView = AnimationView(name: "Splash")
        return animationView
    }()
    
    weak var coordinator: AppCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureAnimationView()
    }
    
    private func configureAnimationView() {
        animationView.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
        animationView.center = self.view.center
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .playOnce
        view.addSubview(animationView)
        playAnimation()
    }
    
    private func playAnimation() {
        animationView.play { [weak self] _ in
            if self?.moniter.canNetworkConnect() ?? false {
                self?.coordinator?.showMainCoordinator()
            } else {
                self?.failNetworkAlert()
            }
        }
    }
    
    private func failNetworkAlert() {
        let alert = UIAlertController(title: "",
                                      message: "네트워크에 연결할 수 없습니다.\n 네트워크 상태 확인후 다시 시도해 주세요.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
