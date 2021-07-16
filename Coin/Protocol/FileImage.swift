//
//  FileImage.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/07/16.
//

import Foundation

protocol FileImage {
    var cacheDirectory: URL { get }
    func exists(atPath: String) -> Bool
    func create(atPath: String, contents: Data)
}

