//
//  ExploreViewController.swift
//  YT Private Subscriptions
//
//  Created by Sri Harsha Chilakapati on 24/04/21.
//

import UIKit
import RxSwift

class ExploreViewController: UIViewController, SearchResultHandler {

    @IBOutlet weak var enterQueryLabel: UILabel!
    @IBOutlet weak var noInternetDialog: UIView!
    @IBOutlet weak var tableView: UITableView!

    private let disposeBag = DisposeBag()
    private let viewModel = ExploreViewModel()
    private let dataSource = ExploreSearchResultDataSource()

    private lazy var searchController: UISearchController = {
        let suggestionsVC = storyboard?.instantiateViewController(identifier: String(describing: SearchSuggestionsViewController.self))
            as? SearchSuggestionsViewController

        if #available(iOS 13.0, *) {
            suggestionsVC?.overrideUserInterfaceStyle = .dark
        }

        let searchController = UISearchController(searchResultsController: suggestionsVC)
        searchController.searchResultsUpdater = suggestionsVC
        searchController.searchBar.delegate = suggestionsVC
        suggestionsVC?.searchResultHandler = self

        return searchController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: YoutubeVideoTableViewCell.nibName, bundle: nil),
                           forCellReuseIdentifier: YoutubeVideoTableViewCell.reuseIdentifier)

        noInternetDialog.layer.cornerRadius = 16
        noInternetDialog.backgroundColor = noInternetDialog.backgroundColor?.withAlphaComponent(0.95)

        tableView.delegate = self
        tableView.dataSource = dataSource

        NetworkMonitor.shared.isConnected
            .distinctUntilChanged()
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] isConnected in
                self?.noInternetDialog.isHidden = isConnected
                self?.searchController.searchBar.isUserInteractionEnabled = isConnected

                self?.enterQueryLabel.isHidden = isConnected
                    ? (self?.dataSource.searchResults.count ?? 0) > 0
                    : true
            })
            .disposed(by: disposeBag)

        viewModel.searchResults
            .subscribe(onNext: { results in
                self.dataSource.searchResults = results
                self.enterQueryLabel.isHidden = results.count > 0
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)

        viewModel.isNetworkCallInProgress
            .subscribe(onNext: { inProgress in
                if inProgress {
                    self.showNetworkProgressHUD()
                } else {
                    self.hideProgressHUD()
                }
            })
            .disposed(by: disposeBag)
    }

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
        searchController.searchBar.text = result
        viewModel.searchText = result
    }
}

extension ExploreViewController: UITableViewDelegate {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "toVideoPlayerScreen" else { return }

        guard let sender = sender as? VideoPlayerInput,
              let destVC = segue.destination as? VideoPlayerViewController
        else { return }

        destVC.input = sender
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let result = dataSource.searchResults[indexPath.row]
        let input = VideoPlayerInput(
            videoId: result.id.videoId,
            videoTitle: result.snippet.title,
            videoDescription: result.snippet.description,
            channelId: result.snippet.channelId,
            channelName: result.snippet.channelTitle
        )

        performSegue(withIdentifier: "toVideoPlayerScreen", sender: input)
    }
}
