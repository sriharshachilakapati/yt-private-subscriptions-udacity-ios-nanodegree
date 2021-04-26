//
//  SearchSuggestionsViewController.swift
//  YT Private Subscriptions
//
//  Created by Sri Harsha Chilakapati on 26/04/21.
//

import UIKit
import RxSwift
import RxCocoa

protocol SearchResultHandler {
    func handleSearchResult(_ result: String)
}

class SearchSuggestionsViewController: UIViewController, UISearchResultsUpdating {
    private let disposeBag = DisposeBag()

    @IBOutlet weak var tableView: UITableView!

    var searchResultHandler: SearchResultHandler? = nil

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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = suggestions[indexPath.row]
        searchResultHandler?.handleSearchResult(item)
        dismiss(animated: true, completion: nil)
    }
}

extension SearchSuggestionsViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardShowOrHide(notification:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func keyboardShowOrHide(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber,
              let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber,
              let keyboardFrameEnd = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else { return }

        let curveOption = UIView.AnimationOptions(rawValue: curve.uintValue << 16)
        let keyboardFrameEndRectFromView = view.convert(keyboardFrameEnd.cgRectValue, from: nil)

        UIView.animate(withDuration: duration.doubleValue,
                       delay: 0,
                       options: [curveOption, .beginFromCurrentState]) {
            self.view.frame = CGRect(x: 0,
                                     y: 0,
                                     width: keyboardFrameEndRectFromView.width,
                                     height: keyboardFrameEndRectFromView.origin.y)
        }
    }
}
