//
//  AppOperationsManager.swift
//  VK Search
//
//  Created by Krasa on 21.07.2018.
//  Copyright © 2018 Krasa. All rights reserved.
//

import Foundation

struct AppOperationsManager {
    private static let operationQueue = OperationQueue()
    func addOperation(op: Operation, cancellingQueue: Bool) {
        AppOperationsManager.operationQueue.maxConcurrentOperationCount = 1
        if cancellingQueue {
            AppOperationsManager.operationQueue.cancelAllOperations()
        }
        AppOperationsManager.operationQueue.addOperation(op)
    }
}
