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
        view.backgroundColor = .lightGray
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
        setupTableView()
        setupActivityIndicator()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = .clear
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
        viewModel.getMarvelCharacters()
        
        viewModel.onCharactersFetched = { [weak self] characters in
            guard let self else { return }
            self.characters = characters
            self.isLoaded = true
            reloadView()
        }
    }
    
    private func reloadView() {
        activityIndicator.stopAnimating()
        loadingLabel.isHidden = true
        self.tableView.reloadData()
    }
}
