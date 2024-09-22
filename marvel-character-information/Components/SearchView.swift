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

class SearchViewController: UIViewController {
    
    weak var delegate: SearchViewControllerDelegate?
    var searchTextField = UITextField()
    var searchTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchTextField()
    }
    
    private func setupSearchTextField() {
        searchTextField.placeholder = "Search Marvel characters..."
        searchTextField.borderStyle = .roundedRect
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        view.addSubview(searchTextField)
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        searchTimer?.invalidate()
        
        searchTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(triggerSearchRequest), userInfo: nil, repeats: false)
    }
    
    @objc private func triggerSearchRequest() {
        guard let query = searchTextField.text, !query.isEmpty else { return }
        delegate?.didUpdateSearchQuery(query)
    }
}
