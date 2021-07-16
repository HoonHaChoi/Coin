//
//  FileManager+Extension.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/07/16.
//

import Foundation

extension FileManager: FileImage {
    var cacheDirectory: URL {
        self.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
    
    func exists(atPath: String) -> Bool {
        return self.fileExists(atPath: atPath)
    }
    
    func create(atPath: String, contents: Data) {
        self.createFile(atPath: atPath, contents: contents, attributes: nil)
    }
}
