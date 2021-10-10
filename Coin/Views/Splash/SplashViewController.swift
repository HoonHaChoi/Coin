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
    
    var requestAppVersion: (() -> ())?
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
                self?.requestAppVersion?()
            } else {
                self?.showFailNetworkAlert()
            }
        }
    }
    
    private func showFailNetworkAlert() {
        showAlertController(message: "네트워크에 연결할 수 없습니다.\n 네트워크 상태 확인후 다시 시도해 주세요.")
    }
    
    lazy var showMainScreen = { [weak self] in
        guard let self = self else { return }
        DispatchQueue.main.async {
            self.coordinator?.showMainCoordinator()
        }
    }
    
    func showFailRequestAlert() {
        self.showAlertController(message: "네트워크 요청중에 문제가 발생했습니다..\n 잠시 후에 시도 해주세요.")
    }
    
    func showNeedUpdateAlert() {
        self.showAlertController(title: "업데이트",
                                 message: "새로운 버전이 나왔습니다. \n 더 나아진 코일을 이용해주세요!") { [weak self] _ in
            self?.moveAppStore()
        }
    }
    
    private func showAlertController(title: String = "",
                             message: String = "",
                             action: ((UIAlertAction) -> ())? = nil) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: title, message: message, action: action)
            self?.present(alert, animated: true)
        }
    }
    
    private func moveAppStore() {
        guard let url = URL(string:"itms-apps://itunes.apple.com/app/1586982814") else {
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
