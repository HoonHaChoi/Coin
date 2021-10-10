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
    private let usecase: SearchUseCase
    private var cancell: AnyCancellable?
    
    var failHandler: (() -> ())?
    var successHandler: ((Bool) -> ())?
    
    init(usecase: SearchUseCase) {
        self.nowVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Not Found App Version"
        self.appBundle = Bundle.main.bundleIdentifier ?? "Not Found App Bundle"
        self.usecase = usecase
    }
    
    func fetchAppStoreVersion() {
        cancell = usecase.requestAppStoreVersion(url: Endpoint.appStoreURL(bundle: appBundle))
            .sink { [weak self] fail in
            if case .failure(_) = fail {
                self?.failHandler?()
            }
        } receiveValue: { appInfo in
            print(appInfo)
        }
    }
    
}
