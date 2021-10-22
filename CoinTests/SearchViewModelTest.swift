//
//  SearchViewModelTest.swift
//  CoinTests
//
//  Created by HOONHA CHOI on 2021/10/22.
//

import Foundation
import XCTest

class SearchViewModelTest: XCTestCase {
    
    var viewmodel: SearchViewModel!
    var spySearchService: SearchServiceSpy!
    var fakeFavoriteCoinRepository: FakeFavoriteCoinRepository!
    
    override func setUp() {
        spySearchService = SearchServiceSpy(isSuccess: false)
        fakeFavoriteCoinRepository = FakeFavoriteCoinRepository()
        viewmodel = SearchViewModel(usecase: spySearchService,
                                    repository: fakeFavoriteCoinRepository)
    }
    
    override func tearDown() {
        viewmodel = nil
        spySearchService = nil
        fakeFavoriteCoinRepository = nil
    }
    
    func test_URLParameter() {
        viewmodel.fetchSearchCoins(keyword: "testKeyword", exchange: "testExchange")
        XCTAssertEqual(spySearchService.searchURLQuery,
                       "search=testKeyword&market=krw&exchange=testExchange")
    }
    
    func test_ResponseFail() {
        viewmodel.errorHandler = { error in
            XCTAssertEqual(error, .invalidRequest)
        }
        viewmodel.fetchSearchCoins(keyword: "", exchange: "")
    }
    
    func test_ResponseSuccess() {
        viewmodel.coinsHandler = { coins in
            guard let coin = coins.first else {
                return
            }
            XCTAssertEqual(coin.englishName, "fakeName")
        }
        spySearchService.isSuccess = true
        viewmodel.fetchSearchCoins(keyword: "", exchange: "")
    }
    
    func test_registeredFavoriteCoins() {
        let registeredCoinsCount = viewmodel.registeredFavoriteCoinFetch().count
        XCTAssertEqual(registeredCoinsCount, 2)
    }
    
    func test_updateFavoriteCoin() {
        viewmodel.updateFavoriteCoin(from: "dummyUUID1")
        var registeredCoin = viewmodel.registeredFavoriteCoinFetch()
        XCTAssertEqual(registeredCoin, ["dummyUUID2"])
        viewmodel.updateFavoriteCoin(from: "dummyUUID3")
        registeredCoin = viewmodel.registeredFavoriteCoinFetch()
        XCTAssertEqual(registeredCoin, ["dummyUUID2", "dummyUUID3"])
    }
    
}
