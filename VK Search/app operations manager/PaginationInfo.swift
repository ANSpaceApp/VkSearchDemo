//
//  PaginationInfo.swift
//  VK Search
//
//  Created by Krasa on 28.07.2018.
//  Copyright © 2018 Krasa. All rights reserved.
//

import Foundation
/*
struct PaginationInfo {
    var count = 50
    var startFrom = ""
}
*/

struct PaginationInfo {
    var count = 50
    var offset = 0
    var totalCount = 0
    var shouldLoadMore: Bool {
        return offset + count < totalCount
    }
    mutating func nextPage() {
        if shouldLoadMore {
            offset += count
        }
    }
}
