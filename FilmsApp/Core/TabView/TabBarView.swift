//  TabView.swift
//  FilmsApp
//
//  Created by Владимир Царь on 15.11.2025.

import UIKit

class TabBarView: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBars()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Обновляем frame градиента после автолейаута
        if let gradientLayer = tabBar.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = tabBar.bounds
        }
    }
    
    private func setupTabBars() {
        let mainView = Builder.makeMainView()
        mainView.tabBarItem.title = "Главная"
        mainView.tabBarItem.image = UIImage(systemName: "house")?
            .withTintColor(.white, renderingMode: .alwaysOriginal)
        mainView.tabBarItem.selectedImage = UIImage(systemName: "house.fill")?
            .withTintColor(.white, renderingMode: .alwaysOriginal)
        // Опускаем иконку на 5 пикселей
        mainView.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        
        let favoritView = FavoriteView()
        favoritView.tabBarItem.title = "Избранное"
        favoritView.tabBarItem.image = UIImage(systemName: "bookmark")?
            .withTintColor(.white, renderingMode: .alwaysOriginal)
        favoritView.tabBarItem.selectedImage = UIImage(systemName: "bookmark.fill")?
            .withTintColor(.white, renderingMode: .alwaysOriginal)
        // Опускаем иконку на 5 пикселей
        favoritView.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        
        let mapView = Builder.makeMapView()
        mapView.tabBarItem.title = "Карта"
        mapView.tabBarItem.image = UIImage(systemName: "map")?
            .withTintColor(.white, renderingMode: .alwaysOriginal)
        mapView.tabBarItem.selectedImage = UIImage(systemName: "map.fill")?
            .withTintColor(.white, renderingMode: .alwaysOriginal)
        
        setViewControllers([mainView, favoritView, mapView], animated: true)
        
        setupGradientTabBar()
        setupAppearance()
    }
    
    private func setupGradientTabBar() {
        // Красивый градиент от фиолетового к синему
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = tabBar.bounds
        gradientLayer.colors = [
            UIColor(red: 0.58, green: 0.18, blue: 0.97, alpha: 1.00).cgColor, // Красивый фиолетовый
            UIColor(red: 0.20, green: 0.47, blue: 0.95, alpha: 1.00).cgColor  // Красивый синий
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.cornerRadius = 20
        gradientLayer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        // Удаляем старый градиент если есть
        tabBar.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        tabBar.layer.insertSublayer(gradientLayer, at: 0)
        
        // Добавляем легкую тень для красоты
        tabBar.layer.shadowColor = UIColor.systemPurple.cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
        tabBar.layer.shadowRadius = 8
        tabBar.layer.shadowOpacity = 0.3
    }
    
    private func setupAppearance() {
        // Настройка цветов текста
        tabBar.tintColor = .white // Цвет выбранной иконки
        tabBar.unselectedItemTintColor = UIColor.white.withAlphaComponent(0.7) // Цвет невыбранных иконок
        
        // Настройка текста
        let attributesNormal: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white.withAlphaComponent(0.7),
            .font: UIFont.systemFont(ofSize: 12, weight: .medium)
        ]
        
        let attributesSelected: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 12, weight: .bold)
        ]
        
        UITabBarItem.appearance().setTitleTextAttributes(attributesNormal, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(attributesSelected, for: .selected)
        
        // Делаем таб-бар полупрозрачным для красоты
        tabBar.isTranslucent = true
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        
        // Закругляем углы таб-бара
        tabBar.layer.cornerRadius = 20
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabBar.clipsToBounds = false
    }
}
