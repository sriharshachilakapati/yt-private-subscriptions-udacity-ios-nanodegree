//
//  ExploreViewController.swift
//  YT Private Subscriptions
//
//  Created by Sri Harsha Chilakapati on 24/04/21.
//

import UIKit

class ExploreViewController: UIViewController, SearchResultHandler {
    private lazy var searchController: UISearchController = {
        let suggestionsVC = storyboard?.instantiateViewController(identifier: String(describing: SearchSuggestionsViewController.self))
            as? SearchSuggestionsViewController

        if #available(iOS 13.0, *) {
            suggestionsVC?.overrideUserInterfaceStyle = .dark
        }

        let searchController = UISearchController(searchResultsController: suggestionsVC)
        searchController.searchResultsUpdater = suggestionsVC
        suggestionsVC?.searchResultHandler = self

        return searchController
    }()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let superView = parent?.navigationController?.view else { return }
        
        UIView.transition(with: superView, duration: 0.3, options: .transitionCrossDissolve) {
            self.parent?.navigationItem.searchController = self.searchController
            self.searchController.searchBar.tintColor = .white
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let superView = parent?.navigationController?.view else { return }
        
        UIView.transition(with: superView, duration: 0.3, options: .transitionCrossDissolve) {
            self.parent?.navigationItem.searchController = nil
        }
    }

    func handleSearchResult(_ result: String) {
        print("Selected \(result)")
        searchController.searchBar.text = result
    }
}
