//
//  DetailViewModel.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/09/06.
//

import Foundation

final class DetailViewModel: CryptoBaseViewModel {
    
    private let favoriteCoinRepository: FavoriteCoinRepository
    
    init(repository: FavoriteCoinRepository,
         searchUseCase: SearchUseCase,
         socketUseCase: SocketUseCase) {
        self.favoriteCoinRepository = repository
        super.init(searchUsecase: searchUseCase,
                   socketUsecase: socketUseCase)
    }
    
    func findFavoriteCoin(from uuid: String) -> Bool{
        return favoriteCoinRepository.find(uuid: uuid)
    }
    
    func updateFavoriteCoin(from uuid: String) {
        if findFavoriteCoin(from: uuid) {
            favoriteCoinRepository.delete(uuid: uuid)
        } else {
            favoriteCoinRepository.insert(uuid: uuid)
        }
    }
}
