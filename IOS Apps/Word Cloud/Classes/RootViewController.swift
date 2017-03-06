//
//  RootViewController.swift
//  Word Cloud
//
//  Created by Tingbo Chen on 5/10/16.
//  Copyright © 2016 Tingbo Chen. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

	// MARK: - Properties

	var searchController: UISearchController = {
		let resultsViewController = ResultsViewController()
		let viewController = UISearchController(searchResultsController: resultsViewController)
		viewController.hidesNavigationBarDuringPresentation = false
		viewController.searchResultsUpdater = resultsViewController
		return viewController
	}()


	// MARK: - Initializers

	convenience init() {
		self.init(nibName: nil, bundle: nil)
	}


	// MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

		definesPresentationContext = true
		navigationItem.titleView = searchController.searchBar
    }
}
