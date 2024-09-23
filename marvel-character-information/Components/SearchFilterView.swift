//
//  SearchFilterView.swift
//  marvel-character-information
//
//  Created by Bruno Oliveira on 22/09/24.
//

import UIKit

class SearchFilterView: UIView {

    private let textField = UITextField()
    public var data: [String] = []
    private var filteredData: [String] = []
    var onFilter: (([String]) -> Void)?

    init(data: [String]) {
        super.init(frame: .zero)
        self.data = data
        setupTextField()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTextField() {
        textField.placeholder = "Filter..."
        textField.borderStyle = .roundedRect
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        addSubview(textField)

        // Layout
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                   textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    @objc private func textDidChange() {
        guard let searchText = textField.text?.lowercased(), !searchText.isEmpty else {
            filteredData = data
            onFilter?(filteredData)
            return
        }

        filteredData = data.filter { $0.lowercased().contains(searchText) }
        onFilter?(filteredData)
    }
}

