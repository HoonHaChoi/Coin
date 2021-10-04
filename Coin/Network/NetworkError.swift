//
//  NetworkError.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/07/03.
//

import Foundation

enum NetworkError: Error, CustomStringConvertible, Equatable {
    case invalidURL
    case invalidRequest
    case invalidResponse
    case invalidStatusCode(Int)
    case emptyData
    case failParsing

    var description: String {
        switch self {
        case .invalidURL:
            return "올바르지 않은 URL입니다"
        case .invalidRequest:
            return "요청에 실패하였습니다 잠시 후에 시도해주세요."
        case .invalidResponse:
            return "올바르지 않은 응답입니다"
        case .invalidStatusCode(let code):
            return "올바르지 않은 응답 코드입니다 \(code)"
        case .emptyData:
            return "올바르지 않은 데이터입니다"
        case .failParsing:
            return "데이터모델 변환에 실패하였습니다."
        }
    }
}
