//
//  ImageDownloadOperation.swift
//  MovieReaderReview
//
//  Created by user on 2/21/17.
//  Copyright © 2017 vuki. All rights reserved.
//

import Foundation

typealias StringClosure = (String) -> ()

class ImageDownloadOperation: Operation {

    private let completion: StringClosure
    private let operationIndex: Int

    init(with operationIndex: Int, completion: @escaping StringClosure) {
        self.completion = completion
        self.operationIndex = operationIndex
    }

    override func start() {
        if isCancelled {
            return
        }

        // Image download mock.
        let randomMilliseconds: TimeInterval = Double(arc4random_uniform(700)) / 1000.0
        Thread.sleep(forTimeInterval: randomMilliseconds)

        if isCancelled {
            return
        }
        
        DispatchQueue.main.async {
            self.completion("Image \(self.operationIndex) downloaded...")
        }
    }
}
