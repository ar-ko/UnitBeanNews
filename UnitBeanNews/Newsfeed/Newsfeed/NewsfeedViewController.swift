//
//  NewsViewController.swift
//  UnitBeanNews
//
//  Created by ar_ko on 21.12.2020.
//

import UIKit

protocol NewsfeedDisplayLogic: class {
    func displayData(viewModel: Newsfeed.Model.ViewModel.ViewModelData)
}

class NewsfeedViewController: UIViewController, NewsfeedDisplayLogic {
      
    var interactor: NewsfeedBusinessLogic?
    var router: (NSObjectProtocol & NewsfeedRoutingLogic)?
    
    private var feedViewModel = FeedViewModel(cells: [])
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
    //MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    //MARK: Routing
    
    
    //MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupTableView()
        
        setupTitle()
        
        interactor?.makeRequest(request: .getNewsfeed)
    }
    
    //MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = NewsfeedInteractor()
        let presenter = NewsfeedPresenter()
        let router = NewsfeedRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: NewsfeedCell.reuseId, bundle: nil), forCellReuseIdentifier: NewsfeedCell.reuseId)
        
        tableView.register(UINib(nibName: LoadMoreCell.reuseId, bundle: nil), forCellReuseIdentifier: LoadMoreCell.reuseId)
        
        
        tableView.addSubview(refreshControl)
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func setupTitle() {
        let logo = UIImage(named: "Title.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
    }
    
    @objc private func refresh() {
        interactor?.makeRequest(request: .getNewsfeed)
    }
    
    //MARK: Display logic
    
    func displayData(viewModel: Newsfeed.Model.ViewModel.ViewModelData) {
        
        switch viewModel {
        case .displayNewsfeed(feedViewModel: let feedViewModel):
            self.feedViewModel = feedViewModel
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        }
    }
}

    //MARK: UITableViewDelegate, UITableViewDataSource

extension NewsfeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedViewModel.cells.count != 0 ? feedViewModel.cells.count + 1 : feedViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case ..<feedViewModel.cells.count:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsfeedCell.reuseId, for: indexPath) as? NewsfeedCell else { return UITableViewCell() }
            cell.setup(viewModel: feedViewModel.cells[indexPath.row])
            return cell
        case feedViewModel.cells.count:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LoadMoreCell.reuseId, for: indexPath) as? LoadMoreCell else { return UITableViewCell() }
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < feedViewModel.cells.count {
            let secondViewController = NewsReaderViewController.instantiate()
            secondViewController.urlString = feedViewModel.cells[indexPath.row].url
            
            self.navigationController?.pushViewController(secondViewController, animated: true)
        } else {
            interactor?.makeRequest(request: .newsfeedNextPage)
        }
        
    }
    
    /*func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y > scrollView.contentSize.height / 1.1 {
            interactor?.makeRequest(request: .newsfeedNextPage)
        }
    }*/
}
