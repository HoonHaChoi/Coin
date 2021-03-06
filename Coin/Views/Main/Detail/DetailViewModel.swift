//
//  DetailViewModel.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/09/06.
//

import Foundation

final class DetailViewModel: CryptoBaseViewModel {
    
    private let favoriteCoinRepository: FavoriteCoinRepository
    
    init(repository: FavoriteCoinRepository, service: NetworkService, socketUseCase: SocketUseCase) {
        self.favoriteCoinRepository = repository
        super.init(service: service, socketUsecase: socketUseCase)
    }
    
    func findFavoriteCoin(from uuid: String) -> Bool {
        return favoriteCoinRepository.find(uuid: uuid)
    }
    
    func updateFavoriteCoin(from uuid: String) {
        if findFavoriteCoin(from: uuid) {
            favoriteCoinRepository.delete(uuid: uuid)
        } else {
            favoriteCoinRepository.insert(uuid: uuid)
        }
    }
    
    func fetchSocketMeta(from uuid: String) {
        socketUseCase.requestSocketUUIDS(from: [uuid]) { [weak self] (result: Result<[CoinMeta], NetworkError>) in
            switch result {
            case .success(let meta):
                self?.metaHandler?(meta)
            case .failure(let error):
                self?.errorHandler?(error)
            }
        }
    }
    
    func leaveEvent(from event: String) {
        socketUseCase.removeEmitHandler(from: [event])
    }
}
