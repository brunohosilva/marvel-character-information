//
//  MarvelCharactersViewController.swift
//  marvel-character-information
//
//  Created by Bruno Oliveira on 19/09/24.
//

import UIKit

class MarvelCharactersViewController: UIViewController, SearchViewControllerDelegate {
    
    let viewModel = MarvelCharacterViewModel(fetchMarvelCharacters: FetchMarvelCharacters())
                                             
    var tableView = UITableView()
    var characters: [MarvelCharacterModel] = []
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large) // Usamos o estilo grande como base
        indicator.color = .black
        indicator.translatesAutoresizingMaskIntoConstraints = false
        // Aqui aumentamos o spinner para 1.5x do tamanho original
        indicator.transform = CGAffineTransform(scaleX: 2, y: 2)
        return indicator
    }()
    
    private let loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading marvel characters informations..."
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.title = "Marvel Characters"
        
        // Configura a fonte do título para grandes títulos
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30) // Altera o tamanho da fonte
        ]
        
        setupView()
        fetchData()
    }   
}

extension MarvelCharactersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("click")
    }
}

extension MarvelCharactersViewController {
    
    private func setupView() {
        setupSearchController()
        setupTableView()
        setupActivityIndicator()
    }
    
    private func setupSearchController() {
         let searchVC = SearchViewController()
         searchVC.delegate = self
         addChild(searchVC)
         searchVC.view.translatesAutoresizingMaskIntoConstraints = false
         view.addSubview(searchVC.view)
         
         NSLayoutConstraint.activate([
             searchVC.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
             searchVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             searchVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             searchVC.view.heightAnchor.constraint(equalToConstant: 60)
         ])
         
         searchVC.didMove(toParent: self)
     }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = .clear
        tableView.register(CharacterCardView.self, forCellReuseIdentifier: CharacterCardView.characterCardID)
        tableView.tableFooterView = UIView()
        
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupActivityIndicator() {
        view.addSubview(loadingLabel)
        view.addSubview(activityIndicator)
       
        
        // Centralizando o spinner
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20) // Um pouco acima do centro
        ])
        
        // Colocando o texto abaixo do spinner
        NSLayoutConstraint.activate([
            loadingLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 24),
            loadingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

extension MarvelCharactersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let characters = self.characters[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CharacterCardView.characterCardID, for: indexPath) as! CharacterCardView
        cell.configure(
            title: characters.name,
            description: characters.description,
            backgroundImageURL: characters.imageUrl
        )
        return cell
        
    }
}

extension MarvelCharactersViewController {
    
    private func fetchData() {
        activityIndicator.startAnimating()
        viewModel.getMarvelCharacters(nameStartsWith: nil)
        
        viewModel.onCharactersFetched = { [weak self] characters in
            guard let self else { return }
            self.characters = characters
            reloadView()
        }
    }
    
    private func reloadView() {
        activityIndicator.stopAnimating()
        loadingLabel.isHidden = true
        self.tableView.reloadData()
    }
    
    func didUpdateSearchQuery(_ query: String) {
        characters.removeAll()
        tableView.reloadData()
        activityIndicator.startAnimating()
        loadingLabel.isHidden = false
        
        viewModel.searchCharacters(query: query)
        
        viewModel.onCharactersFetched = { [weak self] characters in
            guard let self = self else { return }
            self.characters = characters
            self.reloadView()
        }
    }
}
