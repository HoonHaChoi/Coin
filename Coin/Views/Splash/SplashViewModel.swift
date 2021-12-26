//
//  VersionManager.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/10/09.
//

import Foundation
import Combine

final class SplashViewModel: BaseViewModel {
    
    private let nowVersion: String
    private let appBundle: String
    
    var failRequestHandler: (() -> ())?
    var unequalVersionHandler: (() -> ())?
    var successHandler: (() -> ())?
    var loadingStateHandler: ((Bool) -> ())?
    
    override init(service: NetworkService) {
        self.nowVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Not Found App Version"
        self.appBundle = Bundle.main.bundleIdentifier ?? "Not Found App Bundle"
        super.init(service: service)
    }
    
    func fetchAppStoreVersion() {
        loadingStateHandler?(false)
        requestAppStoreVersion()
            .sink { [weak self] fail in
            if case .failure(_) = fail {
                self?.failRequestHandler?()
                self?.loadingStateHandler?(true)
            }
        } receiveValue: { [weak self] appInfo in
            self?.compareVersion(appinfo: appInfo)
            self?.loadingStateHandler?(true)
        }.store(in: &cancellable)
    }

    private func compareVersion(appinfo: AppInfo) {
        guard let info = appinfo.results.first else {
            return
        }
        
        let nowVersionValue = Double(nowVersion) ?? 0.0
        let appStoreVesionValue = Double(info.version) ?? 0.0

        if nowVersionValue >= appStoreVesionValue {
            successHandler?()
        } else {
            unequalVersionHandler?()
        }
    }
    
    private func requestAppStoreVersion() -> AnyPublisher<AppInfo, NetworkError> {
        return service.requestPublisher(url: Endpoint.appStoreInfoURL(bundle: appBundle))
    }
}
