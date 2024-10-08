//
//  MarvelCharactersViewController.swift
//  marvel-character-information
//
//  Created by Bruno Oliveira on 19/09/24.
//

import UIKit

class MarvelCharactersViewController: UIViewController, SearchViewControllerDelegate {
    
    let viewModel = MarvelCharacterViewModel(fetchMarvelCharacters: FetchMarvelCharacters())
    let favoriteManager = FavoriteManager()
                                             
    var tableView = UITableView()
    var characters: [MarvelCharacterModel] = []
    
    private let networkingErroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "wifi.exclamationmark") // Escolha um ícone apropriado
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true // Inicialmente escondido
        return imageView
    }()
    
    private let emptyListImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "exclamationmark.triangle") // Escolha um ícone apropriado
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true // Inicialmente escondido
        return imageView
    }()

    private let emptyListLabel: UILabel = {
        let label = UILabel()
        label.text = "No characters found."
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true // Inicialmente escondido
        return label
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large) // Usamos o estilo grande como base
        indicator.color = .systemBlue
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading marvel characters informations..."
        label.font = UIFont.systemFont(ofSize: 16)
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(favoritesUpdated), name: .favoritesUpdated, object: nil)
    }
}

extension MarvelCharactersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let character = characters[indexPath.row]
        let description = character.description.isEmpty ? "Sorry no description content" : character.description
        let isFavorite = favoriteManager.isFavorite(characterID: character.id)
        
        let bottomSheet = CharacterDetailsViewController(
            title: character.name,
            description: description,
            imageURL: URL(string: character.imageUrl),
            isFavorite: isFavorite
        )
        
        bottomSheet.modalPresentationStyle = .pageSheet
        present(bottomSheet, animated: true, completion: nil)
    }
}

extension MarvelCharactersViewController {
    
    private func setupView() {
        setupSearchController()
        setupTableView()
        setupActivityIndicator()
        setupEmptyListView()
        setupNetworkingErrorView()
    }
    
    private func setupNetworkingErrorView() {
        view.addSubview(networkingErroImageView)

        // Centralizando o ícone
        NSLayoutConstraint.activate([
            networkingErroImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            networkingErroImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -10),
            networkingErroImageView.widthAnchor.constraint(equalToConstant: 50),
            networkingErroImageView.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    private func setupEmptyListView() {
        view.addSubview(emptyListImageView)
        view.addSubview(emptyListLabel)

        // Centralizando o ícone
        NSLayoutConstraint.activate([
            emptyListImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyListImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -10),
            emptyListImageView.widthAnchor.constraint(equalToConstant: 50),
            emptyListImageView.heightAnchor.constraint(equalToConstant: 50),

            // Colocando o texto abaixo do ícone
            emptyListLabel.topAnchor.constraint(equalTo: emptyListImageView.bottomAnchor, constant: 8),
            emptyListLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
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
        
        let character = self.characters[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CharacterCardView.characterCardID, for: indexPath) as! CharacterCardView
        let description = character.description.isEmpty ? "Sorry no description content" : character.description
        let isFavorite = favoriteManager.isFavorite(characterID: character.id)
        cell.selectionStyle = .none
        cell.configure(
            title: character.name,
            description: description,
            backgroundImageURL: character.imageUrl,
            isFavorite: isFavorite
        )
        
        cell.onFavoriteButtonTapped = { [weak self] in
            guard let self = self else { return }
            if self.favoriteManager.isFavorite(characterID: character.id) {
                self.favoriteManager.removeFavorite(characterID: character.id)
            } else {
                self.favoriteManager.addFavorite(character: character)
            }
            NotificationCenter.default.post(name: .favoritesUpdated, object: nil)
        }
        return cell
    }
}

extension MarvelCharactersViewController {
    
    @objc private func favoritesUpdated() {
        for (index, character) in characters.enumerated() {
            let isFavorite = favoriteManager.isFavorite(characterID: character.id)
            
            if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? CharacterCardView {
                cell.favoriteButton.isSelected = isFavorite
            }
        }
    }
    
    private func showErrorAlert(message: String) {
        networkingErroImageView.isHidden = false
        let alert = UIAlertController(title: "Networking Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func fetchData() {
        networkingErroImageView.isHidden = true
        activityIndicator.startAnimating()
        viewModel.getMarvelCharacters(nameStartsWith: nil)
        
        viewModel.onCharactersFetched = { [weak self] characters in
            guard let self else { return }
            self.characters = characters
            reloadView()
        }
        
        viewModel.onErrorOccurred = { [weak self] errorMessage in
            guard let self = self else { return }
            self.showErrorAlert(message: errorMessage)
            self.activityIndicator.stopAnimating()
            self.loadingLabel.isHidden = true
        }
    }
    
    private func reloadView() {
        networkingErroImageView.isHidden = true
        activityIndicator.stopAnimating()
        loadingLabel.isHidden = true

        if characters.isEmpty {
            emptyListImageView.isHidden = false
            emptyListLabel.isHidden = false
            tableView.isHidden = true // Esconde a tabela se a lista estiver vazia
        } else {
            emptyListImageView.isHidden = true
            emptyListLabel.isHidden = true
            tableView.isHidden = false // Mostra a tabela se houver personagens
            self.tableView.reloadData()
        }
    }
    
    func didUpdateSearchQuery(_ query: String) {
        networkingErroImageView.isHidden = true
        emptyListImageView.isHidden = true
        emptyListLabel.isHidden = true
        
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
        
        viewModel.onErrorOccurred = { [weak self] errorMessage in
            guard let self = self else { return }
            self.showErrorAlert(message: errorMessage)
            self.activityIndicator.stopAnimating()
            self.loadingLabel.isHidden = true
        }
    }
}
