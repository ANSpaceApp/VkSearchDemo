//
//  SearchUsersOperation.swift
//  VK Search
//
//  Created by Krasa on 21.07.2018.
//  Copyright © 2018 Krasa. All rights reserved.
//

import Foundation

class SearchUsersOperation: Operation {
    var paginationInfo: PaginationInfo?
    var textToSearch: String
    var success: (PaginationInfo, [User])-> Void
    var failure: (Int)-> Void
    private var internetTask: URLSessionTask?
    
    init(paginationInfo: PaginationInfo?,
         textToSearch: String,
         success: @escaping (PaginationInfo, [User])-> Void,
         failure: @escaping (Int)-> Void) {
        self.textToSearch = textToSearch
        self.success = success
        self.failure = failure
        self.paginationInfo = paginationInfo
        super.init()
    }
    
    override func cancel() {
        internetTask?.cancel()
        super.cancel()
    }
    
    override func main() {
        
        let semaphore = DispatchSemaphore(value: 0)
        
        if paginationInfo == nil {
            paginationInfo = PaginationInfo(count: 50, offset: 0, totalCount: 0)
        }
        
        let url = URL(string: "https://api.vk.com/method/users.search?q=\(textToSearch)&count=\(paginationInfo!.count)&offset=\(paginationInfo!.offset)&filters=friends&fields=photo_200&access_token= &v=5.80")!
        
        print("\(url)")
        
        internetTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            print("отмена задачи - \(self.isCancelled)")
            
            if self.isCancelled == false {
                if data != nil {
                    if let usersResponse = try? JSONDecoder().decode(UsersResponse.self, from: data!) {
                        self.paginationInfo!.totalCount = usersResponse.response.count
                        self.success(self.paginationInfo!, usersResponse.response.items)
                    }else {
                        self.success(self.paginationInfo!, [User]())
                    }
                    
                }
                if error != nil {
                    print("отменена задача - \((error! as NSError).code)")
                    self.failure((error! as NSError).code)
                }
            }else {
                self.success(self.paginationInfo!, [User]())
            }
            print("semaphore.signal()")
            semaphore.signal()
        })
        internetTask?.resume()
        print("до семафора")
        _ = semaphore.wait()
        print("после семафора")
        
    }
}
