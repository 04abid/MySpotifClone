//
//  SearchResultsController.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 28.03.26.
//

import UIKit

class SearchResultsController: BaseController {

    private lazy var table: UITableView = {
       let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.backgroundColor = .black
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        table.backgroundColor = .black
        return table
    }()
    
    var searchData: Search?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(table)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        table.frame = view.bounds
    }
    
    func updateSearch(data: Search) {
        self.searchData = data
        table.reloadData()
    }
}

extension SearchResultsController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        SearchSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        SearchSection(rawValue: section)?.title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let data = searchData,
                 let sectionType = SearchSection(rawValue: section) else { return 0 }
        switch sectionType {
        case .tracks: return data.tracks?.items.count ?? 0
        case .albums: return data.albums?.items.count ?? 0
        case .artists: return data.artists?.items.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        guard let sectionType = SearchSection(rawValue: indexPath.section) else { return cell }
        
        switch sectionType {
        case .tracks:
            cell.textLabel?.text = searchData?.tracks?.items[indexPath.row].name
        case .artists:
            cell.textLabel?.text = searchData?.artists?.items[indexPath.row].name
        case .albums:
            cell.textLabel?.text = searchData?.albums?.items[indexPath.row].name
        }
        return cell
    }
}
