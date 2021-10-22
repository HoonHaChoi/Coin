//
//  MainViewModel.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/07/27.
//

import Foundation
import Combine

final class MainViewModel: CryptoBaseViewModel {
    
    private let favoriteCoinRepository: FavoriteCoinRepository
    
    init(repository: FavoriteCoinRepository,
         service: FavortieService,
         socketUseCase: SocketUseCase) {
        self.favoriteCoinRepository = repository
        super.init(service: service,
                   socketUsecase: socketUseCase)
    }
    
    func fetchFavoriteCoins() {
        let uuids = favoriteCoinRepository.fetch()
        let requests = uuids.map { uuid in
            return service.requestFavoriteCoins(uuidString: uuid)
        }
        
        cancell = Publishers.MergeMany(requests)
            .collect()
            .sink { [weak self] fail in
                if case .failure(let error) = fail {
                    self?.failErrorHandler?(error)
                }
            } receiveValue: { [weak self] coins in
                self?.coinsHandler?(self?.sortCoins(uuids: uuids,
                                                    coins: coins) ?? [])
                self?.fetchSocketFavoriteMeta(uuids: uuids)
            }
    }
    
    // 무작위로 온 코인리스트를 정렬
    private func sortCoins(uuids: [String], coins: [Coin]) -> [Coin] {
        return coins.sorted { first, second in
            if let first = uuids.firstIndex(of: first.uuid),
               let second = uuids.firstIndex(of: second.uuid) {
                return first < second
            }
            return false
        }
    }
    
    func fetchSocketFavoriteMeta(uuids: [String]) {
        socketUseCase.requestSocketUUIDS(from: uuids) { [weak self] (result: Result<[CoinMeta], NetworkError>) in
            switch result {
            case .success(let meta):
                self?.metaHandler?(meta)
            case .failure(let error):
                self?.failErrorHandler?(error)
            }
        }
    }
    
    func leaveEvent() {
        let favoriteUUID = favoriteCoinRepository.fetch()
        socketUseCase.removeEmitHandler(from: favoriteUUID)
    }
}
