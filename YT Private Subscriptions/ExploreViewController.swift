//
//  ExploreViewController.swift
//  YT Private Subscriptions
//
//  Created by Sri Harsha Chilakapati on 24/04/21.
//

import UIKit

class ExploreViewController: UIViewController {
    private var searchController = UISearchController(searchResultsController: nil)

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        searchController.searchBar.tintColor = .white
        parent?.navigationItem.searchController = searchController
    }
}
