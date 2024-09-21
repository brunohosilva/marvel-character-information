//
//  MainViewController.swift
//  marvel-character-information
//
//  Created by Bruno Oliveira on 21/09/24.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupTabBar()
    }

    private func setupViews() {
        let summaryVC = MarvelCharactersViewController()
        let favorites = FavoritesViewController()

        summaryVC.setTabBarImage(imageName: "list.dash.header.rectangle", title: "Summary")
        favorites.setTabBarImage(imageName: "heart.square.fill", title: "Favorites")

        let summaryNC = UINavigationController(rootViewController: summaryVC)
        let favoritesNC = UINavigationController(rootViewController: favorites)
        
        hideNavigationBarLine(summaryNC.navigationBar)
        
        let tabBarList = [summaryNC, favoritesNC]

        viewControllers = tabBarList
    }
    
    private func hideNavigationBarLine(_ navigationBar: UINavigationBar) {
        let img = UIImage()
        navigationBar.shadowImage = img
        navigationBar.setBackgroundImage(img, for: .default)
        navigationBar.isTranslucent = false
    }
    
    private func setupTabBar() {
        tabBar.tintColor = .systemBlue
        tabBar.isTranslucent = false
    }
}

class FavoritesViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemOrange
        self.title = "Favorites" // Define o título da navigation bar para a tela de favoritos
    }
}

