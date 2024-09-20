//
//  MarvelCharactersViewController.swift
//  marvel-character-information
//
//  Created by Bruno Oliveira on 19/09/24.
//

import UIKit

class MarvelCharactersViewController: UIViewController {
    
    let viewModel = MarvelCharacterViewModel(fetchMarvelCharacters: FetchMarvelCharacters())
                                             
    var tableView = UITableView()
    
    var isLoaded = false
    
    var characters: [MarvelCharacterModel] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchData()

    }
}

extension MarvelCharactersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension MarvelCharactersViewController {
    private func setupTableView() {
        tableView.backgroundColor = .gray
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(CharacterCardView.self, forCellReuseIdentifier: CharacterCardView.characterCardID)
        tableView.tableFooterView = UIView()

        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension MarvelCharactersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !characters.isEmpty else { return UITableViewCell() }
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
        viewModel.getMarvelCharacters()
        
        viewModel.onCharactersFetched = { [weak self] characters in
            guard let self else { return }
            self.characters = characters
            self.isLoaded = true
            reloadView()
        }
    }
    
    private func reloadView() {
        self.tableView.reloadData()
    }
}
