//
//  VersionManager.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/10/09.
//

import Foundation
import Combine

final class VersionManager {
    
    private let nowVersion: String
    private let appBundle: String
    private let usecase: AppStoreService
    private var cancell: AnyCancellable?
    
    var failRequestHandler: (() -> ())?
    var unequalVersionHandler: (() -> ())?
    var successHandler: (() -> ())?
    var loadingStateHandler: ((Bool) -> ())?
    
    init(usecase: AppStoreService) {
        self.nowVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Not Found App Version"
        self.appBundle = Bundle.main.bundleIdentifier ?? "Not Found App Bundle"
        self.usecase = usecase
    }
    
    func fetchAppStoreVersion() {
        loadingStateHandler?(false)
        cancell = usecase.requestAppStoreVersion(url: Endpoint.appStoreInfoURL(bundle: appBundle))
            .sink { [weak self] fail in
            if case .failure(_) = fail {
                self?.failRequestHandler?()
                self?.loadingStateHandler?(true)
            }
        } receiveValue: { [weak self] appInfo in
            self?.compareVersion(appinfo: appInfo)
            self?.loadingStateHandler?(true)
        }
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
}
