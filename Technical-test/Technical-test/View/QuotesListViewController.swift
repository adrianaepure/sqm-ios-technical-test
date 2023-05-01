//
//  QuotesListViewController.swift
//  Technical-test
//
//  Created by Patrice MIAKASSISSA on 29.04.21.
//

import UIKit

/**
 Displays the list of Quotes and their corresponding information
 */

class QuotesListViewController: UIViewController {
	
	
	static let cellId = "QuoteCellIdentifier" /// cell identifier
	private let dataManager: DataManager = DataManager() /// manager for requesting the data
	private var market: Market = Market() /// market object; contains the information about favorite quotes
	private var viewModel: QuotesListViewModel?
	
	// quotesTableView
	private lazy var quotesTableView: UITableView = {
		let tableView = UITableView(frame: .zero, style: .plain)
		
		tableView.register(QuoteTableViewCell.self, forCellReuseIdentifier: QuotesListViewController.cellId) /// register tableView cell
		tableView.rowHeight = UITableView.automaticDimension
		tableView.translatesAutoresizingMaskIntoConstraints = false
		
		
		//conform to tableView protocols
		tableView.delegate = self
		tableView.dataSource = self
		
		//Create custom refresh control
		let refreshControl = UIRefreshControl()
		refreshControl.attributedTitle = NSAttributedString(string: "Fetching Quotes", attributes: [NSAttributedString.Key.foregroundColor: UIColor.label])
		refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
		tableView.refreshControl = refreshControl
		return tableView
	}()
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		viewModel = QuotesListViewModel(dataManager: dataManager, market: market) /// create view model
		viewModel?.delegate = self /// conform to QuotesListViewModelDelegate protocol
		addSubviews() /// add subviews
		setupAutolayout() /// setup constraints
		navigationItem.title = viewModel?.market.marketName /// update title with market name
		
	}
}

//MARK: QuotesListViewController UI Update Methods
extension QuotesListViewController{
	/**
	 Adds subviews to the screen
	 */
	func addSubviews(){
		view.addSubview(quotesTableView)
		pullToRefresh()
	}
	
	/**
	 Configures layout constraints
	 */
	func setupAutolayout() {
		let safeArea = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			quotesTableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
			quotesTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
			quotesTableView.leftAnchor.constraint(equalTo: safeArea.leftAnchor),
			quotesTableView.rightAnchor.constraint(equalTo: safeArea.rightAnchor)
		])
	}
	/**
	 Updates quotesTableView refresh control;
	 Starts fetching quotes from the API
	 */
	@objc func pullToRefresh(){
		quotesTableView.refreshControl?.beginRefreshing()
		viewModel?.fetchQuotes()
	}
}

//MARK: UITableViewDelegate, UITableViewDelegate delegate method implementations
extension QuotesListViewController: UITableViewDelegate, UITableViewDataSource{
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel?.quotes.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: QuotesListViewController.cellId, for: indexPath) as? QuoteTableViewCell else { fatalError("Table View Cell Error") }
		guard let quote = viewModel?.quotes[indexPath.row] else { fatalError("Wrong number")}
		cell.updateUI(with: quote)
		return cell
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let quote = viewModel?.quotes[indexPath.row] else { fatalError("Wrong number")}
		let quoteDetailsViewController = QuoteDetailsViewController(quote: quote)
		quoteDetailsViewController.delegate = self
		navigationController?.pushViewController(quoteDetailsViewController, animated: true)
	}
	
}

//MARK: QuoteDetailsViewControllerDelegate delegate method implementations
extension QuotesListViewController: QuoteDetailsViewControllerDelegate{
	func didUpdate(quote: Quote?) {
		self.viewModel?.updateFavorite(quote: quote)
		self.pullToRefresh()
	}
}

	//MARK: QuotesListViewModelDelegate delegate method implementations
extension QuotesListViewController: QuotesListViewModelDelegate{
	
	func finishedFetchingData() {
		DispatchQueue.main.async {
			self.quotesTableView.reloadData()
			self.quotesTableView.refreshControl?.endRefreshing()
		}
	}
	
	func showError(description: String) {
		DispatchQueue.main.async {
			let alertController : UIAlertController = UIAlertController(title: "Error", message: "Failed to fetch quotes data", preferredStyle: .alert)
			DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5.0){ /// dismiss after 5s
				alertController.dismiss(animated: true)
			}
			self.present(alertController, animated: true)
		}
	}
	
	
}



