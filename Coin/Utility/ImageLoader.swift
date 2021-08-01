//
//  ImageLoader.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/07/15.
//

import UIKit
import Combine

struct ImageLoader: Loader {
 
    private let fileManager: FileImage
    private let urlSession: ImageRequset
    private let thumbnailImage = UIImage(systemName: "bitcoinsign.circle")
    
    init(session: ImageRequset = URLSession.shared,
         fileManager: FileImage = FileManager.default) {
        self.urlSession = session
        self.fileManager = fileManager
    }
    
    func load(urlString: String) -> AnyPublisher<UIImage?, Never> {
        guard let url = URL(string: urlString) else {
            return Just(thumbnailImage).eraseToAnyPublisher()
        }
        let path = fileManager.cacheDirectory.appendingPathComponent(url.lastPathComponent)
        
        if fileManager.exists(atPath: path.path) {
            return Just(UIImage(contentsOfFile: path.path)).eraseToAnyPublisher()
        }
        
        return request(savePath: path.path, url: url).map {
            if $0.isEmpty {
                return self.thumbnailImage
            } else {
                self.saveFile(savePath: path.path, data: $0)
                return UIImage(contentsOfFile: path.path)
            }
        }.eraseToAnyPublisher()
    }
    
    private func saveFile(savePath: String, data: Data){
        fileManager.create(atPath: savePath, contents: data)
    }
    
    private func request(savePath: String, url: URL) -> AnyPublisher<Data, Never>{
        return urlSession.request(url: url)
    }
    
}

