//
//  JokesViewController.swift
//  CombineMultipleRequests
//
//  Created by Artem Ekimov on 3/9/23.
//

import UIKit
import Combine

class JokesViewController: UITableViewController {
    
    private lazy var refreshView: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        return view
    }()
    
    private let baseURL = URL(string: "https://api.chucknorris.io/jokes")!
        
    private var jokes: [Joke] = [] {
        didSet { tableView.reloadData() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        onRefresh()
    }

    private func setupView() {
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self)
        tableView.refreshControl = refreshView
    }
    
    @objc private func onRefresh() {
        updateJokes()
    }
    
    private func updateJokes() {

    }
}

extension JokesViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jokes.count
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(for: indexPath)
        let model = jokes[indexPath.row]
        cell.textLabel?.text = model.value
        cell.textLabel?.numberOfLines = 0
        cell.selectionStyle = .none
        return cell
    }
}
