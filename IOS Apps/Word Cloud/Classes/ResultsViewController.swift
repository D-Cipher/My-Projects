//
//  ResultsViewController.swift
//  Word Cloud
//
//  Created by Tingbo Chen on 5/10/16.
//  Copyright © 2016 Tingbo Chen. All rights reserved.
//

import UIKit

class ResultsViewController: UITableViewController {

	// MARK: - Properties

	var results: [String] = []


	// MARK: - Initializers
	
	convenience init() {
		self.init(style: .Plain)
	}


	// MARK: - UIViewController
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }


	// MARK: - UITableViewDataSource
	
    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = results[indexPath.row]
        return cell
    }
}


extension ResultsViewController: UISearchResultsUpdating {
	func updateSearchResultsForSearchController(searchController: UISearchController) {
		if let text = searchController.searchBar.text, result = Thesaurus.defaultThesaurus().resultForQuery(text) {
			results = result.synonyms
		} else {
			results = []
		}
		tableView.reloadData()
	}
}
