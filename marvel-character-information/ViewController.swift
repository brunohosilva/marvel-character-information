//
//  ViewController.swift
//  marvel-character-information
//
//  Created by Bruno Oliveira on 19/09/24.
//

import UIKit

class ViewController: UIViewController {
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Hello, ViewCode!"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // Adicionando a label na hierarquia da view
        view.addSubview(label)
        
        // Definir as constraints da label
        setupConstraints()
        
        var webservice: FetchMarvelCharactersProtocol = FetchMarvelCharacters()
        webservice.fetchProfile { result in
            switch result {
            case .success(let characters):
                print("characters -->", characters)
            case .failure(let error):
                print("error -->", error)
            }
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}


