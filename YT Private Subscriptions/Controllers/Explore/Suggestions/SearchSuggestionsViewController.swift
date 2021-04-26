//
//  SearchSuggestionsViewController.swift
//  YT Private Subscriptions
//
//  Created by Sri Harsha Chilakapati on 26/04/21.
//

import UIKit
import RxSwift
import RxCocoa

class SearchSuggestionsViewController: UIViewController, UISearchResultsUpdating {
    private let disposeBag = DisposeBag()

    @IBOutlet weak var tableView: UITableView!

    private var viewModel = SearchSuggestionsViewModel()
    private var suggestions = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self

        viewModel.searchSuggestions
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { suggestions in
                self.suggestions = suggestions
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }

    func updateSearchResults(for searchController: UISearchController) {
        viewModel.searchText = searchController.searchBar.text ?? ""
    }
}

extension SearchSuggestionsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        suggestions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = suggestions[indexPath.row]
        return cell
    }
}
