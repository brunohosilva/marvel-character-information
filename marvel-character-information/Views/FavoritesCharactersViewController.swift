//
//  FavoritesCharacters.swift
//  marvel-character-information
//
//  Created by Bruno Oliveira on 22/09/24.
//

import UIKit

class FavoritesCharactersViewController: UIViewController, SearchViewControllerDelegate {
    
    let viewModel = MarvelCharacterViewModel(fetchMarvelCharacters: FetchMarvelCharacters())
    let favoriteManager = FavoriteManager()
                                             
    var tableView = UITableView()
    var characters: [MarvelCharacterModel] = []
    
    private let emptyListImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "exclamationmark.triangle") // Escolha um ícone apropriado
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true // Inicialmente escondido
        return imageView
    }()

    private let emptyListLabel: UILabel = {
        let label = UILabel()
        label.text = "You don't have any favorites"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true // Inicialmente escondido
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.title = "Favorites Characters"
        
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

extension FavoritesCharactersViewController: UITableViewDelegate {
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

extension FavoritesCharactersViewController {
    
    private func setupView() {
        setupSearchController()
        setupTableView()
        setupEmptyListView()
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
}

extension FavoritesCharactersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard indexPath.row < characters.count else {
            return UITableViewCell()
        }
        
        let character = self.characters[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CharacterCardView.characterCardID, for: indexPath) as! CharacterCardView
        let description = character.description.isEmpty ? "Sorry no description content" : character.description
        cell.selectionStyle = .none
        cell.configure(
            title: character.name,
            description: description,
            backgroundImageURL: character.imageUrl,
            isFavorite: true
        )
        
        cell.onFavoriteButtonTapped = { [weak self] in
            self?.favoriteManager.removeFavorite(characterID: character.id)
            self?.characters.remove(at: indexPath.row)
            self?.tableView.deleteRows(at: [indexPath], with: .fade)
            self?.fetchData()
            NotificationCenter.default.post(name: .favoritesUpdated, object: nil)
        }
        return cell
    }
}

extension FavoritesCharactersViewController {
    
    private func fetchData() {
        characters = favoriteManager.getFavoriteCharacters() // Carrega os favoritos
        reloadView()
    }
    
    private func reloadView() {
        if characters.isEmpty {
            emptyListImageView.isHidden = false
            emptyListLabel.isHidden = false
            tableView.isHidden = true
        } else {
            emptyListImageView.isHidden = true
            emptyListLabel.isHidden = true
            tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
    
    @objc private func favoritesUpdated() {
        fetchData()
    }
    
    func didUpdateSearchQuery(_ query: String) {

    }
}
