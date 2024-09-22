//
//  SearchView.swift
//  marvel-character-information
//
//  Created by Bruno Oliveira on 21/09/24.
//

import UIKit

protocol SearchViewControllerDelegate: AnyObject {
    func didUpdateSearchQuery(_ query: String)
}

class SearchViewController: UIViewController, UITextFieldDelegate {
    
    weak var delegate: SearchViewControllerDelegate?
    var searchTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchTextField()
    }
    
    private func setupSearchTextField() {
        searchTextField.placeholder = "Search Marvel characters..."
        searchTextField.borderStyle = .roundedRect
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.delegate = self // Definindo o delegado
        view.addSubview(searchTextField)
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // Método chamado quando o Return é pressionado
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Fecha o teclado
        
        guard let query = textField.text, !query.isEmpty else { return true }
        delegate?.didUpdateSearchQuery(query) // Chama a delegate com a query
        return true
    }
}

