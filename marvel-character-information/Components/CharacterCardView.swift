//
//  CharacterCardView.swift
//  marvel-character-information
//
//  Created by Bruno Oliveira on 19/09/24.
//

import UIKit

class CharacterCardView: UITableViewCell {
    
    static let characterCardID = "characterCardID"
    
    // MARK: - Propriedades
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5) // Cor preta com 50% de opacidade
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .white // Deixar o texto visível sobre o fundo
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 6 // Limite de 6 linhas
        label.lineBreakMode = .byTruncatingTail // Coloca reticências no fim
        label.textColor = .white // Deixar o texto visível sobre o fundo
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Inicializadores
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Configuração da View
    private func setupView() {
        backgroundColor = .clear // Fundo da célula transparente para ver a imagem
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        
        // Adicionar a imagem de fundo
        contentView.addSubview(backgroundImageView)
        
        // Adicionar o overlay
        contentView.addSubview(overlayView)
        
        // Adicionar o título e descrição acima do overlay
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Constraints para a imagem de fundo
            backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // Constraints para o overlay
            overlayView.topAnchor.constraint(equalTo: contentView.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // Definir um tamanho fixo para o card
            contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            contentView.heightAnchor.constraint(equalToConstant: 200),
            
            // Constraints para o título
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Constraints para a descrição
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    func configure(title: String, description: String, backgroundImageURL: String?) {
        titleLabel.text = title
        descriptionLabel.text = description
        // Verifica se a URL da imagem é válida e baixa a imagem
        if let urlString = backgroundImageURL, let url = URL(string: urlString) {
            downloadImage(from: url)
        }
    }
    
    private func downloadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            if let data = data, error == nil, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.backgroundImageView.image = image
                }
            }
        }.resume()
    }
}
