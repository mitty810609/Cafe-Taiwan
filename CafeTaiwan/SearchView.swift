//
//  SearchView.swift
//  CafeTaiwan
//
//  Created by mitty on 2017/6/16.
//  Copyright © 2017年 iFucking. All rights reserved.
//

import UIKit

class SearchView: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var searchResults = [CafeShop]()
    var allCafeShops: [CafeShop]!
    var didSelectCafeShop: CafeShop?
        
    override func viewDidLoad() {
        //  防止 tableView 上移
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let row = tableView.indexPathForSelectedRow?.row {
            didSelectCafeShop = searchResults[row]
        }
    }
}
extension SearchView: UISearchResultsUpdating {
    func filterContent(for searchText: String) {
        searchResults = allCafeShops.filter({ (cafeShop) -> Bool in
            //  case insensitive 為不區分大小寫
            if cafeShop.name.localizedCaseInsensitiveContains(searchText) || cafeShop.address.localizedCaseInsensitiveContains(searchText) {
                return true
            }
            return false
        })
    }
        //  當使用者選取搜尋列、輸入關鍵字時，此方法就會被呼叫
    func updateSearchResults(for searchController: UISearchController) {
        //  如果有成功取得到使用者輸入的字串，呼叫 filterContext 方法進行內容過濾
        //  最後重新 reload，顯示過濾完的結果
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            tableView.reloadData()
        }
    }
}

extension SearchView: UITableViewDelegate, UITableViewDataSource {
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = searchResults[indexPath.row].name
        cell.detailTextLabel?.text = searchResults[indexPath.row].address
        return cell
    }
}
