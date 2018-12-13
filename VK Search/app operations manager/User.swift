//
//  User.swift
//  VK Search
//
//  Created by Krasa on 21.07.2018.
//  Copyright © 2018 Krasa. All rights reserved.
//

import Foundation

struct User: Codable {
    var id = 0
    var first_name = ""
    var last_name = ""
    //var photo_200 = ""
}

struct UsersInnerResponse: Codable {
    var count = 0
    var items = [User]()
}

struct UsersResponse: Codable {
    var response: UsersInnerResponse
}
