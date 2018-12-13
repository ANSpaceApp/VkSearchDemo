//
//  ViewController.swift
//  VK Search
//
//  Created by Krasa on 14.07.2018.
//  Copyright © 2018 Krasa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var dataSource = [User]()
    var paginationInfo: PaginationInfo?
    var currentSearchString = ""
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 60
        getData(urlEncodedString: "")
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = dataSource[indexPath.row]
        let cell = UITableViewCell()
        cell.textLabel?.text = user.first_name + " " + user.last_name
        
        if indexPath.row == dataSource.count - 1 {
            print("\(indexPath.row) == \(dataSource.count - 1)")
            getData(urlEncodedString: currentSearchString)
        }
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let bar = UISearchBar()
        bar.delegate = self
        return bar
        
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("текст поиску - \(searchText)")
        if let urlEncodedString = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed) {
            currentSearchString = urlEncodedString
            print("текст урл энкодед - \(urlEncodedString)")
            paginationInfo = nil
            getData(urlEncodedString: urlEncodedString)
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}

extension ViewController {
    private func getData(urlEncodedString: String) {
        if paginationInfo?.shouldLoadMore ?? true == true {
            paginationInfo?.nextPage()
            let opManager = AppOperationsManager()
            let operation = SearchUsersOperation(paginationInfo: paginationInfo,
                                                 textToSearch: urlEncodedString,
                                                 success: { (newPaginationInfo, users) in
                                                    DispatchQueue.main.async {
                                                        self.paginationInfo = newPaginationInfo
                                                        if newPaginationInfo.offset == 0 {
                                                            self.dataSource = users
                                                        }else {
                                                            self.dataSource.append(contentsOf: users)
                                                        }
                                                        self.tableView.reloadData()
                                                    }
            }) { (code) in
                
            }
            opManager.addOperation(op: operation, cancellingQueue: true)
        }
    }
}


