//
//  SearchViewController.swift
//  ARDust
//
//  Created by youngjun goo on 03/04/2019.
//  Copyright © 2019 youngjun goo. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    let umds = (UIApplication.shared.delegate as! AppDelegate).umds
    var filteringUmdData = [UmdData]()
    
    @IBOutlet var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    // SearchBar Text의 값이 있는지 판단
    private func isEmptySaerchText() -> Bool {
        if searchBar.text!.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    private func filterLocationForSearchText(_ searchText: String) {
        filteringUmdData = umds.filter { (umd) -> Bool in
            if isEmptySaerchText() {
                return umd.name.contains(searchText)
            } else {
                return true
            }
        }
        tableView.reloadData()
    }
    
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isEmptySaerchText() {
            return filteringUmdData.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "umdCell", for: indexPath)
       
        if isEmptySaerchText() {
            let umdData = filteringUmdData[indexPath.row]
            cell.textLabel?.text = umdData.name
        }
         return cell
    }
   
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    // Text가 변경됨에 따라 즉각적으로 지역 이름을 나열 해주기 위함
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
}
