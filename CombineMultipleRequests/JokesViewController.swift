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
    
    private var cancellables = Set<AnyCancellable>()

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
        refreshView.update(isRefreshing: true)
        
        loadData()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.refreshView.update(isRefreshing: false)
                
                switch completion {
                case .finished: break
                case .failure(let error):
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                }
            }, receiveValue: { [weak self] joke in
                self?.jokes = [joke]
            })
            .store(in: &cancellables)
        
    }
}

extension JokesViewController {
    private func loadData() -> AnyPublisher<Joke, Error> {
        loadCategories()
            .flatMap(loadJoke)
            .eraseToAnyPublisher()
    }

    private func loadCategories() -> AnyPublisher<[Category], Error> {
        let url = baseURL.appending(path: "categories")
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { result in
                guard let response = result.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return result.data
            }
            .decode(type: [String].self, decoder: JSONDecoder())
            .map { categories in
                categories.map { Category(title: $0) }
            }
            .eraseToAnyPublisher()
    }
    
    private func loadJoke(categories: [Category]) -> AnyPublisher<Joke, Error> {
        var url = baseURL.appending(path: "random")
        let queryItems = [URLQueryItem(name: "category", value: categories.first?.title)]
        url.append(queryItems: queryItems)
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { result in
                guard let response = result.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return result.data
            }
            .decode(type: Joke.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
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
