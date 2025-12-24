//
//  FavoriteView.swift
//  FilmsApp
//
//  Created by Владимир Царь on 15.11.2025.
//

import UIKit

class FavoriteView: UIViewController {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MovieCollectionViewFavoriteCell.self, forCellWithReuseIdentifier: "MovieCollectionViewFavoriteCell")
        return collectionView
    }()
    
    override func loadView() {
        super.loadView()
        setupUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("🔵 FavoriteView: viewDidLoad")
        printDataStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("🟡 FavoriteView: viewWillAppear")
        
        DataBaseManager.shared.fetchFilms()
        printDataStatus()
        
        collectionView.reloadData()
        print("🔄 Коллекция перезагружена")
    }
    
    private func printDataStatus() {
        print("📊 В DataBaseManager.shared.films: \(DataBaseManager.shared.films.count) элементов")
        DataBaseManager.shared.films.forEach { film in
            print("   🎬 \(film.title ?? "Без названия")")
        }
    }
    
    
    func setupUI() {
        view.addSubviews(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor.systemPurple.cgColor,
            UIColor.systemBlue.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension FavoriteView: UICollectionViewDelegate {
    
    // Context Menu при долгом нажатии
    func collectionView(_ collectionView: UICollectionView,
                       contextMenuConfigurationForItemAt indexPath: IndexPath,
                       point: CGPoint) -> UIContextMenuConfiguration? {
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            
            let deleteAction = UIAction(
                title: "Удалить из избранного",
                image: UIImage(systemName: "trash"),
                attributes: .destructive
            ) { [weak self] action in
                self?.deleteFilm(at: indexPath)
            }
            
            let shareAction = UIAction(
                title: "Поделиться",
                image: UIImage(systemName: "square.and.arrow.up")
            ) { [weak self] action in
                self?.shareFilm(at: indexPath)
            }
            
            return UIMenu(title: "", children: [shareAction, deleteAction])
        }
    }
    
    private func deleteFilm(at indexPath: IndexPath) {
        let film = DataBaseManager.shared.films[indexPath.item]
        let filmTitle = film.title ?? "фильм"
        
        let alert = UIAlertController(
            title: "Удалить фильм?",
            message: "Вы уверены, что хотите удалить \"\(filmTitle)\"?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive) { _ in
            film.deleteFilm()
            DataBaseManager.shared.fetchFilms()
            
            // Анимированное удаление
            UIView.animate(withDuration: 0.3, animations: {
                self.collectionView.deleteItems(at: [indexPath])
            })
        })
        
        present(alert, animated: true)
    }
    
    private func shareFilm(at indexPath: IndexPath) {
        let film = DataBaseManager.shared.films[indexPath.item]
        let text = "Посмотрите фильм \"\(film.title ?? "этот фильм")\"!"
        
        let activityVC = UIActivityViewController(
            activityItems: [text],
            applicationActivities: nil
        )
        
        present(activityVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = DataBaseManager.shared.films[indexPath.item]
        print(item)
    }

}

extension FavoriteView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        DataBaseManager.shared.films.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewFavoriteCell", for: indexPath) as? MovieCollectionViewFavoriteCell else { return UICollectionViewCell() }
        let movie = DataBaseManager.shared.films[indexPath.item]
        cell.configure(with: movie)
        return cell
    }
    
    
}

extension FavoriteView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 32 // Отступы слева и справа
        return CGSize(width: width, height: 160) // ШИРОКАЯ ЯЧЕЙКА ДЛЯ ВЕРТИКАЛЬНОГО СКРОЛЛА
    }
}
