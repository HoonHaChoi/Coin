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
    
    private let loadingView: LoadingView = {
        let loadingView = LoadingView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.isHidden = true
        return loadingView
    }()
    
    var requestAppVersion: (() -> ())?
    weak var coordinator: AppCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureAnimationView()
        configureLoadingView()
        playAnimation()
    }
    
    private func configureAnimationView() {
        animationView.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
        animationView.center = self.view.center
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .playOnce
        view.addSubview(animationView)
    }
    
    private func configureLoadingView() {
        view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.heightAnchor.constraint(equalToConstant: 120)
        ])
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
    
    lazy var changeLoadingState = { [weak self] state in
        DispatchQueue.main.async {
            self?.loadingView.isHidden = state
        }
    }
    
    private func showFailNetworkAlert() {
        showAlertController(message: "??????????????? ????????? ??? ????????????.\n ???????????? ?????? ????????? ?????? ????????? ?????????.")
    }
    
    lazy var showMainScreen = { [weak self] in
        guard let self = self else { return }
        DispatchQueue.main.async {
            self.coordinator?.showMainCoordinator()
        }
    }
    
    func showFailRequestAlert() {
        self.showAlertController(message: "???????????? ???????????? ????????? ??????????????????..\n ?????? ?????? ?????? ????????????.")
    }
    
    func showNeedUpdateAlert() {
        self.showAlertController(title: "????????????",
                                 message: "????????? ????????? ???????????????. \n ??? ????????? ????????? ??????????????????!") { [weak self] _ in
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
        guard let url = Endpoint.appStoreURL() else {
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            self.showAlertController(message: "??? ????????? URL??? ??? ??? ????????????.")
        }
    }
}
