//
//  VersionManager.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/10/09.
//

import Foundation
import Combine

final class VersionManager {
    
    private var nowVersion: String
    private var appBundle: String
    private var usecase: SearchUseCase
    
    init(usecase: SearchUseCase) {
        nowVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Not Found App Version"
        appBundle = Bundle.main.bundleIdentifier ?? "Not Found App Bundle"
        self.usecase = usecase
    }
    
    func fetchAppStoreVersion() -> AnyPublisher<AppInfo, NetworkError> {
        usecase.requestAppStoreVersion(url: Endpoint.appStoreURL(bundle: appBundle))
    }
    
}
